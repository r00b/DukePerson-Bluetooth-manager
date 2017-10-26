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
import CoreBluetooth

class DukePeopleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    // MARK: Properties
    
    var dukePeople = CurrentData.dukePeople
    var tableViewCells = [UITableViewCell]()
    var marker = true
    @objc var addButton = UIButton()
    
    var centralManager: CBCentralManager!
    var connectingPeripheral: CBPeripheral!
    var receivedData: String = ""
    var progressIndicator = UIImageView(image: #imageLiteral(resourceName: "progressIndicatoro"))
    var percentCompleted = UITextView()
    // MARK: IBOutlets
    
    @IBOutlet weak var DukeTable: UITableView!
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        DukePeopleDatabase.getFirebaseStatus()
        print("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
        progressIndicator.center = self.view.center

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.centralManager.stopScan()
        centralManager = nil
        print("Scanning stopped")
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFireBaseData()
    }
    
    
    // MARK: Functions
    
    func getFireBaseData(){
        var dukePeople = [DukePerson]()
        let ref = FIRDatabase.database().reference().child(DukePeopleDatabase.getDbName())
        ref.observeSingleEvent(of: .value, with: { snapshot in
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
            self.setCells(dukePeople: dukePeople)
            CurrentData.dukePeople = dukePeople
        })
    }
    
    func setCells(dukePeople: [DukePerson]){
        tableViewCells.removeAll()
        addProfessors(dukePeople: dukePeople)
        addTAs(dukePeople: dukePeople)
        addStudents(dukePeople: dukePeople)
        addTeams(dukePeople: dukePeople)
        DukeTable.reloadData()
    }
    
    func addProfessors(dukePeople: [DukePerson]){
        if(CurrentData.getProfesors(dukePeople: dukePeople).count > 0){
            tableViewCells = [UITableViewCell]()
            let professorSeperator  = Bundle.main.loadNibNamed("SeperatorTableViewCell", owner: self, options: nil)?.first as! SeperatorTableViewCell
            professorSeperator.setTitle(title: "Professor")
            professorSeperator.backgroundColor = .clear
            tableViewCells.append(professorSeperator)
        }
        for professor in CurrentData.getProfesors(dukePeople: dukePeople){
            let cell  = Bundle.main.loadNibNamed("DukePersonTableViewCell", owner: self, options: nil)?.first as! DukePersonTableViewCell
            
            cell.setDukePerson(dukePerson: professor)
            cell.backgroundColor = .clear
            tableViewCells.append(cell)
        }
    }
    
    func addTAs(dukePeople: [DukePerson]){
        if(CurrentData.getTAs(dukePeople: dukePeople).count > 0){
            let TASeperator  = Bundle.main.loadNibNamed("SeperatorTableViewCell", owner: self, options: nil)?.first as! SeperatorTableViewCell
            TASeperator.setTitle(title: "TA")
            TASeperator.backgroundColor = .clear
            tableViewCells.append(TASeperator)
        }
        for TA in CurrentData.getTAs(dukePeople: dukePeople){
            let cell  = Bundle.main.loadNibNamed("DukePersonTableViewCell", owner: self, options: nil)?.first as! DukePersonTableViewCell
            
            cell.setDukePerson(dukePerson: TA)
            cell.backgroundColor = .clear
            tableViewCells.append(cell)
        }
    }
    
    func addStudents(dukePeople: [DukePerson]){
        if(CurrentData.getStudents(dukePeople: dukePeople).count > 0){
            let studentSeperator  = Bundle.main.loadNibNamed("SeperatorTableViewCell", owner: self, options: nil)?.first as! SeperatorTableViewCell
            studentSeperator.setTitle(title: "Student")
            studentSeperator.backgroundColor = .clear
            tableViewCells.append(studentSeperator)
        }
        
        for student in CurrentData.getStudents(dukePeople: dukePeople){
            let cell  = Bundle.main.loadNibNamed("DukePersonTableViewCell", owner: self, options: nil)?.first as! DukePersonTableViewCell
            cell.setDukePerson(dukePerson: student)
            cell.backgroundColor = .clear
            tableViewCells.append(cell)
        }
    }
    
    func addTeams(dukePeople: [DukePerson]){
        for (teamName, team) in CurrentData.getTeams(dukePeople: dukePeople){
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
    
    func addAdd(){
        addButton.setImage(#imageLiteral(resourceName: "AddIcon"), for: UIControlState.normal)
        addButton.backgroundColor = UIColor(red: 0.5625, green: 0.929, blue: 0.5625, alpha: 1.0)
        addButton.center = CGPoint(x: Int(self.view.frame.maxX) - 35 , y: Int(self.view.frame.maxY) - 50)
        addButton.bounds = CGRect(x: 20, y: 20, width: 50, height: 50)
        addButton.setTitleShadowColor(.black, for: .normal)
        addButton.layer.cornerRadius = 25
        addButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        addButton.backgroundColor?.withAlphaComponent(0.5)
        self.view.addSubview(addButton)
    }
    
    
    // MARK: TableViewController functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return tableViewCells[indexPath.row];
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((tableViewCells[indexPath.row] as? DukePersonTableViewCell) != nil) {
            let dukeCell = tableViewCells[indexPath.row] as! DukePersonTableViewCell
            CurrentData.personIndex = CurrentData.find(dukePerson: dukeCell.info)
            performSegue(withIdentifier: "TableDetailSegue", sender: nil)
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
        } else {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func deleteAction(dukePerson: DukePerson){
        CurrentData.dukePeople.remove(at: CurrentData.dukePeople.index(of: dukePerson)!)
        DukePeopleDatabase.setFirebaseStatus(dukePeople: CurrentData.dukePeople)
        getFireBaseData()
    }
    
    
    // MARK: TextField functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //MARK: SearchBar functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        if(searchBar.text != nil){
            setCells(dukePeople: CurrentData.searchByName(search: searchBar.text!))
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
    
    
    // MARK: IBActions
    
    @IBAction func addAction(_ sender: Any) {
        CurrentData.personIndex = nil
        performSegue(withIdentifier: "TableDetailSegue", sender: nil)
    }
    
    @IBAction func receiveBluetooth(_ sender: UIButton) {
        if(!isReceiving){
            rotateView(targetView: progressIndicator)
            isReceiving = true
            self.view.addSubview(progressIndicator)
            self.view.bringSubview(toFront: progressIndicator)
        }else{
            progressIndicator.removeFromSuperview()
            isReceiving = false;
        }
        self.centralManager.scanForPeripherals(withServices: serviceUUIDs,options: nil)
    }
    var isReceiving = false;
    var delayCount: Int = 0;
    var delayTime: Double{
        set{
            
        }
        get{
            delayCount += 1
            return Double(delayCount) * 0.5
        }
    }
    private func rotateView(targetView: UIView, duration: Double = 0.5) {
        
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
            }) { finished in
                self.progressIndicator.layer.removeAllAnimations()
                self.rotateView(targetView: self.progressIndicator)
            }
        
    }
    
    // RANDOMIZER
    
}
