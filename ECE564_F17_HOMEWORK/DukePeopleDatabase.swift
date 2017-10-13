//
//  DukePeopleDatabase.swift
//  ECE564_F17_HOMEWORK
//
//  Created by The Ritler on 10/3/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import Foundation
import Firebase
import UIKit


public class DukePeopleDatabase{
    
    static let rootRef = FIRDatabase.database().reference()
    static let statusRef = FIRDatabase.database().reference().child("status")
    static let storageRef = FIRStorage.storage().reference()
    

    
    static func getFirebaseStatus(){
        statusRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? String
            print("hehehehe")
            print(value!)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    static func setFirebaseStatus(dukePeople: [DukePerson]){
        rootRef.child("DukePeople").setValue("About to get wrecked")
        for dukePerson in dukePeople{
            setFirebaseStatus(dukePerson: dukePerson)
        }
    }
    static func setFirebaseStatus(dukePerson: DukePerson){
        var dukePersonDictionary = [String : Any]()
        dukePersonDictionary["firstName"] = dukePerson.firstName
        dukePersonDictionary["lastName"] = dukePerson.lastName
        dukePersonDictionary["whereFrom"] = dukePerson.whereFrom
        dukePersonDictionary["role"] = dukePerson.getRole()
        dukePersonDictionary["hobbies"] = dukePerson.hobbies
        dukePersonDictionary["degree"] = dukePerson.degree
        dukePersonDictionary["gender"] = dukePerson.getGender()
        dukePersonDictionary["languages"] = dukePerson.languages
        if let company = dukePerson.company{
            dukePersonDictionary["company"] = company
        }
        if let team = dukePerson.team{
            dukePersonDictionary["team"] = team
        }
        
        let firebaseDictionary = dukePersonDictionary as NSDictionary
        
        
        
        
        rootRef.child("DukePeople").child("\(dukePerson.hashValue)").setValue(firebaseDictionary)
    }
    
    static func getFirebaseDukePeople() -> [DukePerson]{
        var dukePeople = [DukePerson]()
        let ref = FIRDatabase.database().reference().child("DukePeople")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                guard let restDict = rest.value as? [String: Any] else { continue }
                let dukePerson = DukePerson(
                    firstName: restDict["firstName"] as! String,
                    lastName: restDict["lastName"] as! String,
                    whereFrom: restDict["whereFrom"] as! String,
                    gender: Data.getGenderEnum(gender: restDict["gender"] as! String),
                    hobbies: restDict["hobbies"] as! [String],
                    role: Data.getDukeRole(role: restDict["role"] as! String) ,
                    languages: restDict["languages"] as! [String],
                    degree: restDict["degree"] as! String)
                if let company = restDict["company"] as! String?{
                    dukePerson.company = company
                }
                if let team = restDict["team"] as! String?{
                    dukePerson.team = team
                }
                print(dukePerson)
                dukePeople.append(dukePerson)
            }
        })
        return dukePeople
    }

    
//    static func addImage(dukePerson: DukePerson){
//        let imageRef = storageRef.child("\(dukePerson.hashValue).png")
//        if let uploadData = UIImagePNGRepresentation(dukePerson.image!){
//            imageRef.put(uploadData, metadata: nil, completion:
//                { (metadata, error) in
//                if(error != nil){
//                    print(error!)
//                    return
//                }
//                    print("a")
//                print(metadata?.downloadURL()! as Any)                    
//            })
//        }
    
    //}

    // DispatchQueue.main.async
    
}
