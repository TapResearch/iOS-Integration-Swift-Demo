//
//  AppDelegate.swift
//  TapResearchSwiftDemo
//
//  Created by Jeroen Verbeek on 12/7/20.
//

import UIKit
import TapResearchSDK

//let tapResearchApiToken: String = "API_TOKEN"
//let tapResearchPlacementIdentifier: String = "PLACEMENT_IDENTIFIER"
//
//let userIdentifier: String = "<User Identifier>"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}


