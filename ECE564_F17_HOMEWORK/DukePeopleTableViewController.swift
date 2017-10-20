//
//  DukePeopleTable.swift
//  ECE564_F17_HOMEWORK
//
//  Created by The Ritler on 9/20/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import Foundation
import Firebase

import UIKit

class DukePeopleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.toggleKeyboard()
        self.view.backgroundColor = .gray
        //addAdd()
        //setCells(dukePeople: Data.dukePeople)
        DukePeopleDatabase.getFirebaseStatus()
        //DukePeopleDatabase.setFirebaseStatus(dukePeople: Data.dukePeople)
        //print(DukePeopleDatabase.addImage(name: "Blastoise", image: #imageLiteral(resourceName: "Blastoise")))
        // Do any additional setup after loading the view, typically from a nib.
        //print(DukePeopleDatabase.getFirebaseDukePeople())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        getFireBaseData()
//        for dukePerson in Data.dukePeople{
//            DukePeopleDatabase.addImage(dukePerson: dukePerson)
//        }
    }
    
    
    
    
    //Table
    
    var dukePeople = Data.dukePeople
    
    var tableViewCells = [UITableViewCell]()
    
    @IBOutlet weak var DukeTable: UITableView!
    
    var marker = true
    
    func getFireBaseData(){
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
            self.setCells(dukePeople: dukePeople)
            Data.dukePeople = dukePeople
        })
    }
    
    
    func setCells(dukePeople: [DukePerson]){
        print("set cells")
        
        //if(marker == true){
        
        tableViewCells.removeAll()
        
        addProfessors(dukePeople: dukePeople)
        

        addTAs(dukePeople: dukePeople)
        

        addStudents(dukePeople: dukePeople)
        
        addTeams(dukePeople: dukePeople)
        DukeTable.reloadData()
        //}else{
            // DukeTable.reloadData()
        //}
        
    }
    

    func addProfessors(dukePeople: [DukePerson]){
        print(Data.getProfesors(dukePeople: dukePeople).count)
        if(Data.getProfesors(dukePeople: dukePeople).count > 0){
        tableViewCells = [UITableViewCell]()
        let professorSeperator  = Bundle.main.loadNibNamed("SeperatorTableViewCell", owner: self, options: nil)?.first as! SeperatorTableViewCell
        professorSeperator.setTitle(title: "Professor")
        professorSeperator.backgroundColor = .clear
        tableViewCells.append(professorSeperator)
        }
        
        for professor in Data.getProfesors(dukePeople: dukePeople){
            let cell  = Bundle.main.loadNibNamed("DukePersonTableViewCell", owner: self, options: nil)?.first as! DukePersonTableViewCell
            
            cell.setDukePerson(dukePerson: professor)
            cell.backgroundColor = .clear
            tableViewCells.append(cell)
        }
    }
    
    func addTAs(dukePeople: [DukePerson]){
        if(Data.getTAs(dukePeople: dukePeople).count > 0){
        let TASeperator  = Bundle.main.loadNibNamed("SeperatorTableViewCell", owner: self, options: nil)?.first as! SeperatorTableViewCell
        TASeperator.setTitle(title: "TA")
        TASeperator.backgroundColor = .clear
         tableViewCells.append(TASeperator)
        }
        
        for TA in Data.getTAs(dukePeople: dukePeople){
            let cell  = Bundle.main.loadNibNamed("DukePersonTableViewCell", owner: self, options: nil)?.first as! DukePersonTableViewCell
            
            cell.setDukePerson(dukePerson: TA)
            cell.backgroundColor = .clear
            tableViewCells.append(cell)
        }
    }
    
    func addStudents(dukePeople: [DukePerson]){
        if(Data.getStudents(dukePeople: dukePeople).count > 0){
        let studentSeperator  = Bundle.main.loadNibNamed("SeperatorTableViewCell", owner: self, options: nil)?.first as! SeperatorTableViewCell
        studentSeperator.setTitle(title: "Student")
        studentSeperator.backgroundColor = .clear
        tableViewCells.append(studentSeperator)
        }
        
        for student in Data.getStudents(dukePeople: dukePeople){
            let cell  = Bundle.main.loadNibNamed("DukePersonTableViewCell", owner: self, options: nil)?.first as! DukePersonTableViewCell
            
            cell.setDukePerson(dukePerson: student)
            cell.backgroundColor = .clear
            tableViewCells.append(cell)
        }
    }
    
    func addTeams(dukePeople: [DukePerson]){
        for (teamName, team) in Data.getTeams(dukePeople: dukePeople){
            if(team.count > 0){
                let teamSeperator  = Bundle.main.loadNibNamed("SeperatorTableViewCell", owner: self, options: nil)?.first as! SeperatorTableViewCell
                teamSeperator.setTitle(title: "\(teamName)")
                teamSeperator.backgroundColor = .clear
                tableViewCells.append(teamSeperator)
            }
            
            for student in team{
                let cell  = Bundle.main.loadNibNamed("DukePersonTableViewCell", owner: self, options: nil)?.first as! DukePersonTableViewCell
                
                cell.setDukePerson(dukePerson: student)
                cell.backgroundColor = .clear
                tableViewCells.append(cell)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableViewCells.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Set backfround to gray for normal entries
        
        //    let cell  = Bundle.main.loadNibNamed("DukePersonTableViewCell", owner: self, options: nil)?.first as! DukePersonTableViewCell
        //
        //    cell.setDukePerson(dukePerson: selectedPeople[indexPath.row])
        //    cell.backgroundColor = .clear
        
        //UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell", )
        //    let bgColorView = UIView()
        //    bgColorView.backgroundColor = UIColor(red: CGFloat(210.0/225.0), green: CGFloat(210.0/225.0), blue: CGFloat(210.0/225.0), alpha: 0.9)
        //    cell.textLabel!.text = "\(selectedPeople[indexPath.row].getFirstName()) \(selectedPeople[indexPath.row].getLastName())"
        //    cell.selectedBackgroundView = bgColorView
        return tableViewCells[indexPath.row];
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let destination = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! UIViewController
        //navigationController?.pushViewController(destination, animated: true)
        
        if ((tableViewCells[indexPath.row] as? DukePersonTableViewCell) != nil) {
            let dukeCell = tableViewCells[indexPath.row] as! DukePersonTableViewCell
            Data.personIndex = Data.find(dukePerson: dukeCell.info)
            //print("index for : \(Data.personIndex)")
            performSegue(withIdentifier: "TableDetailSegue", sender: nil)
        }
        else {
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if ((tableViewCells[indexPath.row] as? DukePersonTableViewCell) != nil) {
            return 130
        }
        else {
            return 30
        }
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        if ((tableViewCells[editActionsForRowAt.row] as? DukePersonTableViewCell) != nil) {
            let delete = UITableViewRowAction(style: .normal, title: "   Delete   ") { action, index in
                
                self.deleteAction(dukePerson: ((self.tableViewCells[editActionsForRowAt.row] as? DukePersonTableViewCell)?.info)!)
            }
            delete.backgroundColor = .red
            return [delete]

        }else{
            return []
        }
        

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func deleteAction(dukePerson: DukePerson){
        Data.dukePeople.remove(at: Data.dukePeople.index(of: dukePerson)!)
        DukePeopleDatabase.setFirebaseStatus(dukePeople: Data.dukePeople)
        getFireBaseData()
    }
    
    
    //TextFieldProperties
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //SearchBarProperties
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text != nil){
            setCells(dukePeople: Data.searchByName(name: searchBar.text!))
            print(searchBar.text!)
            //print(selectedPeople)
            DukeTable.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getFireBaseData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    
    //AddPerson
   
    
    @objc var addButton = UIButton()
    
    
    @IBAction func addAction(_ sender: Any) {
        Data.personIndex = nil
        //print("index for : \(Data.personIndex)")
        performSegue(withIdentifier: "TableDetailSegue", sender: nil)
        
        
    }
    
    func addAdd(){
        addButton.setImage(#imageLiteral(resourceName: "AddIcon"), for: UIControlState.normal)
        //addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        addButton.backgroundColor = UIColor(red: 0.5625, green: 0.929, blue: 0.5625, alpha: 1.0)
        addButton.center = CGPoint(x: Int(self.view.frame.maxX) - 35 , y: Int(self.view.frame.maxY) - 50)
        addButton.bounds = CGRect(x: 20, y: 20, width: 50, height: 50)
        addButton.setTitleShadowColor(.black, for: .normal)
        addButton.layer.cornerRadius = 25
        addButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        addButton.backgroundColor?.withAlphaComponent(0.5)
        self.view.addSubview(addButton)
        
        
    }

}

