//
//  AppDelegate.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 23/01/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Theme.applyTheme()
        
        return true
    }
}

