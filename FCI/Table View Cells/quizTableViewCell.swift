//
//  quizTableViewCell.swift
//  FCI
//
//  Created by Abanob Wadie on 8/6/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class quizTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var questionNumLbl: UILabel!
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
