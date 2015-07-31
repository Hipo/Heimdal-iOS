//
//  InterfaceController.swift
//  Heimdal WatchKit Extension
//
//  Created by Bilal Arslan on 29/07/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

import WatchKit
import Foundation

let ble_device_name: String = "BLE Mini"

class InterfaceController: WKInterfaceController, BLEDelegate {
    
    // MARK: -
    @IBOutlet weak var openButton: WKInterfaceButton!
    @IBOutlet weak var stateLabel: WKInterfaceLabel!
    var bleController: BLE!
    var cbReady: Bool!

    
    // MARK: - View Methods
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        self.bleController = BLE()
        self.bleController.controlSetup()
        if self.bleController.isConnected() == true {
            if let peripheral: CBPeripheral = bleController.activePeripheral {
                self.bleController.CM!.cancelPeripheralConnection(peripheral)
            }
        }
        self.stateLabel.setText("Not Connected")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.openButton.setTitle("Open")
        self.bleController.delegate = self;
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        self.openButton.setTitle("Open")
    }
    
    
    @IBAction func didTapOpenButton () {
//        self.bleController.peripherals = nil
//        self.bleController.findBLEPeripherals(10)
//        
//        self.cbReady = false;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Float(NSEC_PER_SEC))), dispatch_get_main_queue  ()) {
            
            WKInterfaceController.openParentApplication(["openTheDoor": "appleWatch"]) { userInfo, error in
                
                if  (error == nil) {
                    if let success = (userInfo as? [String: AnyObject])?["success"] as? NSNumber {
                        if success.boolValue == true {
                            println("Read data from Wormhole and update interface!")
                        }
                    }
                } else {
                    
                }
            }
            return
        }
        
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            
//            if let _ = self.bleController.peripherals   {
//                for peripheral in self.bleController.peripherals {
//                    if peripheral.name == ble_device_name {
//                        self.cbReady = true
//                        self.bleController.connectPeripheral(self.bleController.peripherals.objectAtIndex(0) as! CBPeripheral)
//                        break
//                    }
//                }
//            }
//            
//            if self.cbReady == true {
//                self.openDoor()
//            } else {
//                UIView.animateWithDuration(1.5, animations: { () -> Void in
//                    self.openButton.setHeight(35.0)
//                    self.openButton.setTitle("Can't Connect!")
//                }, completion: { (finished) -> Void in
//                    self.openButton.setTitle("Open");
//                })
//            }
//        }
    }
    
    func openDoor() {
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.openButton.setHeight(35.0)
            self.openButton.setTitle("Opening")
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                
                WKInterfaceController.openParentApplication(["openTheDoor": "appleWatch"]) { userInfo, error in
                    
                    if  (error == nil) {
                        if let success = (userInfo as? [String: AnyObject])?["success"] as? NSNumber {
                            if success.boolValue == true {
                                println("Read data from Wormhole and update interface!")
                            }
                        }
                    } else {
                        
                    }
                }
                
                return
            }
//            self.bleController.write(self.dataForHex(0x01))
//            self.bleController.write(self.dataForHex(0x02))
//            self.disconnect()
            }, completion: { (finished) -> Void in
                self.connectButtonSettings()
        })
    }
    
    func connectButtonSettings() {
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.openButton.setHeight(35.0)
            self.openButton.setTitle("Opened!")
            }, completion: { (finished) -> Void in
                self.openButton.setTitle("Open")
        })
    }
    
    func disconnect() {
        print("Disconnecting from Apple Watch\n")
        self.bleController.CM.cancelPeripheralConnection(self.bleController.activePeripheral)
        print("Disconnected from Apple Watch\n")
    }
    
    func dataForHex(hex: UInt8) -> NSData {
        return NSData(bytes: [hex], length: sizeofValue(hex))
    }
    
    // MARK: - BLEDelegate Methods
    func bleDidReceiveData(data: UnsafeMutablePointer<UInt8>, length: Int32) {
        
    }
    
    func bleDidDisconnect() {
        self.stateLabel.setText("Not Connected")
    }
    
    func bleDidConnect() {
        self.stateLabel.setText("Connected")
    }
    
}