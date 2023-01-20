//
//  AppDelegate.swift
//  MoviesList
//
//  Created by Anton Stremovskiy on 19.01.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        let navigationVc = UINavigationController(rootViewController: mainViewController)
        self.window?.rootViewController = navigationVc
        
        return true
    }
}

