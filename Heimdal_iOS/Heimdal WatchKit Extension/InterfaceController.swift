//
//  InterfaceController.swift
//  Heimdal WatchKit Extension
//
//  Created by Bilal Arslan on 29/07/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, ConnectionManagerDelegate {
    
    @IBOutlet weak var openButton: WKInterfaceButton!
    @IBOutlet weak var stateLabel: WKInterfaceLabel!
    var connectionManager: ConnectionManager!

    // MARK: - View Methods
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.stateLabel.setText("Not Connected")
        
        connectionManager = ConnectionManager()
        connectionManager.delegate = self
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        self.stateLabel.setText("Not Connected")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func didTapOpenButton () {
        openButton.setEnabled(false)
        self.stateLabel.setText("Connecting")
        connectionManager.connectDoor()
    }
    
    // MARK: - ConnectionManager Delegate Methods
    func connectionManagerDidConnect(connectionManager: ConnectionManager!) {
        self.stateLabel.setText("Connected")
        connectionManager.openDoor()
    }
    
    func connectionManager(connectionManager: ConnectionManager!, didFailConnectWithError error: NSError!) {
        self.stateLabel.setText("Can't Connect!")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Float(NSEC_PER_SEC))), dispatch_get_main_queue  ()) {
            self.stateLabel.setText("Not Connected")
            self.openButton.setEnabled(true)
        }
    }
    
    func connectionManagerDidOpenDoor(connectionManager: ConnectionManager!) {
        self.openButton.setTitle("Opening")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Float(NSEC_PER_SEC))), dispatch_get_main_queue  ()) {
            self.stateLabel.setText("Not Connected")
            self.openButton.setEnabled(true)
        }
    }
    
    func connectionManager(connectionManager: ConnectionManager!, didFailOpenDoorWithError error: NSError!) {
        self.openButton.setTitle("Can't Open!")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Float(NSEC_PER_SEC))), dispatch_get_main_queue  ()) {
            self.stateLabel.setText("Not Connected")
            self.openButton.setTitle("Open");
            self.openButton.setEnabled(true)
        }
    }
}