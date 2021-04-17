//
//  senderTableViewCell.swift
//  FCI
//
//  Created by Abanob Wadie on 8/9/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class senderTableViewCell: UITableViewCell {

    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var textMessageLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
