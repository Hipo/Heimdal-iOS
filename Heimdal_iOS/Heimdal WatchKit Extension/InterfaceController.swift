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
let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
let popTime2: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
class InterfaceController: WKInterfaceController, BLEDelegate {
    
    // MARK: - ASD
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
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.bleController.delegate = self;
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func didTapOpenButton () {
        self.bleController.peripherals = nil
        self.bleController.findBLEPeripherals(10)
        
        self.cbReady = false;
        
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            
            if let _ = self.bleController.peripherals   {
                for peripheral in self.bleController.peripherals {
                    if peripheral.name == ble_device_name {
                        self.cbReady = true
                        self.bleController.connectPeripheral(peripheral as! CBPeripheral)
                        self.stateLabel.setText("Connected")
                        break
                    }
                }
            }
            
            if self.cbReady == true {
                self.openDoor()
            } else {
                self.openButton.setTitle("Cannot Connect, Try Again!")
                dispatch_after(popTime2, dispatch_get_main_queue(), { () -> Void in
                    self.openButton.setTitle("Open");
                })
            }
        }
    }
    
    func openDoor() {
        self.openButton.setTitle("Opening")
        self.bleController.write(self.dataForHex(0x01))
        self.bleController.write(self.dataForHex(0x02))
        
        dispatch_after(popTime2, dispatch_get_main_queue(), { () -> Void in
            self.disconnect()
            self.connectButtonSettings()
        })
    }
    
    func connectButtonSettings() {
        self.openButton.setTitle("Opened!")
        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
            self.defaultConnectButtonSettings()
        })
    }
    
    func defaultConnectButtonSettings() {
        self.openButton.setTitle("Open")
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