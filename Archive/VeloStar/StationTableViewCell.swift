//
//  StationTableViewCell.swift
//  VeloStar
//
//  Created by Baptiste Alexandre on 23/05/2018.
//  Copyright © 2018 ALXDR. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var nbAvailableSlotsLabel: UILabel!
    @IBOutlet weak var nbAvailableBikesLabel: UILabel!
    @IBOutlet weak var stationDistanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
