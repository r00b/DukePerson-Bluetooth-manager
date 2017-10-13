//
//  SeperatorTableViewCell.swift
//  ECE564_F17_HOMEWORK
//
//  Created by The Ritler on 9/22/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

class SeperatorTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTitle(title: String){
        label.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
