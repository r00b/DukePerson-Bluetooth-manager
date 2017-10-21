//
//  DukePersonTableViewCell.swift
//  ECE564_F17_HOMEWORK
//
//  Created by The Ritler on 9/20/17.
//  Copyright © 2017 ece564. All rights reserved.
//
//  Defines a custom TableViewCell for each DukePerson
//

import UIKit
import Firebase

class DukePersonTableViewCell: UITableViewCell{
    
    // MARK: Properties
    
    public var info: DukePerson!
    
    let storageRef = FIRStorage.storage().reference()
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var fullInfo: UITextView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    
    // MARK: Override functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: Functions
    
    func setDukePerson(dukePerson: DukePerson){
        info = dukePerson
        name.text = "\(info.firstName) \(info.lastName)"
        location.text = info.whereFrom
        fullInfo.text = info.description
        profilePic.image = #imageLiteral(resourceName: "Avatar")
        profilePic.layer.cornerRadius = 25
        profilePic.layer.borderWidth = 2
        profilePic.layer.borderColor = UIColor.gray.cgColor
        profilePic.layer.masksToBounds = true
        getImage(dukePerson: dukePerson)
    }
    
    func getImage(dukePerson: DukePerson){
        let imageRef = storageRef.child("\(dukePerson.hashValue).jpeg")
        imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                self.profilePic.image = UIImage(data: data!)
            }
        }
    }
    
}
