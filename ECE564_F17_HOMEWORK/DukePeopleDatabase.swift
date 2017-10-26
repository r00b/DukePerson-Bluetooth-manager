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

public class DukePeopleDatabase {
    
    // MARK: Firebase properties
    
    static let rootRef = FIRDatabase.database().reference()
    static let statusRef = FIRDatabase.database().reference().child("status")
    static let storageRef = FIRStorage.storage().reference()
    
    static private var dbName = "DukePeople"
    
    
    // MARK: Getters
    
    static func getDbName() -> String {
        return self.dbName
    }
    
    static func getFirebaseStatus(){
        statusRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
//            let value = snapshot.value as? String
//            print(value!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func getFirebaseDukePeople() -> [DukePerson] {
        var dukePeople = [DukePerson]()
        let ref = FIRDatabase.database().reference().child(dbName)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            //            print(snapshot.childrenCount) // got the expected number of items
            for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                guard let restDict = rest.value as? [String: Any] else { continue }
                let dukePerson = DukePerson(
                    firstName: restDict["firstName"] as! String,
                    lastName: restDict["lastName"] as! String,
                    whereFrom: restDict["whereFrom"] as! String,
                    gender: CurrentData.getGenderEnum(gender: restDict["gender"] as! String),
                    hobbies: restDict["hobbies"] as! [String],
                    role: CurrentData.getDukeRole(role: restDict["role"] as! String) ,
                    languages: restDict["languages"] as! [String],
                    degree: restDict["degree"] as! String)
                if let company = restDict["company"] as! String?{
                    dukePerson.company = company
                }
                if let team = restDict["team"] as! String?{
                    dukePerson.team = team
                }
                dukePeople.append(dukePerson)
            }
        })
        return dukePeople
    }
    
    
    // MARK: Setters
    
    static func setFirebaseStatus(dukePeople: [DukePerson]){
        rootRef.child(dbName).setValue("About to get wrecked")
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
        rootRef.child(dbName).child("\(dukePerson.hashValue)").setValue(firebaseDictionary)
    }
    
    //
    //
    //    static func addImage(dukePerson: DukePerson){
    //        let imageRef = storageRef.child("\(dukePerson.hashValue).png")
    //        if let uploadData = UIImagePNGRepresentation(dukePerson.image!){
    //            imageRef.put(uploadData, metadata: nil, completion:
    //                { (metadata, error) in
    //                if(error != nil){
    //                    print(error!)
    //                    return
    //                }
    //                print(metadata?.downloadURL()! as Any)
    //            })
    //        }
    //
    //    }
    //
    //     DispatchQueue.main.async
    
}
