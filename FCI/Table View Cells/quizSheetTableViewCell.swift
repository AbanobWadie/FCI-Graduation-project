//
//  quizSheetTableViewCell.swift
//  FCI
//
//  Created by Abanob Wadie on 8/7/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class quizSheetTableViewCell: UITableViewCell {

    @IBOutlet weak var questionNumLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var optionABtn: UIButton!
    @IBOutlet weak var optionBBtn: UIButton!
    @IBOutlet weak var optionCBtn: UIButton!
    @IBOutlet weak var optionDBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
