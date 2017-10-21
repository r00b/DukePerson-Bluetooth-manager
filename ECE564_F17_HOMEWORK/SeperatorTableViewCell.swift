//
//  SeperatorTableViewCell.swift
//  ECE564_F17_HOMEWORK
//
//  Created by The Ritler on 9/22/17.
//  Copyright © 2017 ece564. All rights reserved.
//
//  Defines a custom TableViewCell for each separator

import UIKit

class SeperatorTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var label: UILabel!
    
    
    // MARK: Override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: Functions
    
    func setTitle(title: String){
        label.text = title
    }
    
}
