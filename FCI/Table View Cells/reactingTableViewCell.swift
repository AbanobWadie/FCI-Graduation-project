//
//  reactingTableViewCell.swift
//  FCI
//
//  Created by Abanob Wadie on 7/31/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class reactingTableViewCell: UITableViewCell {

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
