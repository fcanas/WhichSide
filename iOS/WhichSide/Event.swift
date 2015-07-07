//
//  Event.swift
//  WhichSide
//
//  Created by Fabian Canas on 7/6/15.
//  Copyright (c) 2015 Fabián Cañas. All rights reserved.
//

import UIKit
import Parse

enum Side: String {
    case L = "L"
    case R = "R"
}

struct Event {
    let timestamp :NSDate
    let side :Side
}

extension Event : Model { // TODO: Use mirror types in Swift 2.0 to provide a default implementaitons
    static func className() -> String {
        return "Event"
    }
    init?(model: PFObject) {
        if let timestamp = model["timestamp"] as? NSDate, let side = flatMap(model["side"] as? String, { Side(rawValue: $0) }) {
            self = Event(timestamp: timestamp, side: side)
            return
        }
        return nil
    }
    func apply(obj :PFObject) {
        obj["timestamp"] = timestamp
        obj["side"] = side.rawValue
    }
}

/// Parse Model Methods

protocol Model {
    static func className() -> String // TODO: Make this a property with Swift 2.0?
    init?(model :PFObject)
    
    func apply(obj :PFObject)
}

func all<T :Model>( callback: ([T]) -> Void ) { // TODO: Make this a method with Swift 2.0?
    PFQuery(className: T.className()).findObjectsInBackgroundWithBlock { (results, error) -> Void in
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

func save<T: Model>(model :T) {
    let obj = PFObject(className: T.className())
    model.apply(obj)
    obj.saveInBackgroundWithBlock(nil)
}