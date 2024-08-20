//
//  PlacementSelectorVC.swift
//
//
//  Created by Jeroen Verbeek on 10/5/22.
//  Copyright © 2022 TapResearch. All rights reserved.
//

import UIKit
import TapResearchSDK

class PlacementSelectorVC : UIViewController,
                            PlacementCellDelegate,
                            UITableViewDataSource,
                            UITableViewDelegate
{

    var uniqueUserIdentifier = "<<USER_IDENTIFIER>>"

    @IBOutlet weak var tableView: UITableView!

    //MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        TapHandler.shared.delegate = self
        TapResearch.setUniqueUserIdentifier(uniqueUserIdentifier)
    }

    //MARK: -

    private var buildCustomParameters: TRPlacementCustomParameterList = {

        let paramsList = TRPlacementCustomParameterList()
        
        let value = "<VALUE>"
        let key = "<KEY>"
        let param = TRPlacementCustomParameter()
        param.builder().key(key).value(value).build()
        paramsList.add(param)
        
        return paramsList
    }()

    func displayEventSelected(_ indexPath: IndexPath) {
        
        let placement: TRPlacement = Array(TapHandler.shared.placements.values)[indexPath.row]
        if let event: TREvent = placement.events?[0] as? TREvent {
            let params = buildCustomParameters
            placement.displayEvent(event.identifier, withDisplay: self, surveyDelegate: self, customParameters: params)
        }
    }
    
    //MARK: - UITableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let placement: TRPlacement = Array(TapHandler.shared.placements.values)[indexPath.row]
        let params = buildCustomParameters
        placement.showSurveyWall(with: self, customParameters: params)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TapHandler.shared.placements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let placement: TRPlacement = Array(TapHandler.shared.placements.values)[indexPath.row]
        return PlacementCell.cell(tableView: tableView, indexPath: indexPath, placement: placement, delegate: self)
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

//MARK: - TapHandler delegate

extension PlacementSelectorVC : TapHandlerDelegate {

    func tapHandlerDidReceiveRewards(rewardText: String) {

        DispatchQueue.main.async(execute: { () -> Void in
            self.presentAlert(title: "Reward Received", message: rewardText)
        })
    }

    func tapHandlerDidUpdatePlacements() {

        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
    }

}
