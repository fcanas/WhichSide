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
