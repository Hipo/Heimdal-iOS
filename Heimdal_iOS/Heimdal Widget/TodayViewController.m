//
//  TodayViewController.m
//  Heimdal Widget
//
//  Created by Bilal Arslan on 29/06/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLE.h"

static NSString *ble_device_name = @"BLE Mini";

@interface TodayViewController () <NCWidgetProviding, BLEDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
@property (nonatomic, strong) BLE *bleController;
@property (nonatomic, assign) bool cBReady;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _btnOpen.layer.cornerRadius = _btnOpen.bounds.size.height/2;
    [_btnOpen setBackgroundColor:[UIColor colorWithRed:0.856 green:0.865 blue:0.924 alpha:1.000]];
    [_btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    _bleController = [[BLE alloc] init];
    [_bleController controlSetup];
}

-(void)viewDidAppear:(BOOL)animated {
    self.preferredContentSize = CGSizeMake(0,100);
    
    [_bleController setDelegate:self];
    
    if([_bleController isConnected]){
        
        CBPeripheral *peripheral = [_bleController activePeripheral];
        
        if(peripheral){
            [_bleController.CM cancelPeripheralConnection:peripheral];
        }
    }
    
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}

#pragma mark - Update widget status
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - Button Action
- (IBAction)didTapConnect:(UIButton *)sender {
    [_bleController setPeripherals:nil];
    [_bleController findBLEPeripherals:10];
    
    _cBReady = false;
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([_bleController.peripherals count] > 0) {
            for(CBPeripheral *peripheral in _bleController.peripherals){
                if([peripheral.name isEqualToString:ble_device_name]){
                    _cBReady = true;
                    [_bleController connectPeripheral:[_bleController.peripherals objectAtIndex:0]];
                    break;
                }
            }
        } else {
            _cBReady = false;
        }
        [self openDoor];
    });
}

-(void)openDoor {
    if (_cBReady) {
        [UIView animateWithDuration:3.0 animations:^{
            [_btnOpen setFrame:CGRectMake(_btnOpen.frame.origin.x, _btnOpen.frame.origin.y, _btnOpen.frame.size.width, 30)];
            [_btnOpen setTitle:@"Opening..." forState:UIControlStateNormal];
            [_btnOpen setTitleColor:[UIColor colorWithRed:0.105 green:0.742 blue:0.150 alpha:1.000] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            [_btnOpen setTitle:@"Open" forState:UIControlStateNormal];
            [_btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_bleController write:[self dataForHex:0x01]];
            [_bleController write:[self dataForHex:0x02]];
            [self disconnect];
        }];
    } else {
        [UIView animateWithDuration:1.5 animations:^{
            [_btnOpen setFrame:CGRectMake(_btnOpen.frame.origin.x, _btnOpen.frame.origin.y, _btnOpen.frame.size.width, 30)];
            [_btnOpen setTitle:@"Try Again!" forState:UIControlStateNormal];
            [_btnOpen setTitleColor:[UIColor colorWithRed:0.727 green:0.000 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            [_btnOpen setTitle:@"Open" forState:UIControlStateNormal];
            [_btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }];
    }
}
#pragma mark - BLEDelegate Methods

-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{
    
    UInt8 flag = (UInt8)data;
    
    static UInt8 successFlag = 0x03;
    
    if(flag == successFlag){
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
    
}

-(void)bleDidDisconnect {}

-(void)bleDidConnect {}

-(void)disconnect{
    NSLog(@"disconnecting..");
    [_bleController.CM cancelPeripheralConnection:[_bleController activePeripheral]];
    NSLog(@"disconnected");
}

-(NSData*)dataForHex:(UInt8)hex{
    //UInt8 j= 0x0f;
    return [[NSData alloc] initWithBytes:&hex length:sizeof(hex)];
}
@end
