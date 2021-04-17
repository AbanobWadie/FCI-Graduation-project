//
//  AppDelegate.swift
//  FCI
//
//  Created by Abanob Wadie on 7/28/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        // Override point for customization after application launch.
        return true
    }


}

