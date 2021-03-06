//
//  AppDelegate.swift
//  Real News
//
//  Created by John Smith on 12/30/16.
//  Copyright © 2016 John Smith. All rights reserved.
//

import UIKit
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle=UIStatusBarStyle.lightContent
        self.window = UIWindow(frame:UIScreen.main.bounds)
        let topStoriesViewController = StoriesViewController()
        let newStoriesViewController = StoriesViewController()
        let askStoriesViewController = StoriesViewController()
        let bestStoriesViewController = StoriesViewController()
        let jobStoriesViewController = StoriesViewController()
        let showStoriesViewController = StoriesViewController()
        let aboutViewController = AboutViewController()
        let licensesViewController = LicensesViewController()
        aboutViewController.title = "About"
        licensesViewController.title = "Licenses"
        topStoriesViewController.storiesType = StoriesType.topStories
        newStoriesViewController.storiesType = StoriesType.newStories
        askStoriesViewController.storiesType = StoriesType.askStories
        bestStoriesViewController.storiesType = StoriesType.bestStories
        jobStoriesViewController.storiesType = StoriesType.jobStories
        showStoriesViewController.storiesType = StoriesType.showStories
        let rootVC = SimpleTabBarViewController()
        rootVC.viewControllers = [topStoriesViewController,newStoriesViewController,askStoriesViewController,bestStoriesViewController,jobStoriesViewController,showStoriesViewController,aboutViewController,licensesViewController]
        self.window!.rootViewController = rootVC
        self.window!.makeKeyAndVisible()
        
        IAPcompleteTransaction()
        if SwiftyStoreKit.localReceiptData != nil{
            verifyPurchase(.autoRenewablePurchase, self: nil)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

