//
//  eventDetailsTableViewCell.swift
//  FCI
//
//  Created by Abanob Wadie on 8/6/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class eventDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var detailsTxt: UITextView!
    @IBOutlet weak var detailsTxtHieght: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
