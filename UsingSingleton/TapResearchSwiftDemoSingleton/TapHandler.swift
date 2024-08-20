//
//  TapHandler.swift
//  TapResearchSwiftDemoSingleton
//
//  Created by Jeroen Verbeek on 8/15/24.
//

import UIKit
import TapResearchSDK

protocol TapHandlerDelegate {
    func tapHandlerDidReceiveRewards(rewardText: String)
    func tapHandlerDidUpdatePlacements()
}

class TapHandler : NSObject, TapResearchPlacementDelegate, TapResearchRewardDelegate {

    static let shared = TapHandler()

    var delegate: TapHandlerDelegate?
    var placements: [String: TRPlacement] = [:]

    override init() {
        super.init()
    }

   func  initSDK(_ apiToken: String) {

        TapResearch.initWithApiToken(apiToken, rewardDelegate: self, placementDelegate: self)
    }

    func placementReady(_ placement: TRPlacement) {
        print("Placement Available! \(placement.placementIdentifier)")

        placements[placement.placementIdentifier] = placement
        delegate?.tapHandlerDidUpdatePlacements()
    }

    func placementUnavailable(_ placementId: String) {
        print("Placement Unavailable! \(placementId)")

        placements.removeValue(forKey: placementId)
        delegate?.tapHandlerDidUpdatePlacements()
    }

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
            let name: String = $0.key as? String ?? ""
            string += "\($0.value) \(name)"
            switch i {
                case c - 1: string += " and "
                case c: string += " for your efforts!"
                default: string += ", "
            }
            i += 1
        }

        delegate?.tapHandlerDidReceiveRewards(rewardText: string)
    }

}

