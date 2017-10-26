//
//  PeripheralExtensions.swift
//  TheGargsHW
//
//  Created by Robert Steilberg on 10/26/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import Foundation
import CoreBluetooth

extension DetailViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state != CBManagerState.poweredOn) {
            return
        }
        else {
            print("Powered on and ready to go")
            // This is an example of a Notify Characteristic for a Readable value
            transferCharacteristic = CBMutableCharacteristic(type:
                characteristicUUID, properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.readable)
            // This sets up the Service we will use, loads the Characteristic and then adds the Service to the Manager so we can start advertising
            let transferService = CBMutableService(type: serviceUUID, primary: true)
            transferService.characteristics = [self.transferCharacteristic]
            self.peripheralManager.add(transferService)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Data request connection coming in")
        // A subscriber was found, so send them the data
        self.dataToSend = self.JSONdata!.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        self.sentDataCount = 0
        self.sendData()
    }
    
    func sendData() {
        if (sentEOM) {                // sending the end of message indicator
            let didSend:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)
            
            if (didSend) {
                sentEOM = false
                print("Sent: EOM, Outer loop")
            }
            else {
                return
            }
        }
        else {                          // sending the payload
            if (self.sentDataCount >= self.dataToSend.count) {
                return
            }
            else {
                var didSend:Bool = true
                while (didSend) {
                    var amountToSend = self.dataToSend.count - self.sentDataCount
                    if (amountToSend > MTU) {
                        amountToSend = MTU
                    }
                    
                    let range = Range(uncheckedBounds: (lower: self.sentDataCount, upper: self.sentDataCount+amountToSend))
                    var buffer = [UInt8](repeating: 0, count: amountToSend)
                    
                    self.dataToSend.copyBytes(to: &buffer, from: range)
                    let sendBuffer = Data(bytes: &buffer, count: amountToSend)
                    
                    didSend = self.peripheralManager.updateValue(sendBuffer, for: self.transferCharacteristic, onSubscribedCentrals: nil)
                    if (!didSend) {
                        return
                    }
                    if let printOutput = NSString(data: sendBuffer, encoding: String.Encoding.utf8.rawValue) {
                        print("Sent: \(printOutput)")
                    }
                    self.sentDataCount += amountToSend
                    if (self.sentDataCount >= self.dataToSend.count) {
                        sentEOM = true
                        let eomSent:Bool = self.peripheralManager.updateValue(endOfMessage!, for: self.transferCharacteristic, onSubscribedCentrals: nil)
                        if (eomSent) {
                            sentEOM = false
                            print("Sent: EOM, Inner loop")
                        }
                        return
                    }
                }
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        self.peripheralManager.stopAdvertising()
        print("Unsubscribed")
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        self.sendData()
    }
    
}
