//
//  ViewController.swift
//  TapResearchSwiftDemo
//
//  Created by Jeroen Verbeek on 12/7/20.
//

import UIKit
import TapResearchSDK

class ViewController: UIViewController,
                      TapResearchSurveyDelegate
{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var surveyButton: UIButton!
    
    var tapResearchPlacement: TRPlacement?

    //---------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surveyButton.layer.cornerRadius = 10
        surveyButton.alpha = 0.0
        activityIndicator.startAnimating()
        
        self.initTapResearchPlacement()
    }
    
    //MARK:-

    //---------------------------------------------------------------------------------------------
    func initTapResearchPlacement() {

        TapResearch.initPlacement(withIdentifier: tapResearchPlacementIdentifier) { (placement: TRPlacement) in
            self.tapResearchPlacement = placement
            if placement.isSurveyWallAvailable && placement.placementCode != PLACEMENT_CODE_SDK_NOT_READY {
                self.showSurveyAvailable()
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------
    func showSurveyAvailable() {
        
        UIView.animate( withDuration: 0.5,
                        delay: 0.0,
                        options: .curveEaseInOut,
                        animations: { () -> Void in
                            self.surveyButton.alpha = 1.0
                        },
                        completion: { (done: Bool) -> Void in
                            self.surveyButton.alpha = 1.0
                            self.activityIndicator.stopAnimating()
                        }
        )
    }

    //MARK:- Actions and button handlers
    
    //---------------------------------------------------------------------------------------------
    @IBAction func handleSurveySelected() {
        tapResearchPlacement?.showSurveyWall(with: self)
    }

    //MARK:- TapResearchSurveyDelegate

    //---------------------------------------------------------------------------------------------
    func tapResearchSurveyWallOpened(with placement: TRPlacement) {
        print("Survey wall opened")
    }

    //---------------------------------------------------------------------------------------------
    func tapResearchSurveyWallDismissed(with placement: TRPlacement) {
    
        print("Survey wall dismissed")
        
        // TRPlacemnt will be disabled after the survey wall was visible.
        // If you want to show the placement again you'll have to initialize it again
        initTapResearchPlacement()
    }
    
}

