//
//  ViewController.m
//  Heimdal_iOS
//
//  Created by Eralp Karaduman on 29/05/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "ConnectViewController.h"
#import "BLE.h"
#import "ConnectedViewController.h"

static NSString *ble_device_name = @"BLE Mini";

@interface ConnectViewController () <BLEDelegate>

@property (nonatomic, strong) BLE *bleController;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *overlayConnectButton;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _bleController = [[BLE alloc] init];
    [_bleController controlSetup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_bleController setDelegate:self];
    
    if([_bleController isConnected]) {
        
        CBPeripheral *peripheral = [_bleController activePeripheral];
        
        if(peripheral){
            [_bleController.CM cancelPeripheralConnection:peripheral];
        }
    }
    
    [_connectButton setEnabled:YES];
    [_overlayConnectButton setEnabled:_connectButton.enabled];
}

- (IBAction)onTappedConnectButton:(id)sender {

    //[self bleDidConnect]; return; /*uncomment for testing on simulator*/
    
    [_connectButton setEnabled:NO];
    [_overlayConnectButton setEnabled:_connectButton.enabled];
    
    [_bleController setPeripherals:nil];
    [_bleController findBLEPeripherals:10];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        BOOL found = NO;
        
        if ([_bleController.peripherals count] > 0) {
            
            for(CBPeripheral *peripheral in _bleController.peripherals){
                if([peripheral.name isEqualToString:ble_device_name]){
                    found = YES;
                    [_bleController connectPeripheral:[_bleController.peripherals objectAtIndex:0]];
                    break;
                }
            }
        }
        
        if(!found) {
            [[[UIAlertView alloc] initWithTitle:@"Device not found or someone else is connected (is your bluetooth on?)"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK :'("
                              otherButtonTitles:nil] show];
            
            [_connectButton setEnabled:YES];
            [_overlayConnectButton setEnabled:_connectButton.enabled];
        }
    });
    
}

- (void)bleDidConnect {
    [self performSegueWithIdentifier:@"connected" sender:self];
}

- (void)bleDidDisconnect {
    [_connectButton setEnabled:YES];
    [_overlayConnectButton setEnabled:_connectButton.enabled];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"connected"]){
        ConnectedViewController *connectedVC = (ConnectedViewController*)segue.destinationViewController;
        connectedVC.bleController = _bleController;
    }
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    NSLog(@"Message received.");
}

@end
