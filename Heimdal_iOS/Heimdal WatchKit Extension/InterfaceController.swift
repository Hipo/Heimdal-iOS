//
//  InterfaceController.swift
//  Heimdal WatchKit Extension
//
//  Created by Bilal Arslan on 29/07/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, BLEDelegate {
    
    @IBOutlet weak var openButton: WKInterfaceButton!
    @IBOutlet weak var stateLabel: WKInterfaceLabel!

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func didTapOpenButton () {
    }
}
