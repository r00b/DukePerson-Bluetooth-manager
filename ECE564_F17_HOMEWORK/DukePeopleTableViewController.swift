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
    var connectingPeripheral:CBPeripheral!
    var receivedData: String = ""
    
    // MARK: IBOutlets
    
    @IBOutlet weak var DukeTable: UITableView!
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        DukePeopleDatabase.getFirebaseStatus()
        print("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
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
        self.centralManager.scanForPeripherals(withServices: serviceUUIDs,options: nil)
    }
    
}










extension DukePeopleTableViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Checking state")
        switch(central.state) {
        case .poweredOff:
            print("CB BLE hw is not powered On")
        case .poweredOn:
            print("Scanning for peripherals")
        //            self.centralManager.scanForPeripherals(withServices: serviceUUIDs,options: nil)
        default:
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if RSSI.intValue > -15 {
            return
        }
        print("Discovered \(String(describing: peripheral.name)) at \(RSSI)")
        if connectingPeripheral != peripheral {
            connectingPeripheral = peripheral
            connectingPeripheral.delegate = self
            print("Connecting to peripheral \(peripheral)")
            centralManager.connect(connectingPeripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral) due to error \(String(describing: error))")
        self.cleanup()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("\n\nPeripheral connected\n\n")
        centralManager.stopScan()
        peripheral.delegate = self as CBPeripheralDelegate
        peripheral.discoverServices(nil)
    }
}

// MARK:  CBPeripheralDelegate extension

extension DukePeopleTableViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("Error discovering services \(String(describing: error))")
            self.cleanup()
        }
        else {
            for service in peripheral.services! as [CBService] {
                print("Service UUID  \(service.uuid)\n")
                if (service.uuid == serviceUUID) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print("Error - \(String(describing: error))")
            print(error as Any)
            self.cleanup()
        }
        else {
            for characteristic in service.characteristics! as [CBCharacteristic] {
                print("Characteristic is \(characteristic)\n")
                if (characteristic.uuid == characteristicUUID) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("error")
        }
        else {
            let dataString = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            
            if dataString == "EOM" {
                
                let jsonData = self.receivedData.data(using: .utf8)!
                let decoder = JSONDecoder()
                let myStruct = try! decoder.decode(DPStruct.self, from: jsonData)
                
                createDukePersonFromBluetooth(payloadStruct: myStruct)
                
                peripheral.setNotifyValue(false, for: characteristic)
                self.centralManager.cancelPeripheralConnection(peripheral)
                self.centralManager.stopScan()
                centralManager = CBCentralManager(delegate: self, queue: nil)
            }
            else {
                let strng:String = dataString! as String
                self.receivedData += strng
                print("Received \(dataString!)")
            }
        }
    }
    
    func createDukePersonFromBluetooth(payloadStruct: DPStruct) {
        let gender: Gender!
        switch (payloadStruct.gender) {
        case true:
            gender = .Male
        case false:
            gender = .Female
        }
        
        let role: DukeRole!
        switch (payloadStruct.role) {
        case "Student":
            role = .Student
        case "TA":
            role = .TA
        case "Proffessor":
            role = .Professor
        default:
            role = .Student
        }
        
        let newPerson = DukePerson(firstName: payloadStruct.firstName, lastName: payloadStruct.lastName, whereFrom: payloadStruct.whereFrom, gender: gender, hobbies: payloadStruct.hobbies, role: role, languages: payloadStruct.languages, degree: payloadStruct.degree)
        newPerson.team = payloadStruct.teamName
        
        // push to db
        CurrentData.dukePeople.append(newPerson)
        DukePeopleDatabase.setFirebaseStatus(dukePeople: CurrentData.dukePeople)
        getFireBaseData()
    }
    
    func convertToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("Error changing notification state \(String(describing: error))")
        }
        if (characteristic.uuid != serviceUUID) {
            return
        }
        if (characteristic.isNotifying) {
            print("Notification began on \(characteristic)")
        }
        else {
            print("Notification stopped on \(characteristic). Disconnecting")
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Error on didDisconnect is \(String(describing: error))")
    }
    
    func cleanup() {
        
        switch connectingPeripheral.state {
        case .disconnected:
            print("Cleanup called, .Disconnected")
            return
        case .connected:
            if (connectingPeripheral.services != nil) {
                print("Found")
                //add any additional cleanup code here
            }
        default:
            return
        }
    }
}
