//
//  FriendResponseTableCell.swift
//  TimeTuck_app
//
//  Created by Greenstein on 2/9/15.
//  Copyright (c) 2015 TimeTuck. All rights reserved.
//

import UIKit

class FriendResponseTableCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var decline: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
