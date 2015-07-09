//
//  ConnectedViewController.h
//  Heimdal_iOS
//
//  Created by Eralp Karaduman on 29/05/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ConnectedViewController : UIViewController
@property (nonatomic, strong) BLE *bleController;
@end
