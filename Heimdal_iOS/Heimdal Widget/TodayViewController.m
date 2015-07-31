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
#import "ConnectionManager.h"

@interface TodayViewController () <NCWidgetProviding, ConnectionManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
@property (nonatomic, strong) ConnectionManager *connectionManager;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _btnOpen.layer.cornerRadius = _btnOpen.bounds.size.height/2;
    [_btnOpen setBackgroundColor:[UIColor colorWithRed:0.856 green:0.865 blue:0.924 alpha:1.000]];
    [_btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    _connectionManager = [[ConnectionManager alloc] init];
    _connectionManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    self.preferredContentSize = CGSizeMake(0,100);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
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
    [_btnOpen setEnabled:NO];
    [_connectionManager connectDoor];
}

#pragma mark - ConnectionManager Delegate Methods

- (void)connectionManagerDidConnect:(ConnectionManager *)connectionManager {
    [_connectionManager openDoor];
}

- (void)connectionManager:(ConnectionManager *)connectionManager didFailConnectWithError:(NSError *)error {
    [UIView animateWithDuration:1.5 animations:^{
        [_btnOpen setFrame:CGRectMake(_btnOpen.frame.origin.x, _btnOpen.frame.origin.y, _btnOpen.frame.size.width, 30)];
        [_btnOpen setTitle:@"Cannot Connect, Try Again!" forState:UIControlStateNormal];
        [_btnOpen setTitleColor:[UIColor colorWithRed:0.727 green:0.000 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [_btnOpen setEnabled:YES];
        [_btnOpen setTitle:@"Open" forState:UIControlStateNormal];
        [_btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
}

- (void)connectionManagerDidOpenDoor:(ConnectionManager *)connectionManager {
    [UIView animateWithDuration:2.0 animations: ^{
        [_btnOpen setFrame:CGRectMake(_btnOpen.frame.origin.x, _btnOpen.frame.origin.y, _btnOpen.frame.size.width, 30)];
        [_btnOpen setTitle:@"Opening..." forState:UIControlStateNormal];
        [_btnOpen setTitleColor:[UIColor colorWithRed:0.105 green:0.742 blue:0.150 alpha:1.000] forState:UIControlStateNormal];
    } completion: ^(BOOL finished) {
        [_btnOpen setEnabled:YES];
        [_btnOpen setTitle:@"Open" forState:UIControlStateNormal];
        [_btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
}

- (void)connectionManager:(ConnectionManager *)connectionManager didFailOpenDoorWithError:(NSError *)error {
    [UIView animateWithDuration:1.0 animations: ^{
        [_btnOpen setFrame:CGRectMake(_btnOpen.frame.origin.x, _btnOpen.frame.origin.y, _btnOpen.frame.size.width, 30)];
        [_btnOpen setTitle:@"Cannot Opened!" forState:UIControlStateNormal];
        [_btnOpen setTitleColor:[UIColor colorWithRed:0.105 green:0.742 blue:0.150 alpha:1.000] forState:UIControlStateNormal];
    } completion: ^(BOOL finished) {
        [_btnOpen setEnabled:YES];
        [_btnOpen setTitle:@"Open" forState:UIControlStateNormal];
        [_btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
}

@end