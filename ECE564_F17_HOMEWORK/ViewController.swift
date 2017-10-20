//
//  ViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Ric Telford on 7/16/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit


class BasicViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate{
    
    // MARK: Positioning
    
    var y1count = 0
    
    var y1: Int{
        get{
            let y = 50 + y1count*60
            y1count += 1
            return y
        }
        set{
            
        }
    }
    
    var y2count = 0
    
    var y2: Int{
        get{
            let y = 20 + y2count*58
            y2count += 1
            return y
        }
        set{
            
        }
    }
    
    var centerX: Int{
        get{
            return Int(self.view.center.x)
        }
        
        set{
            
        }
    }
    
    //DATA======================================================================================================
    
    var dukePeople = [
        DukePerson(firstName: "Ritwik", lastName: "Heda", whereFrom: "Dallas, TX", gender: .Male, hobbies: ["swimming", "videogames", "reading"], role: .Student, languages: ["Python", "Java", "Kotlin"], degree: "Electrical & Computer Engineering"),
        DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, hobbies: ["Biking", "Hiking", "Golf"], role: .Professor, languages: ["Swift", "C", "C++"], degree: "Computer Science"),
        DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .TA, languages: ["Swift", "Python", "Java"], degree: "Computer Engineering"),
        DukePerson(firstName: "Jon", lastName: "Snow", whereFrom: "Kings Landing, Westeros", gender: .Male, hobbies: ["flying dragons", "strolling beyond the wall", "sitting on the Iron Throne"], role: .Professor, languages: ["C", "C++", "Java"], degree: "Computer Engineering"),
        DukePerson(firstName: "Jon", lastName: "Snow", whereFrom: "Winterfell, Westeros", gender: .Male, hobbies: ["sword fighting", "knitting", "freezing"], role: .Professor, languages: ["C", "C++", "Java"], degree: "Computer Engineering")
    ]
    
    var skillDictionary: [String: [DukePerson]]{
        get{
            var a = [String: [DukePerson]]()
            var val: Bool
            for dukePerson in dukePeople{
                for language in dukePerson.languages{
                    val = a[language] != nil
                    if val{
                        a[language]?.append(dukePerson)
                    }else{
                        a[language] = [dukePerson]
                    }
                }
            }
            return a
        }
        set{
            
        }
    }
    
    
    //TEXTFIELDS================================================================================================
    
    var buttonView: UIButton!
    
    var firstNameCaption = UITextView()
    var firstNameText = UITextField()
    
    var secondNameCaption = UITextView()
    var secondNameText = UITextField()
    
    var homeCaption = UITextView()
    var homeText = UITextField()
    
    var degreeCaption = UITextView()
    var degreeText = UITextField()
    
    var hobbiesCaption = UITextView()
    var hobbiesText = UITextField()
    
    var languagesCaption = UITextView()
    var languagesText = UITextField()
    
    var genderCaption = UITextView()
    var genderText = UITextField()
    
    var roleCaption = UITextView()
    var roleText = UITextField()
    
    var textList: [UITextField]{
        get{
            return [firstNameText,secondNameText, homeText, degreeText, hobbiesText, languagesText, genderText, roleText]
        }
        set{
            
        }
    }
    
    
    func removeText(){
        for textField in textList{
            textField.text = ""
        }
    }
    
    func makeField(view : UIView!, caption : UITextView!, textField : UITextField!, text : String, x : Int, y : Int, d: Int){
        var textComponents = text.components(separatedBy: "@")
        caption.text = textComponents[0]
        caption.frame = CGRect(x: 10, y: y-15, width: 100, height: 25)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 10)
        textField.placeholder = textComponents[1]
        textField.frame = CGRect(x: 0, y: 0, width: 267, height: 25)
        //let textFieldX: Int = Int(caption.center.x + caption.frame.width/2 + textField.frame.width/2 ) + d
        textField.center = CGPoint(x: x + Int(textField.frame.width/2) - 23, y: y + 28)
        view.addSubview(caption)
        view.addSubview(textField)
        
    }
    
    func addFields(dukePerson : DukePerson){
        let fieldX: Int = 50
        let fieldY: Int = 100
        let seperation: Int = 30
        self.makeField(view: self.view, caption: firstNameCaption, textField: firstNameText, text: "FirstName@\(dukePerson.getFirstName())", x: fieldX, y: fieldY, d: 0)
        self.makeField(view: self.view, caption: secondNameCaption, textField: secondNameText, text: "LastName@\(dukePerson.getLastName())", x: fieldX, y: fieldY + seperation, d: 0)
        self.makeField(view: self.view, caption: homeCaption, textField: homeText, text: "Home@\(dukePerson.getHome())", x: fieldX, y: fieldY + 2*seperation, d: 0)
        self.makeField(view: self.view, caption: degreeCaption, textField: degreeText, text: "Degree@\(dukePerson.getDegree())", x: fieldX, y: fieldY + 3*seperation, d: 0)

        
    }
    
    //SEARCH=====================================================================================================
    
    func addSearch(){
        addCategoryPicker()
        searchBar.placeholder = "Enter languages (i.e. C, C++, Java)"
        searchBar.sizeToFit()
        searchBar.center = CGPoint(x: Int(self.view.center.x), y: y1)
        searchButton.setImage(#imageLiteral(resourceName: "SearchIcon"), for: UIControlState.normal)
        searchButton.backgroundColor = .blue
        searchButton.backgroundColor?.withAlphaComponent(0.5)
        searchButton.center = CGPoint(x: Int(self.view.center.x), y: y1)
        searchButton.bounds = CGRect(x: 20, y: 20, width: 50, height: 50)
        searchButton.layer.cornerRadius = 25
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        self.view.addSubview(searchButton)
        self.view.addSubview(searchBar)
        
        
    }
    
    //CATEGORY_PICKER-------------------------------------------------------------------------------------------
    
    var categoryPicker = UIPickerView()
    
    var searchCategories: [String] = ["Language", "Name"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchCategories.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // location = dormlist[row]
        // print(location)
        return searchCategories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCategoryIndex = row
        switch currentCategory{
            case "Language":
                searchBar.placeholder = "Enter languages (i.e. C, C++, Java)"
            case "Name":
                searchBar.placeholder = "Enter a name (i.e. Ric Telford)"
            case _:
                searchBar.placeholder = "You cannot enter a field at this time"
        }
    }
    
    
    func addCategoryPicker(){
        categoryPicker = UIPickerView(frame: CGRect(x: 20, y: 100, width: 200, height: 100))
        categoryPicker.center = CGPoint(x: centerX, y: y1)
        categoryPicker.showsSelectionIndicator = false;
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        self.view.addSubview(categoryPicker)
    }
    
    //SEARCHBAR-------------------------------------------------------------------------------------------------
    
    var searchBar = UITextField()
    
    //SEARCHBUTTON----------------------------------------------------------------------------------------------
    
    var searchButton = UIButton()
    
    var currentCategoryIndex = 0
    var currentCategory: String{
        get{
            return searchCategories[currentCategoryIndex]
        }
        set{
            
        }
    }
    
    @objc func searchAction(){
        self.view.backgroundColor = .white
        switch currentCategory{
        case "Language":
            if searchBar.text != nil{
                let languages = searchBar.text!.components(separatedBy: ",")
                let people: [DukePerson] = findDevelopers(languages: languages)
                selectedPeople = people
                tableView.reloadData()
                descriptionView.text = ""
            }
            
        case "Name":
            if (searchBar.text != nil){
                if(searchBar.text!.components(separatedBy: " ").count > 1){
                    let people: [DukePerson] = whoIs(searchBar.text!)
                    selectedPeople = people
                    tableView.reloadData()
                    descriptionView.text = ""
                }else{
                    searchBar.text = ""
                    searchBar.placeholder = "Please correct (i.e. Ric Telford)"
                    selectedPeople = [DukePerson]()
                    tableView.reloadData()
                    descriptionView.text = ""
                }
            }
    
        case _: break
            
        }
    }
    
    func whoIs(_ name: String) -> [DukePerson] {
        print(name)
        var fullNameArr = name.components(separatedBy: " ")
        let first = fullNameArr[0]
        let last = fullNameArr[1]
        var people = [DukePerson]()
        for dukePerson in dukePeople{
            if first == dukePerson.firstName && last == dukePerson.lastName{
                people.append(dukePerson)
            }
        }
        return people
    }
    
    func findDevelopers(languages: [String])->[DukePerson]{
        var qualified = Set<DukePerson>()
        for language in languages{
            if let developers = skillDictionary[language]{
                for developer in developers{
                    qualified.insert(developer)
                }
            }
            
        }
        return Array(qualified)
    }
    
    //DESCRIPTION====================================================+===========================================
    
    var selectedPerson: DukePerson!
    
    var descriptionView = UITextView()
    
    func addDescription(){
        descriptionView.frame = CGRect(x: centerX, y: 325, width: 250, height: 100)
        descriptionView.center = CGPoint(x: centerX, y: 325)
        self.view.addSubview(descriptionView)
    }
    
    //POPUP=====================================================================================================
    
    var addButton = UIButton()
    
    var addButton2 = UIButton()
    
    var clearButton = UIButton()
    
    var popUp : UIView!
    
    var blurEffectView: UIVisualEffectView!
    
    func createPopUp(){
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        let popUpFrame = CGRect(x: self.view.frame.width/2 , y: self.view.frame.height/2 , width: self.view.frame.width - 30, height: self.view.frame.height - 30)
        popUp = UIView(frame: popUpFrame)
        popUp.center = self.view.center
        popUp.backgroundColor = .white
        popUp.layer.cornerRadius = 10
        popUp.layer.shadowRadius = 10.0;
        popUp.layer.shadowOpacity = 0.5;
        self.view.addSubview(popUp)
        
        clearButton.center = CGPoint(x: Int(popUp.frame.maxX)-30, y: Int(popUp.frame.minY)+3)
        clearButton.bounds = CGRect(x: 20, y: 20, width: 20, height: 20)
        clearButton.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: UIControlState.normal)
        clearButton.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        clearButton.backgroundColor = .clear
        popUp.addSubview(clearButton)
        
        

        print("We here")
        makeField(view: popUp, caption: firstNameCaption, textField: firstNameText, text: "First Name@enter first name (i.e. Ric)", x: 35, y: y2, d: 0)
        makeField(view: popUp, caption: secondNameCaption, textField: secondNameText, text: "Last Name@enter last name (i.e. Telford)", x: 35, y: y2, d: 0)
        makeField(view: popUp, caption: homeCaption, textField: homeText, text: "Home@enter location (i.e. Morrisville, NC)", x: 35, y: y2, d: 0)
        makeField(view: popUp, caption: degreeCaption, textField: degreeText, text: "Degree@please enter degree (i.e. Ph.D in Computer Science)", x: 35, y: y2, d: 0)
        makeField(view: popUp, caption: hobbiesCaption, textField: hobbiesText, text: "Hobbies@enter hobbies (i.e. horse riding, swimming, hiking)", x: 35, y: y2, d: 0)
        makeField(view: popUp, caption: languagesCaption, textField: languagesText, text: "Languages@enter up to 3 languages (i.e. C, C++, Java)", x: 35, y: y2, d: 0)
        makeField(view: popUp, caption: genderCaption, textField: genderText, text: "Gender@enter Male or Female", x: 35, y: y2, d: 0)
        makeField(view: popUp, caption: roleCaption, textField: roleText, text: "Role@enter Professor, TA, or Student", x: 35, y: y2, d: 0)
        addButton2.setImage(#imageLiteral(resourceName: "AddIcon"), for: UIControlState.normal)
        addButton2.addTarget(self, action: #selector(addAction2), for: .touchUpInside)
        addButton2.backgroundColor = .green
        addButton2.bounds = CGRect(x: Int(popUp.center.x), y: 0, width: 50, height: 50)
        addButton2.center = CGPoint(x: Int(popUp.center.x), y: y2 + 40)
        addButton2.layer.cornerRadius = 25
        addButton2.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        addButton2.backgroundColor?.withAlphaComponent(0.5)
        self.view.addSubview(addButton2)
        print("We here now")
        
    }
    @objc func clearAction(sender: UIButton!){
        clear()
    }
    
    func clear(){
        popUp.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        addButton2.removeFromSuperview()
        y2count = 0
        removeText()
    }
    
    
    @objc func addAction2(sender: UIButton!){
        var key = true
        var role: DukeRole!
        var gender: Gender!
        if(firstNameText.text == nil){
            key = false
        }
        if(secondNameText.text == nil){
            key = false
        }
        if(homeText.text == nil){
            key = false
        }
        if(degreeText.text == nil){
            key = false
        }
        if(hobbiesText.text == nil){
            key = false
        }
        if(languagesText.text == nil){
            key = false
            if(languagesText.text!.components(separatedBy: ",").count > 3 ){
                key = false
            }
        }
        if(genderText.text != "Male" && genderText.text != "Female"){
            key = false
        }else{
            if(genderText.text == "Male"){
                gender = Gender.Male
            }else{
                gender = Gender.Female
            }
        }
        if(roleText.text == nil){
            key = false
        }else{
            if(roleText.text != "Professor" && roleText.text != "Student" && roleText.text != "TA"){
                key = false
            }
            if(roleText.text == "Professor"){
                role = DukeRole.Professor
            }
            if(roleText.text == "Student"){
                role = DukeRole.Student
            }
            if(roleText.text == "TA"){
                role = DukeRole.TA
            }
            
        }
        if(key){
            print("Succedd")
            dukePeople.append(DukePerson(firstName: firstNameText.text!, lastName: secondNameText.text!, whereFrom: homeText.text!, gender: gender, hobbies: hobbiesText.text!.components(separatedBy: ","), role: role, languages: languagesText.text!.components(separatedBy: ","), degree: degreeText.text!))
            popUp.removeFromSuperview()
            blurEffectView.removeFromSuperview()
            addButton2.removeFromSuperview()
            y2count = 0
            removeText()
            
        }else{
            print("fail")
        }
    }
    
    
    
    func addAdd(){
        addButton.setImage(#imageLiteral(resourceName: "AddIcon"), for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        addButton.backgroundColor = .green
        addButton.center = CGPoint(x: Int(self.view.center.x), y: y1)
        addButton.bounds = CGRect(x: 20, y: 20, width: 50, height: 50)
        addButton.layer.cornerRadius = 25
        addButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        addButton.backgroundColor?.withAlphaComponent(0.5)
        self.view.addSubview(addButton)
    }
    
    @objc func addAction(sender: UIButton!){
        createPopUp()
    }
    
    //TABLE=======================================================================================================
    
    var selectedPeople = [DukePerson]()
    
    var tableView: UITableView  =   UITableView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedPeople.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Set backfround to gray for normal entries
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: CGFloat(210.0/225.0), green: CGFloat(210.0/225.0), blue: CGFloat(210.0/225.0), alpha: 0.9)
        cell.textLabel!.text = "\(selectedPeople[indexPath.row].getFirstName()) \(selectedPeople[indexPath.row].getLastName())"
        cell.selectedBackgroundView = bgColorView
        return cell;
    }
    func connected(sender: UIButton!) {
        
        //print("connection successful")
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedPerson = selectedPeople[indexPath.row]
        descriptionView.text = selectedPerson.description
    }
    
    func addTable(){
        tableView = UITableView(frame: CGRect(x: 0, y: 250, width: 300, height: 150), style: UITableViewStyle.plain)
        tableView.center = CGPoint(x: centerX, y: 460)
        tableView.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //numberOfSections = tableView.numberOfSections
        //numberOfRows = tableView.numberOfRows(inSection: numberOfSections-1)
        //indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
        self.view.addSubview(self.tableView)

    }
    
    //MAIN=========================================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toggleKeyboard()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        buttonView = UIButton()
        buttonView.setTitle("Here", for: .normal)
        buttonView.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        buttonView.backgroundColor = .red
        buttonView.isHidden = false
        addSearch()
        addAdd()
        addTable()
        addDescription()
        selectedPeople = dukePeople
        //addFields(dukePerson: DukePerson(firstName: "Ritwik", lastName: "Heda", whereFrom: "Dallas, TX", gender: .Male, hobbies: ["swimming", "videogames", "reading"], role: .Student, languages: ["Python", "Java", "Kotlin"], degree: "Electrical & Computer Engineering"))
        

        // self.view.addSubview(buttonView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

