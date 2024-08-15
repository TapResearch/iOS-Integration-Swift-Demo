//
//  TapHandler.swift
//  TapResearchSwiftDemoNotifications
//
//  Created by Jeroen Verbeek on 8/15/24.
//

import UIKit
import TapResearchSDK

class TapHandler : NSObject, TapResearchPlacementDelegate, TapResearchRewardDelegate {

    static let rewardReceivedNotification = NSNotification.Name(rawValue: "RewardReceived")
    static let placementReadyNotification = NSNotification.Name(rawValue: "PlacementReady")
    static let placementUnavailableNotification = NSNotification.Name(rawValue: "PlacementUnavailable")

    var placements: [String: TRPlacement] = [:]

    init(with apiToken: String) {
        super.init()

        TapResearch.initWithApiToken(apiToken, rewardDelegate: self, placementDelegate: self)
    }

    func placementReady(_ placement: TRPlacement) {
        print("Placement Available! \(placement.placementIdentifier)")

        placements[placement.placementIdentifier] = placement

        NotificationCenter.default.post(name: TapHandler.placementReadyNotification, object: nil, userInfo: ["placementStore" : self])
    }

    func placementUnavailable(_ placementId: String) {
        print("Placement Unavailable! \(placementId)")

        placements.removeValue(forKey: placementId)

        NotificationCenter.default.post(name: TapHandler.placementUnavailableNotification, object: nil, userInfo: ["placementStore" : self])
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

        NotificationCenter.default.post(name: TapHandler.rewardReceivedNotification, object: nil, userInfo: ["rewardDisplayString" : string])
    }

}

