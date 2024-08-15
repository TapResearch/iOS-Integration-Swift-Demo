//
//  PlacementSelectorCell.swift
//  TapResearchSwiftDemoNotifications
//
//  Created by Jeroen Verbeek on 10/19/22.
//

import UIKit
import TapResearchSDK

protocol PlacementCellDelegate {
    func displayEventSelected(_ indexPath: IndexPath)
}

class PlacementCell: UITableViewCell {
    
    @IBOutlet weak var placementLabel   : UILabel?
    @IBOutlet weak var eventDetailLabel : UILabel?
    @IBOutlet weak var eventButton      : UIButton?
    
    var indexPath: IndexPath!
    var delegate: PlacementCellDelegate?
    
    class func cell(tableView: UITableView, indexPath: IndexPath, placement: TRPlacement, delegate: PlacementCellDelegate!) -> PlacementCell {
        
        var cell: PlacementCell? = tableView.dequeueReusableCell(withIdentifier: "PlacementCell") as? PlacementCell
        if(cell == nil) {
            cell = PlacementCell(style: .default, reuseIdentifier: "PlacementCell")
        }
        cell?.fillCell(placement, indexPath: indexPath, delegate: delegate)
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventButton?.layer.borderColor = UIColor.systemBlue.cgColor
        eventButton?.layer.borderWidth = 1
        eventButton?.layer.cornerRadius = 7
        eventButton?.setTitleColor(UIColor.systemBlue, for: .normal)
        eventButton?.tintColor = UIColor.systemBlue
    }
    
    func fillCell(_ placement: TRPlacement, indexPath: IndexPath, delegate: PlacementCellDelegate?) {
        
        self.indexPath = indexPath
        self.delegate = delegate
        
        placementLabel?.text = placement.placementIdentifier
        eventDetailLabel?.text = " \(placement.events?.count ?? 0) TREvents"
        if placement.events?.count ?? 0 > 0 {
            eventButton?.isHidden = false
        }
        else {
            eventButton?.isHidden = true
        }
    }
    
    @IBAction func eventbuttonTapped() {
        
        if let ip = indexPath {
            if let del = delegate {
                del.displayEventSelected(ip)
            }
        }
    }
    
}
