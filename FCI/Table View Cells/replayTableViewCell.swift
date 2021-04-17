//
//  replayTableViewCell.swift
//  FCI
//
//  Created by Abanob Wadie on 8/4/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class replayTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentHieght: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
