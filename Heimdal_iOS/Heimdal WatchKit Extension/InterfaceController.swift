//
//  InterfaceController.swift
//  Heimdal WatchKit Extension
//
//  Created by Bilal Arslan on 29/07/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    // MARK: -
    @IBOutlet weak var openButton: WKInterfaceButton!
    @IBOutlet weak var stateLabel: WKInterfaceLabel!

    
    // MARK: - View Methods
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.stateLabel.setText("Not Connected")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.openButton.setTitle("Open")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        self.openButton.setTitle("Open")
    }
    
    
    @IBAction func didTapOpenButton () {
        
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

//        UIView.animateWithDuration(1.5, animations: { () -> Void in
//            self.openButton.setHeight(35.0)
//            self.openButton.setTitle("Can't Connect!")
//            }, completion: { (finished) -> Void in
//                self.openButton.setTitle("Open");
//        })

    }
}