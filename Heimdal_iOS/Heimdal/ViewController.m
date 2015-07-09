//
//  ViewController.m
//  Heimdal_iOS
//
//  Created by Eralp Karaduman on 29/05/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "ViewController.h"
#import "BLE.h"
#import "ConnectedViewController.h"

static NSString *ble_device_name = @"BLE Mini";

@interface ViewController () <BLEDelegate>
@property (nonatomic, strong) BLE *bleController;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _bleController = [[BLE alloc] init];
    
    [_bleController controlSetup];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [_bleController setDelegate:self];
    
    if([_bleController isConnected]){
        
        CBPeripheral *peripheral = [_bleController activePeripheral];
        
        if(peripheral){
            [_bleController.CM cancelPeripheralConnection:peripheral];
        }
        
    }
    
    [_connectButton setEnabled:YES];
}

- (IBAction)onTappedConnectButton:(id)sender {

    [_connectButton setEnabled:NO];
    
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
        
        if(!found){
            [[[UIAlertView alloc] initWithTitle:@"not found or someone else is connected" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            
            [_connectButton setEnabled:YES];
            
            
        }
        
    });
    
}

-(void)bleDidConnect{
    
    [self performSegueWithIdentifier:@"connected" sender:self];
}

-(void)bleDidDisconnect{
    [_connectButton setEnabled:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"connected"]){
        ConnectedViewController *connectedVC = (ConnectedViewController*)segue.destinationViewController;
        connectedVC.bleController = _bleController;
    }
}

-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{
    
    NSLog(@"msg received");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
