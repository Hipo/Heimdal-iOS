//
//  ConnectedViewController.m
//  Heimdal_iOS
//
//  Created by Eralp Karaduman on 29/05/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "ConnectedViewController.h"


@interface ConnectedViewController () <BLEDelegate>

@property (strong,nonatomic) IBOutlet UIButton *openButton;
@end

@implementation ConnectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self changeButtonColorThanLoop:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _bleController.delegate = self;
    [self changeButtonColorThanLoop:YES];
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

- (UIColor*)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (void)changeButtonColorThanLoop:(BOOL)loop {
    
    [_openButton setTitleColor:[self randomColor] forState:UIControlStateNormal];
    [self.view setBackgroundColor:[self randomColor]];
    
    if(!loop) {
        return;
    }
    
    float t = 0.1f;
    
    if(self.view.superview){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeButtonColorThanLoop:loop];
        });
    }
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

-(void)disconnect{
    NSLog(@"Disconnecting..");
    CBPeripheral *connectedPeripheral = [_bleController activePeripheral];
    if(connectedPeripheral != nil){
        [_bleController.CM cancelPeripheralConnection:[_bleController activePeripheral]];
        NSLog(@"Disconnected");
    }
}

-(NSData*)dataForHex:(UInt8)hex{
    //UInt8 j= 0x0f;
    return [[NSData alloc] initWithBytes:&hex length:sizeof(hex)];
}

@end
