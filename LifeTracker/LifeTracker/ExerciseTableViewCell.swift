//
//  ExerciseTableViewCell.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 4/7/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ExerciseTableViewCell"
    
    @IBOutlet weak var typeIV: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
