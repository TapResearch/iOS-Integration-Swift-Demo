//
//  ViewController.swift
//  TapResearchSwiftDemo
//
//  Created by Jeroen Verbeek on 12/7/20.
//

import UIKit
import TapResearchSDK

///---------------------------------------------------------------------------------------------
class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var surveyButton: UIButton!
    
    var apiToken = "7d08c962b40ac7aa0cf83c4d376fa36f"
    var uniqueIdentifier = "Nascar"
    var placements: [String:TRPlacement] = [:]

    //MARK: -

    ///---------------------------------------------------------------------------------------------
   override func viewDidLoad() {
        super.viewDidLoad()
        
        surveyButton.layer.cornerRadius = 10
        surveyButton.alpha = 0.0
        activityIndicator.startAnimating()
        
        self.initSDK()
    }
    
    ///---------------------------------------------------------------------------------------------
    /// SDK must be initialized with an api token and uniqueIdentifier as well as reward and placment delegates.
    func initSDK() {
        
        TapResearch.initWithApiToken(apiToken, rewardDelegate: self, placementDelegate: self)
        TapResearch.setUniqueUserIdentifier(uniqueIdentifier)
    }

    //MARK: - Actions and button handlers
    
    ///---------------------------------------------------------------------------------------------
    /// present survey wall only when surveys are available.
    @IBAction func handleSurveySelected() {
        
        if !placements.isEmpty {
            if placements.values.count == 1 {
                placements.values.first?.showSurveyWall(with: self)
            }
            else {
                let alert: UIAlertController = UIAlertController(title: "TapResearch", message: "Choose an available placememt", preferredStyle: .alert)
                for key: String in placements.keys {
                    alert.addAction(UIAlertAction(title: key, style: .default) { (action: UIAlertAction) in
                        if let title: String = action.title {
                            self.placements[title]?.showSurveyWall(with: self)
                        }
                    })
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }

}

//MARK: - TapResearchSurveyDelegate

///---------------------------------------------------------------------------------------------
extension ViewController : TapResearchSurveyDelegate {
    
    ///---------------------------------------------------------------------------------------------
    /// This delegate is called when the survey wall is opened.
   func tapResearchSurveyWallOpened(with placement: TRPlacement) {
        print("TapResearch: Modal opened with placement \(placement.placementIdentifier ?? "")")
    }
    
    ///---------------------------------------------------------------------------------------------
    /// This delegate is called when the survey wall is dismissed by the user.
  func tapResearchSurveyWallDismissed(with placement: TRPlacement) {
        print("TapResearch: Modal dismissed with placement \(placement.placementIdentifier ?? "")")
    }

}

//MARK: - TapResearchPlacementDelegate

///---------------------------------------------------------------------------------------------
extension ViewController : TapResearchPlacementDelegate {
    
    ///---------------------------------------------------------------------------------------------
    /// After the SDK is initialized, this delegate is called for each placement.
    func placementReady(_ placement: TRPlacement) {
        print("TapResearch: Placement Ready! \(placement.placementIdentifier ?? ""), wall \(placement.isSurveyWallAvailable), hot \(placement.hasHotSurvey), maxlen \(placement.maxSurveyLength), plcode \(placement.placementCode)")
        
        placements[placement.placementIdentifier] = placement
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.surveyButton.alpha = 1.0
            } completion: { _ in
                self.surveyButton.alpha = 1.0
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    ///---------------------------------------------------------------------------------------------
    /// If the placement is not available for any reason, this delegate is called.
    func placementUnavailable(_ placementId: String) {
        print("TapResearch: Placement Unavailable! \(placementId)")
        
        placements.removeValue(forKey: placementId)
        
        if placements.isEmpty {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                    self.surveyButton.alpha = 0.0
                } completion: { _ in
                    self.surveyButton.alpha = 0.0
                    self.activityIndicator.startAnimating()
                }
            }
        }
    }
    
}

//MARK: - TapResearchRewardDelegate

///---------------------------------------------------------------------------------------------
extension ViewController : TapResearchRewardDelegate {
    
    ///---------------------------------------------------------------------------------------------
    /// When there are rewards this delegate is called with an array of TRReward objects.
    func tapResearchDidReceive(_ rewards: [TRReward]) {
        print("Rewards (\(rewards.count) Received!)")
        
        var values: [AnyHashable : Any] = [:]
        
        rewards.forEach({
            if values[$0.currencyName] != nil {
                if var value = values[$0.currencyName] as? Int {
                    value += $0.rewardAmount
                    values[$0.currencyName] = $0.rewardAmount
                }
            } else {
                values[$0.currencyName] = $0.rewardAmount
            }
        })
        
        var string = "You have just received "
        var i = 1
        let c = values.keys.count
        
        values.forEach {
            if let currencyName: String = $0.key as? String {
                string += "\($0.value) \(currencyName)"
                switch i {
                    case c - 1: string += " and "
                    case c: string += " for your efforts!"
                    default: string += ", "
                }
                i += 1
            }
        }
        
        presentAlert(title: "Congrats!", message: string)
    }
    
    ///---------------------------------------------------------------------------------------------
    func presentAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(action)
            if let sceneDelegate = UIApplication.shared.windows[0].windowScene?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController?.present(controller, animated: true)
            }
        }
    }
    
}
