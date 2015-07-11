//
//  AppDelegate.swift
//  WhichSide
//
//  Created by Fabian Canas on 7/5/15.
//  Copyright (c) 2015 Fabián Cañas. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId(ParseAppID, clientKey: ParseAppKey)
        
        let setACL = { PFACL.setDefaultACL(PFACL(user: $0), withAccessForCurrentUser: true) }
        
        if let user = PFUser.currentUser() {
            setACL(user)
        } else {
            PFAnonymousUtils.logInWithBlock { (user, error) in
                map(user) { setACL($0) }
            }
        }
        
        return true
    }
    
}
