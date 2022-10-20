//
//  PlacementSelectorVC.swift
//  Ivy
//
//  Created by Jeroen Verbeek on 10/5/22.
//  Copyright © 2022 Kevin Chang. All rights reserved.
//

import UIKit
import TapResearchSDK

class PlacementSelectorVC : UIViewController,
                            PlacementCellDelegate,
                            UITableViewDataSource,
                            UITableViewDelegate
{
    
    var tapResearchApiToken = "d425e0ebe93444912da2e121ae20c446"
    var uniqueUserIdentifier = "test_player_identifier"
    
    @IBOutlet weak var tableView    : UITableView!
    
    var placements = [String : TRPlacement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSDK()
    }
    
    private var buildCustomParameters: TRPlacementCustomParameterList = {
        
        let paramsList = TRPlacementCustomParameterList()
        
        let value = "<VALUE>"
        let key = "<KEY>"
        let param = TRPlacementCustomParameter()
        param.builder().key(key).value(value).build()
        paramsList.add(param)
        
        return paramsList
    }()
    
    func initSDK() {
        
        //SDK must be initialized with an api token and uniqueIdentifier
        TapResearch.initWithApiToken(tapResearchApiToken, rewardDelegate: self, placementDelegate: self)
        TapResearch.setUniqueUserIdentifier(uniqueUserIdentifier)
    }
    
    func displayEventSelected(_ indexPath: IndexPath) {
        
        let placement: TRPlacement = Array(placements.values)[indexPath.row]
        if let event: TREvent = placement.events?[0] as? TREvent {
            let params = buildCustomParameters
            placement.displayEvent(event.identifier, withDisplay: self, surveyDelegate: self, customParameters: params)
        }
    }
    
    //MARK: - UITableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let placement: TRPlacement = Array(placements.values)[indexPath.row]
        let params = buildCustomParameters
        placement.showSurveyWall(with: self, customParameters: params)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let placement: TRPlacement = Array(placements.values)[indexPath.row]
        return PlacementCell.cell(tableView: tableView, indexPath: indexPath, placement: placement, delegate: self)
    }
    
}

//MARK: - TapResearchSurveyDelegate
extension PlacementSelectorVC : TapResearchSurveyDelegate {
    
    func tapResearchSurveyWallOpened(with placement: TRPlacement) {
    }
    
    func tapResearchSurveyWallDismissed(with placement: TRPlacement) {
        self.dismiss(animated: true)
    }
    
}

//MARK: - TapResearchEventDelegate
extension PlacementSelectorVC : TapResearchEventDelegate {
    
    func tapResearchEventOpened(with placement: TRPlacement) {
    }
    
    func tapResearchEventDismissed(with placement: TRPlacement) {
        self.dismiss(animated: true)
    }
    
}

//MARK: - TapResearchPlacementDelegate
extension PlacementSelectorVC : TapResearchPlacementDelegate {
    
    func placementReady(_ placement: TRPlacement) {
        print("Placement Available! \(placement.placementIdentifier)")
        
        placements[placement.placementIdentifier] = placement
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func placementUnavailable(_ placementId: String) {
        print("Placement Unavailable! \(placementId)")
        
        placements.removeValue(forKey: placementId)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension PlacementSelectorVC : TapResearchRewardDelegate {
    
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
        var i = 1 // 1 to matchup with count value for keys
        let c = values.keys.count
        
        values.forEach {
            string += "\($0.value) \($0.key)"
            switch i {
                case c - 1: string += " and "
                case c: string += " for your efforts!"
                default: string += ", "
            }
            i += 1
        }
        
        presentAlert(title: "Congrats!", message: string)
    }
    
    func presentAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true)
        }
    }
    
}

