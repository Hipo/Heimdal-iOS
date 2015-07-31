//
//  AppDelegate.m
//  Heimdal_iOS
//
//  Created by Eralp Karaduman on 29/05/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#define kIdentifier @"HipoLabs"
#define kUUID [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]

@interface AppDelegate () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchxOptions {
    // Override point for customization after application launch.
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;

    _beaconRegion = [[CLBeaconRegion  alloc] initWithProximityUUID: kUUID identifier:kIdentifier];
//    _beaconRegion.notifyEntryStateOnDisplay = NO;
//    _beaconRegion.notifyOnEntry = YES;
//    _beaconRegion.notifyOnExit = YES;

    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
    [_locationManager startMonitoringForRegion:_beaconRegion];
    [_locationManager requestAlwaysAuthorization];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
    if (userInfo[@"openTheDoor"] != nil) {
        
        reply(@{@"connection":@(YES)});
    } else {
        reply(@{@"connection":@(NO)});
    }
}

#pragma mark - CLLocationManager Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    //NSLog(@"State: %ld", (long)state);
    //NSLog(@"Identifier: %@ ", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    ////Adding a custom local notification to be presented
    //NSLog(@"You've entered the region %@", region);
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    ////Adding a custom local notification to be presented
    //NSLog(@"You've exited the region %@", region);
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
////  Identify closest beacon
//    if (beacons.count > 0) {
//        CLBeacon *firstBeacon = [beacons firstObject];
//        switch (firstBeacon.proximity) {
//            case CLProximityUnknown: {
//                NSLog(@"Proximity is Unknown");
//                break;
//            }
//            case CLProximityImmediate: {
//                // so close to the beacon
//                NSLog(@"Proximity is Immediate");
//                break;
//            }
//            case CLProximityNear: {
//                // near the beacon
//                NSLog(@"Proximity is Near");
//                break;
//            }
//            case CLProximityFar: {
//                NSLog(@"Proximity is Far");
//                break;
//            }
//            default: {
//                break;
//            }
//        }
//    }
}


-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    //NSLog(@"Monitoring is started with region: %@", region);
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    //NSLog(@"Region Did Fail: Manager:%@ Region:%@ Error:%@",manager, region, error);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        case kCLAuthorizationStatusNotDetermined:
            [_locationManager requestAlwaysAuthorization];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}
@end
