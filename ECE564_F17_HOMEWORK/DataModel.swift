//
//  DataModel.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Ric Telford on 7/16/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit
import Firebase

// MARK: Protocols

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}


// MARK: Enums

enum Gender {
    case Male
    case Female
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}


// MARK: Classes

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}

struct DPStruct: Codable {
    let firstname: String
    let lastname: String
    let teamname: String
    let wherefrom: String
    let gender: Bool
    let role: String
    let degree: String
    let hobbies: [String]
    let languages: [String]
    let pic: String
    
    func getString()->String{
        return "firstName: \(firstname), lastName: \(lastname), teamName: \(teamname), whereFrom: \(wherefrom), gender: \(gender), role: \(role), degree: \(degree), hobbies: \(hobbies), languages: \(languages), pic: \(pic)"
    }
}

class DukePerson : Person, BlueDevil, CustomStringConvertible, Hashable {
    
    // MARK: Initializers
    
    init(firstName: String, lastName:String, whereFrom: String, gender: Gender, hobbies: [String], role: DukeRole, languages: [String], degree: String){
        self.hobbies = hobbies
        self.role = role
        self.languages = languages
        self.degree = degree
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
    }
    
    
    // MARK: Equality
    
    public var hashValue: Int {
        get {
            return pow(Decimal(Int((firstName as NSString).character(at: 0))), Int((lastName as NSString).character(at: 0))).exponent * Int((whereFrom as NSString).character(at: 0))*Int((degree as NSString).character(at: 0))
        }
        set{}
    }
    
    static func ==(lhs: DukePerson, rhs: DukePerson) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
    // MARK: Properties
    
    var degree: String
    
    var hobbies: [String]
    
    var role: DukeRole
    
    var team: String?
    
    var company: String?
    
    // var image: UIImage?
    
    var languages: [String]
    
    
    // MARK: Getters
    
    func getFirstName()->String {
        return self.firstName
    }
    
    func getLastName()->String {
        return self.lastName
    }
    
    func getHome()->String {
        return self.whereFrom
    }
    
    func getTeam() -> String? {
        return self.team
    }
    
    public func getRole()-> String{
        if role == .Student {
            return "Student"
        } else if (role == .TA) {
            return "TA"
        } else {
            return "Proffessor"
        }
    }
    
    func getDegree()->String {
        return self.degree
    }
    
    func getGender()->String {
        if gender == .Male {
            return "Male"
        } else {
            return "Female"
        }
    }
    
    func getGenderBinary()->Bool{
        if self.gender == .Male{
            return true
        }
        return false
    }
    
    func getLanguages()-> String {
        switch languages.count {
        case 1:
            return languages[0]
        case 2:
            return "\(languages[0]),\(languages[1])"
        case 3:
            return "\(languages[0]),\(languages[1]),\(languages[2])"
        case _:
            return "nothing"
        }
    }
    func getHobbiesAsArray()->[String]{
        return self.hobbies
    }
    func getLanguagesAsArray()->[String]{
        return self.languages
    }
    func getHobbies()-> String {
        switch hobbies.count{
        case 0:
            return "nothing"
        case 1:
            return hobbies[0]
        case 2:
            return "\(hobbies[0]),\(hobbies[1])"
        case _:
            var i = 0
            var hobbiesString = ""
            while(i < hobbies.count - 1){
                hobbiesString += "\(hobbies[i]),"
                i += 1
            }
            hobbiesString += "\(hobbies[i])"
            return hobbiesString
        }
    }
    
    
    // MARK: Printers
    
    func printGender()-> String {
        if gender == .Male{
            return "He"
        } else {
            return "She"
        }
    }
    
    func printLanguages()-> String {
        switch languages.count {
        case 1:
            return languages[0]
        case 2:
            return "\(languages[0]) and \(languages[1])"
        case 3:
            return "\(languages[0]), \(languages[1]), and \(languages[2])"
        case _:
            return "nothing"
        }
    }
    
    func printHobbies()-> String {
        switch hobbies.count {
        case 0:
            return "nothing"
        case 1:
            return hobbies[0]
        case 2:
            return "\(hobbies[0]) and \(hobbies[1])"
        case _:
            var i = 0
            var hobbiesString = ""
            while(i < hobbies.count - 1){
                hobbiesString += "\(hobbies[i]), "
                i += 1
            }
            hobbiesString += "\(hobbies[i])"
            return hobbiesString
        }
    }
    
    func printDegree()-> String {
        switch role{
        case .Professor:
            return ""
        case .Student:
            return " \(printGender()) is pursuing a degree in \(degree)."
        case .TA:
            return " \(printGender()) has a degree in \(degree)."
        }
    }
    
    
    // MARK: CustomStringConvertible
    
    var description: String {
        get {
            return "\(firstName) \(lastName) is from \(whereFrom) and is a \(role).\(printDegree()) \(printGender()) is proficient in \(printLanguages()). When not in class \(firstName) enjoys \(printHobbies())."
        }
    }
}

class CurrentData {
    
    // MARK: Properties
    
    static var selectedPerson: DukePerson? {
        get {
            if (personIndex == nil) {
                return nil
            } else {
                return dukePeople[personIndex!]
            }
        }
        set {}
    }
    
    static var personIndex: Int?
    
    static var dukePeople = [
        DukePerson(firstName: "Ritwik", lastName: "Heda", whereFrom: "Dallas, TX", gender: .Male, hobbies: ["swimming", "videogames", "reading"], role: .Student, languages: ["Python", "Java", "Kotlin"], degree: "Electrical & Computer Engineering"),
        DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, hobbies: ["Biking", "Hiking", "Golf"], role: .Professor, languages: ["Swift", "C", "C++"], degree: "Computer Science"),
        DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .TA, languages: ["Swift", "Python", "Java"], degree: "Computer Engineering"),
        DukePerson(firstName: "Jon", lastName: "Snow", whereFrom: "Kings Landing, Westeros", gender: .Male, hobbies: ["flying dragons", "strolling beyond the wall", "sitting on the Iron Throne"], role: .Professor, languages: ["C", "C++", "Java"], degree: "Computer Engineering"),
        DukePerson(firstName: "Jon", lastName: "Snow", whereFrom: "Winterfell, Westeros", gender: .Male, hobbies: ["sword fighting", "knitting", "freezing"], role: .Professor, languages: ["C", "C++", "Java"], degree: "Computer Engineering")
    ]
    
    static var animations = [
        "Ritwik": RitwikAnimationViewController(),
        "Robert": HobbySCUBAViewController(),
        "Teddy": TeddyViewController(),
        "Harshil": RitwikAnimationViewController()
    ]
    
    
    // MARK: Search
    
    static func find(dukePerson: DukePerson) -> Int? {
        var i = 0
        for person in dukePeople{
            if (person == dukePerson) {
                return i
            }
            i += 1
        }
        return nil
    }
    
    static func searchByName(search: String) -> [DukePerson] {
        var relevantPeople : [DukePerson] = []
        for p in dukePeople {
            let fullname: String = p.firstName + " " + p.lastName
            if (fullname.lowercased().contains(search.lowercased())) {
                relevantPeople += [p]
            }
        }
        return relevantPeople
    }
    
    // MARK: Getters
    
    static func getDukePerson() -> DukePerson? {
        return selectedPerson
    }
    
    static func getGenderEnum(gender: String) -> Gender {
        if gender == "Male" {
            return Gender.Male
        } else {
            return Gender.Female
        }
    }
    
    static func getDukeRole(role: String)-> DukeRole {
        switch role {
        case "Proffessor":
            return DukeRole.Professor
        case "Student":
            return DukeRole.Student
        case "TA":
            return DukeRole.TA
        case _:
            return DukeRole.Student
        }
    }
    
    static func getProfesors(dukePeople: [DukePerson]) -> [DukePerson] {
        var professors = [DukePerson]()
        for dukePerson in dukePeople{
            if (dukePerson.role == .Professor && dukePerson.team == nil) {
                professors.append(dukePerson)
            }
        }
        return professors
    }
    
    static func getTAs(dukePeople: [DukePerson]) -> [DukePerson] {
        var TAs = [DukePerson]()
        for dukePerson in dukePeople{
            if (dukePerson.role == .TA && dukePerson.team == nil) {
                TAs.append(dukePerson)
            }
        }
        return TAs
    }
    
    static func getStudents(dukePeople: [DukePerson]) -> [DukePerson] {
        var students = [DukePerson]()
        for dukePerson in dukePeople{
            if (dukePerson.role == .Student && dukePerson.team == nil) {
                students.append(dukePerson)
            }
        }
        return students
    }
    
    static func getTeams(dukePeople: [DukePerson]) -> [String : [DukePerson]] {
        var teamsDictionary = [String : [DukePerson]]()
        for dukePerson in dukePeople{
            if(dukePerson.team != nil){
                if teamsDictionary[dukePerson.team!] != nil {
                    teamsDictionary[dukePerson.team!]?.append(dukePerson)
                } else {
                    teamsDictionary[dukePerson.team!] = [dukePerson]
                }
            }
        }
        return teamsDictionary
    }
    
    
    // MARK: Setters
    
    static func setDukePerson(dukePerson: DukePerson?) {
        selectedPerson = dukePerson
    }
}
