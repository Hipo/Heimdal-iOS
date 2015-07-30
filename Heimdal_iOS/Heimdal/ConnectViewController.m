//
//  ViewController.m
//  Heimdal_iOS
//
//  Created by Eralp Karaduman on 29/05/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "ConnectViewController.h"
#import "BLE.h"

static NSString *ble_device_name = @"BLE Mini";

@interface ConnectViewController () <BLEDelegate>

@property (nonatomic, strong) BLE *bleController;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic, assign) bool cBReady;

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
}

- (IBAction)onTappedConnectButton:(id)sender {
    //[self bleDidConnect]; return; /*uncomment for testing on simulator*/
    [_bleController setPeripherals:nil];
    [_bleController findBLEPeripherals:10];
    [_connectButton setEnabled:NO];
    
    _cBReady = false;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
        if ([_bleController.peripherals count] > 0) {
            for(CBPeripheral *peripheral in _bleController.peripherals){
                if([peripheral.name isEqualToString:ble_device_name]){
                    _cBReady = true;
                    [_bleController connectPeripheral:[_bleController.peripherals objectAtIndex:0]];
                    break;
                }
            }
        }
        
        if (_cBReady == YES) {
            [self openDoor];
        } else {
            [UIView animateWithDuration:1.5 animations:^{
                [_connectButton setFrame:CGRectMake(_connectButton.frame.origin.x, _connectButton.frame.origin.y, _connectButton.frame.size.width, 21)];
                [_connectButton setTitle:@"Try Again!" forState:UIControlStateNormal];
                [_connectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                [_connectButton setEnabled:YES];
                [_connectButton setTitle:@"Open" forState:UIControlStateNormal];
                [_connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }];
        }
    });
}

- (void)openDoor {
    [UIView animateWithDuration:1.0 animations: ^{
        [_connectButton setFrame:CGRectMake(_connectButton.frame.origin.x, _connectButton.frame.origin.y, _connectButton.frame.size.width, 21)];
        [_connectButton setTitle:@"Opening..." forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor colorWithRed:0.105 green:0.742 blue:0.150 alpha:1.000] forState:UIControlStateNormal];
    } completion: ^(BOOL finished) {
        [_bleController write:[self dataForHex:0x01]];
        [_bleController write:[self dataForHex:0x02]];
        [self disconnect];
    }];
}

- (void)connectButtonSettings {
    [_connectButton setTitle:@"Opened!" forState:UIControlStateNormal];
    [self performSelector:@selector(defaultConnectButtonSettings) withObject:nil afterDelay:1.0];
}

- (void)connectButtonWithErrorSettings {
    [_connectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_connectButton setTitle:@"Cannot Opened!" forState:UIControlStateNormal];
    [self performSelector:@selector(defaultConnectButtonSettings) withObject:nil afterDelay:1.0];
}

- (void)defaultConnectButtonSettings {
    [_connectButton setEnabled:YES];
    [_connectButton setTitle:@"Open" forState:UIControlStateNormal];
    [_connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


#pragma mark - BLEDelegate Methods

- (void)bleDidConnect { }

- (void)bleDidDisconnect { }

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    
    UInt8 flag = (UInt8)data;
    
    static UInt8 successFlag = 0x03;
    
    if(flag == successFlag) {
        [self performSelector:@selector(connectButtonSettings) withObject:nil afterDelay:1.0];
    } else {
        [self performSelector:@selector(connectButtonWithErrorSettings) withObject:nil afterDelay:1.0];
    }
}

- (void)disconnect {
    NSLog(@"Disconnecting..");
    CBPeripheral *connectedPeripheral = [_bleController activePeripheral];
    if(connectedPeripheral != nil){
        [_bleController.CM cancelPeripheralConnection:[_bleController activePeripheral]];
        NSLog(@"Disconnected");
    }
}

- (NSData*)dataForHex:(UInt8)hex {
    //UInt8 j= 0x0f;
    return [[NSData alloc] initWithBytes:&hex length:sizeof(hex)];
}
@end
