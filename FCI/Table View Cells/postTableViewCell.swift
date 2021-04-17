//
//  postTableViewCell.swift
//  FCI
//
//  Created by Abanob Wadie on 7/31/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class postTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var postDateTimeLbl: UILabel!
    @IBOutlet weak var postContentLbl: UILabel!
    @IBOutlet weak var attachmentsLinkBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesNumLbl: UILabel!
    @IBOutlet weak var commentsNumLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
