import UIKit

/*:
 ### ECE 564 HW1 assignment
 In this first assignment, you are going to create a base data model for storing information about the students, TAs and professors in ECE 564. You need to populate your data model with at least 3 records, but can add more.  You will also provide a search function ("whoIs") to search an array of those objects by first name and last name.
 I suggest you create a new class called `DukePerson` and have it subclass `Person`.  You also need to abide by 2 protocols:
 1. BlueDevil
 2. CustomStringConvertible
 
 I also suggest you try to follow good OO practices by containing any properties and methods that deal with `DukePerson` within the class definition.
 */
/*:
 In addition to the properties required by `Person`, `CustomStringConvertible` and `BlueDevil`, you need to include the following information about each person:
 * Their degree, if applicable
 * Up to 3 of their best programming languages as an array of `String`s (like `hobbies` that is in `BlueDevil`)
 */
/*:
 I suggest you create an array of `DukePerson` objects, and you **must** have at least 3 entries in your array for me to test:
 1. Yourself
 2. Me (my info is in the slide deck)
 3. One of the TAs (also in slide deck)
 */
/*:
 Your program must contain the following:
 - You must include 4 of the following - array, dictionary, set, class, function, closure expression, enum, struct
 - You must include 4 different types, such as string, character, int, double, bool, float
 - You must include 4 different control flows, such as for/in, while, repeat/while, if/else, switch/case
 - You must include 4 different operators from any of the various categories of assignment, arithmatic, comparison, nil coalescing, range, logical
 */
/*:
 Base grade is a 45 but more points can be earned by adding additional functions besides whoIs (like additional search), extensive error checking, concise code, excellent OO practices, and/or excellent, unique algorithms
 */
/*:
 Below is an example of what the string output from `whoIs' should look like:
 
 Ric Telford is from Morrisville, NC and is a Professor. He is proficient in Swift, C and C++. When not in class, Ric enjoys Biking, Hiking and Golf.
 */

enum Gender {
    case Male
    case Female
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}


enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}
//: ### START OF HOMEWORK
//: Do not change anything above.
//: Put your code here:


class DukePerson : Person, BlueDevil, CustomStringConvertible {
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
    var degree: String
    var hobbies: [String]
    var role: DukeRole
    
    var languages: [String]
    
    func printLanguages()-> String{
        switch languages.count{
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
    
    func printGender()-> String{
        if gender == .Male{
            return "He"
        }else{
            return "She"
        }
    }
    
    func printHobbies()-> String{
        switch hobbies.count{
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
    
    func printDegree()-> String{
        switch role{
        case .Professor:
            return ""
        case .Student:
            return " \(printGender()) is pursuing a degree in \(degree)."
        case .TA:
            return " \(printGender()) has a degree in \(degree)."
        }
    }
    
    var description: String{
        get{
            return "\(firstName) \(lastName) is from \(whereFrom) and is a \(role).\(printDegree()) \(printGender()) is proficient in \(printLanguages()). When not in class \(firstName) enjoys \(printHobbies())."
        }
    }
}

var dukePeople = [
    DukePerson(firstName: "Ritwik", lastName: "Heda", whereFrom: "Dallas, TX", gender: .Male, hobbies: ["swimming", "videogames", "reading"], role: .Student, languages: ["Python", "Java", "Kotlin"], degree: "Electrical & Computer Engineering"),
    DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, hobbies: ["Biking", "Hiking", "Golf"], role: .Professor, languages: ["Swift", "C", "C++"], degree: "Computer Science"),
    DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .Professor, languages: ["Swift", "Python", "Java"], degree: "Computer Engineering")
]

var skillDictionary: [String: [String]]{
    get{
        var a = [String: [String]]()
        var val: Bool
        for dukePerson in dukePeople{
            for language in dukePerson.languages{
                val = a[language] != nil
                if val{
                    a[language]?.append("\(dukePerson.firstName) \(dukePerson.lastName)")
                }else{
                    a[language] = ["\(dukePerson.firstName) \(dukePerson.lastName)"]
                }
            }
        }
        return a
    }
    set{
        
    }
}

func findDevelopers(languages: [String])->[String]{
    var qualified = Set<String>()
    for language in languages{
        if let developers = skillDictionary[language]{
            for developer in developers{
                qualified.insert(developer)
            }
        }
        
    }
    return Array(qualified)
}

func numberOfNamesThatStartWith(firstLetter: Character) -> Int{
    var i = 0
    var count = 0
    while(i < dukePeople.count){
        if dukePeople[i].firstName.characters.first! == firstLetter{
            count += 1
        }
        i += 1
    }
    return count
    
}
func whoIs(_ name: String) -> String {
    var fullNameArr = name.components(separatedBy: " ")
    let first = fullNameArr[0]
    let last = fullNameArr[1]
    for dukePerson in dukePeople{
        if first == dukePerson.firstName && last == dukePerson.lastName{
            return dukePerson.description
        }
    }
    return "not found"
}


var a = DukePerson(firstName: "Ritwik", lastName: "Heda", whereFrom: "Dallas, TX", gender: .Male, hobbies: ["swimming", "videogames", "reading"], role: .Student, languages: ["Python", "Java", "Kotlin"], degree: "Computer Engineering")

//: ### END OF HOMEWORK
//: Uncomment the line below to test your homework.
//: The "whoIs" function should be defined as `func whoIs(_ name: String) -> String {   }`
/*
 */
print(a.description)
print(skillDictionary)
print(whoIs("Ric Telford"))
print(findDevelopers(languages: ["Java", "Kotlin"]))
print(numberOfNamesThatStartWith(firstLetter: "R"))



