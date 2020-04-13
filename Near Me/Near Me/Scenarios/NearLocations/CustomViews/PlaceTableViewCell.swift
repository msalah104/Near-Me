//
//  PlaceTableViewCell.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    static let identifier = "PlaceTableViewCell"

    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
