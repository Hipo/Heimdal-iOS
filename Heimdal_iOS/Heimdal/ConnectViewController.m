//
//  ViewController.m
//  Heimdal_iOS
//
//  Created by Eralp Karaduman on 29/05/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "ConnectViewController.h"
#import "ConnectionManager.h"

@interface ConnectViewController() <ConnectionManagerDelegate>

@property (nonatomic, strong) ConnectionManager *connectionManager;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _connectionManager = [[ConnectionManager alloc] init];
    _connectionManager.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)onTappedConnectButton:(id)sender {
    [_connectButton setEnabled:YES];
    [_connectionManager connectDoor];
}

#pragma mark - ConnectionManager Delegate Methods
- (void)connectionManagerDidConnect:(ConnectionManager *)connectionManager {
    [_connectionManager openDoor];
}

- (void)connectionManager:(ConnectionManager *)connectionManager didFailConnectWithError:(NSError *)error {
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

- (void)connectionManagerDidOpenDoor:(ConnectionManager *)connectionManager {
    [UIView animateWithDuration:2.0 animations: ^{
        [_connectButton setFrame:CGRectMake(_connectButton.frame.origin.x, _connectButton.frame.origin.y, _connectButton.frame.size.width, 21)];
        [_connectButton setTitle:@"Opening..." forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor colorWithRed:0.105 green:0.742 blue:0.150 alpha:1.000] forState:UIControlStateNormal];
    } completion: ^(BOOL finished) {
        [_connectButton setEnabled:YES];
        [_connectButton setTitle:@"Open" forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
}

- (void)connectionManager:(ConnectionManager *)connectionManager didFailOpenDoorWithError:(NSError *)error {
    [UIView animateWithDuration:1.5 animations:^{
        [_connectButton setFrame:CGRectMake(_connectButton.frame.origin.x, _connectButton.frame.origin.y, _connectButton.frame.size.width, 21)];
        [_connectButton setTitle:@"Cannot Opened!" forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [_connectButton setEnabled:YES];
        [_connectButton setTitle:@"Open" forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
}
@end
