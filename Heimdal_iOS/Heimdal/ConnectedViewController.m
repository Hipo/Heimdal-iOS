//
//  ConnectedViewController.m
//  Heimdal_iOS
//
//  Created by Eralp Karaduman on 29/05/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "ConnectedViewController.h"


@interface ConnectedViewController () <BLEDelegate>

@end

@implementation ConnectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _bleController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTappedOpenDoor:(id)sender {
    
    [_bleController write:[self dataForHex:0x01]];
    [_bleController write:[self dataForHex:0x02]];
    
    [self disconnect];
}

-(void)bleDidReceiveData:(unsigned char *)data length:(int)length{

    UInt8 flag = (UInt8)data;
    
    static UInt8 successFlag = 0x03;
    
    if(flag == successFlag){
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

-(void)disconnect{
    NSLog(@"disconnecting..");
    [_bleController.CM cancelPeripheralConnection:[_bleController activePeripheral]];
    NSLog(@"disconnected");
}

-(void)bleDidDisconnect{
    
}

-(void)bleDidConnect{
    
}

-(NSData*)dataForHex:(UInt8)hex{
    //UInt8 j= 0x0f;
    return [[NSData alloc] initWithBytes:&hex length:sizeof(hex)];
}

@end
