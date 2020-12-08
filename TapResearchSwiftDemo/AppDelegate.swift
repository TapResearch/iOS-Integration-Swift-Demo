//
//  AppDelegate.swift
//  TapResearchSwiftDemo
//
//  Created by Jeroen Verbeek on 12/7/20.
//

import UIKit
import TapResearchSDK

let tapResearchApiToken: String = "API_TOKEN"
let tapResearchPlacementIdentifier: String = "PLACEMENT_IDENTIFIER"

let userIdentifier: String = "<User Identifier>"

@main
class AppDelegate: UIResponder,
                   UIApplicationDelegate,
                   TapResearchRewardDelegate
{

    //---------------------------------------------------------------------------------------------
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        TapResearch.initWithApiToken(tapResearchApiToken, delegate: self)
        TapResearch.setUniqueUserIdentifier(userIdentifier)

        return true
    }

    //MARK:- UISceneSession Lifecycle

    //---------------------------------------------------------------------------------------------
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    //---------------------------------------------------------------------------------------------
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    //MARK:-

    //---------------------------------------------------------------------------------------------
    func showNotificationDialog(title: String, message: String) {

        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertOkAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (_: UIAlertAction) in }
        alertController.addAction(alertOkAction)
    
        if let window: UIWindow = UIApplication.shared.windows.first(where: { (window: UIWindow) -> Bool in window.isKeyWindow}) {
            window.rootViewController?.present(alertController, animated: true, completion: { })
        }
    }
    
    //MARK:- TapResearch delegates
    
    //---------------------------------------------------------------------------------------------
    func tapResearchDidReceive(_ reward: TRReward) {
        
        print("Reward Received!")
        let message: String = String(format:"You have just received %lu %@ for your efforts.", reward.rewardAmount, reward.currencyName)
        showNotificationDialog(title: "Congrats!", message: message)
    }
    
}


