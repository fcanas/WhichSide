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

struct Query<T :Model> {
    private var query :PFQuery
    
    init() {
        query = PFQuery(className: T.className())
    }
    
    private init(_ query: PFQuery) {
        self.query = query
    }
    
    func ascending(key: String) -> Query<T> {
        return Query(query.addAscendingOrder(key))
    }
    
    func descending(key: String) -> Query<T> {
        return Query(query.addDescendingOrder(key))
    }
    
    func findInBackground(callback: ([T]) -> Void) {
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
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

func save<T: Model>(model :T) {
    let obj = PFObject(className: T.className())
    model.apply(obj)
    obj.saveInBackgroundWithBlock(nil)
}
