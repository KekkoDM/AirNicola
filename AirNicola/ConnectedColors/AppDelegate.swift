//
//  AppDelegate.swift
//  ConnectedColors
//
//  Created by Gianluca Annina on 03/12/21.
//
import UIKit
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      

        application.beginBackgroundTask(withName: "showNotification", expirationHandler: nil)
        return true
    }
}
