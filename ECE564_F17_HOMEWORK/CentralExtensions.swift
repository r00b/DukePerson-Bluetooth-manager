//
//  CentralExtensions.swift
//  TheGargsHW
//
//  Created by Robert Steilberg on 10/26/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import Foundation
import CoreBluetooth

// MARK: CBCentralManagerDelegate extensions

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


// MARK:  CBPeripheralDelegate extensions

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
                receivedData = ""
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
