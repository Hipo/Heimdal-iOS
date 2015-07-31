//
//  ConnectionManager.m
//  Heimdal
//
//  Created by Bilal Arslan on 31/07/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "ConnectionManager.h"
#import "BLE.h"

#define kBLEDeviceName @"BLE Mini"

@interface ConnectionManager() <BLEDelegate>

@property (strong, nonatomic) BLE *bleController;
@property (nonatomic, assign, getter=isConnectionActive) BOOL connectionActive;

@end

@implementation ConnectionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bleController = [[BLE alloc] init];
        [_bleController controlSetup];
        _bleController.delegate = self;
        if([_bleController isConnected]) {
            
            CBPeripheral *peripheral = [_bleController activePeripheral];
            
            if(peripheral){
                [_bleController.CM cancelPeripheralConnection:peripheral];
            }
        }
    }
    return self;
}

- (void)connectDoor {
    [_bleController setPeripherals:nil];
    [_bleController findBLEPeripherals:10];
    
    _connectionActive = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([_bleController.peripherals count] > 0){
            for (CBPeripheral *peripheral in _bleController.peripherals) {
                if ([peripheral.name isEqualToString:kBLEDeviceName]) {
                    [_bleController connectPeripheral:[[_bleController peripherals] objectAtIndex:0]];
                    _connectionActive = YES;
                    break;
                }
            }
        }
        
        if (_connectionActive == YES) {
        } else {
            [_delegate connectionManager:self didFailConnectWithError:nil];
        }
    });
}

- (void)openDoor {
    if (_connectionActive == YES) {
        [_bleController write:[self dataForHex:0x01]];
        [_bleController write:[self dataForHex:0x02]];
        [_delegate connectionManagerDidOpenDoor:self];
    } else {
        [_delegate connectionManager:self didFailOpenDoorWithError:nil];
    }
    [self disconnect];
}

- (void)disconnect {
    CBPeripheral *connectedPeripheral = [_bleController activePeripheral];
    if(connectedPeripheral != nil){
        [_bleController.CM cancelPeripheralConnection:[_bleController activePeripheral]];
    }
}

- (NSData*)dataForHex:(UInt8)hex {
    //UInt8 j= 0x0f;
    return [[NSData alloc] initWithBytes:&hex length:sizeof(hex)];
}

- (void)bleDidConnect {
    NSLog(@"Connected to %@..", kBLEDeviceName);
    _connectionActive = YES;
    [_delegate connectionManagerDidConnect:self];
}

- (void)bleDidDisconnect {
    _connectionActive = NO;
    NSLog(@"Disconnected to %@..", kBLEDeviceName);
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    UInt8 flag = (UInt8)data;
    
    static UInt8 successFlag = 0x03;
    
    if(flag == successFlag) {
        // acti
    } else {
        // bagli ama acamadi.
    }
}
@end
