//
//  AppDelegate.swift
//  TapResearchSwiftDemoNotifications
//
//  Created by Jeroen Verbeek on 12/7/20.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var tapResearchApiToken = "<<YOUR_API_TOKEN>>"
    var tapHandler: TapHandler!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        tapHandler = TapHandler(with: tapResearchApiToken)

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}


