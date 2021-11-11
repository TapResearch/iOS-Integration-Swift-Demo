//
//  ViewController.swift
//  TapResearchSwiftDemo
//
//  Created by Jeroen Verbeek on 12/7/20.
//

import UIKit
import TapResearchSDK

class ViewController: UIViewController, TapResearchSurveyDelegate, TapResearchRewardDelegate, TapResearchPlacementDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var surveyButton: UIButton!
    
    var tapResearchPlacement: TRPlacement?
    
    var apiToken = "7d08c962b40ac7aa0cf83c4d376fa36f"
    var uniqueIdentifier = "Nascar"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        surveyButton.layer.cornerRadius = 10
        surveyButton.alpha = 0.0
        activityIndicator.startAnimating()
        
        self.initSDK()
    }

    func initSDK() {
        TapResearch.initWithApiToken(apiToken, rewardDelegate: self, placementDelegate: self)
        TapResearch.setUniqueUserIdentifier(uniqueIdentifier)
    }
    
    func showSurveyAvailableButton() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.surveyButton.alpha = 1.0
            } completion: { _ in
                self.surveyButton.alpha = 1.0
                self.activityIndicator.stopAnimating()
            }            
        }
    }
    
    func showNotificationDialog(title: String, message: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOkAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (_: UIAlertAction) in }
        alertController.addAction(alertOkAction)
        present(alertController, animated: true, completion: nil)
    }

    //MARK:- Actions and button handlers
    
    @IBAction func handleSurveySelected() {
        tapResearchPlacement?.showSurveyWall(with: self)
    }
    
    //MARK:- TapResearch Delegates
    
    func tapResearchDidReceive(_ rewards: [TRReward]) {
        print("Reward Received!")
        
        if let reward = rewards.first {
            let message: String = String(format:"You have just received %lu %@ for your efforts.", reward.rewardAmount, reward.currencyName)
            showNotificationDialog(title: "Congrats!", message: message)
        }
    }
    
    func placementReady(_ placement: TRPlacement) {
        if tapResearchPlacement == nil && placement.isSurveyWallAvailable {
            tapResearchPlacement = placement
            showSurveyAvailableButton()
        }
    }
    
    func placementUnavailable(_ placementId: String) {
        print("Placement Unavailable")
    }
    
    //MARK:- TapResearchSurveyDelegate

    func tapResearchSurveyWallOpened(with placement: TRPlacement) {
        print("Survey wall opened")
    }

    func tapResearchSurveyWallDismissed(with placement: TRPlacement) {
    
        print("Survey wall dismissed")
        
        // TRPlacemnt will be disabled after the survey wall was visible.
        // If you want to show the placement again you'll have to initialize it again
        initSDK()
    }
}

