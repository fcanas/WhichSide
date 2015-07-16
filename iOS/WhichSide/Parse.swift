//
//  Parse.swift
//  WhichSide
//
//  Created by Fabian Canas on 7/9/15.
//  Copyright (c) 2015 Fabián Cañas. All rights reserved.
//

import Foundation
import Parse

/// Parse Model Methods

protocol Model {
    static func className() -> String // TODO: Make this a property with Swift 2.0?
    init?(model :PFObject)
    
    func apply(obj :PFObject)
}

enum Constraint {
    case Ascending(String)
    case Descending(String)
    case Exists(String)
    case DoesNotExist(String)
}

extension Constraint :Equatable {}

func == (lhs: Constraint, rhs: Constraint) -> Bool {
    switch (lhs) {
    case .Ascending(let lKey):
        switch (rhs) {
        case .Ascending(let rKey):
            return lKey == rKey
        case .Descending:
            return false
        case .Exists:
            return false
        case .DoesNotExist:
            return false
        }
    case .Descending(let lKey):
        switch (rhs) {
        case .Ascending:
            return false
        case .Descending(let rKey):
            return lKey == rKey
        case .Exists:
            return false
        case .DoesNotExist:
            return false
        }
    case .Exists(let lKey):
        switch (rhs) {
        case .Ascending:
            return false
        case .Descending:
            return false
        case .Exists(let rKey):
            return lKey == rKey
        case .DoesNotExist:
            return false
        }
    case .DoesNotExist(let lKey):
        switch (rhs) {
        case .Ascending:
            return false
        case .Descending:
            return false
        case .Exists:
            return false
        case .DoesNotExist(let rKey):
            return lKey == rKey
        }
    }
}

struct Query<T :Model> {
    let constraints :[Constraint]
    
    init() {
        constraints = []
    }
    
    init(constraints: [Constraint]) {
        self.constraints = constraints
    }
    
    func ascending(key: String) -> Query<T> {
        constraints + [Constraint.Ascending(key)]
        return self
    }
    
    func descending(key: String) -> Query<T> {
        return Query<T>(constraints: constraints + [Constraint.Descending(key)])
    }
    
    func findInBackground(callback: ([T]) -> Void) {
        let q = PFQuery(className: T.className())
        
        map(constraints) { (constraint: Constraint) -> Void in
            switch (constraint) {
            case .Ascending(let key):
                q.addAscendingOrder(key)
                break
            case .Descending(let key):
                q.addDescendingOrder(key)
                break
            case .Exists(let key):
                q.whereKeyExists(key)
                break
            case .DoesNotExist(let key):
                q.whereKeyDoesNotExist(key)
                break
            }
        }
        
        q.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if let results = results {
                callback(reduce(results, Array<T>()) { (var e, obj) in
                    if let pObj = obj as? PFObject, t = T(model: pObj) {
                        return e + [t]
                    }
                    return e
                    })
            }
        }
    }
}

extension Query :Equatable {}

func == <T>(lhs: Query<T>, rhs: Query<T>) -> Bool {
    return lhs.constraints == rhs.constraints
}

func save<T: Model>(model :T) {
    let obj = PFObject(className: T.className())
    model.apply(obj)
    obj.saveInBackgroundWithBlock(nil)
}
