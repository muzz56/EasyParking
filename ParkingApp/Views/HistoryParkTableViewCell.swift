//
//  HistoryParkTableViewCell.swift
//  ParkingApp
//
//  Created by Graphic on 2021-05-22.
//

import UIKit

class HistoryParkTableViewCell: UITableViewCell {


    @IBOutlet weak var lblCarPlate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
