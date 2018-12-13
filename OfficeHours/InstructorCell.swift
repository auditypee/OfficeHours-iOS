//
//  InstructorCell.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit

class InstructorCell: UITableViewCell {
    @IBOutlet weak var instructorNameLabel: UILabel!
    @IBOutlet weak var officeRoomLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var coursesTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
