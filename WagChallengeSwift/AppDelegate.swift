//
//  AppDelegate.swift
//  WagChallengeSwift
//
//  Created by Jaden Nation on 10/13/17.
//  Copyright © 2017 Designer Jeans. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var delegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        RemoteDataController.sharedInstance.updateData(delegate: UserTableViewDataSource.sharedInstance)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.isStatusBarHidden = false
        RemoteDataController.sharedInstance.updateData(delegate: UserTableViewDataSource.sharedInstance)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        RemoteDataController.sharedInstance.updateData(delegate: UserTableViewDataSource.sharedInstance)
        UIApplication.shared.isStatusBarHidden = true
    }
}

