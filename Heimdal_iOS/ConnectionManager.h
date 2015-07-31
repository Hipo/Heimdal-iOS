//
//  ConnectionManager.h
//  Heimdal
//
//  Created by Bilal Arslan on 31/07/15.
//  Copyright (c) 2015 Eralp Karaduman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionManagerDelegate;

@interface ConnectionManager : NSObject

@property (nonatomic, weak) id<ConnectionManagerDelegate> delegate;

- (void)connectDoor;
- (void)openDoor;

@end


@protocol ConnectionManagerDelegate <NSObject>

- (void)connectionManagerDidConnect:(ConnectionManager *)connectionManager;
- (void)connectionManager:(ConnectionManager *)connectionManager
  didFailConnectWithError:(NSError *)error;

- (void)connectionManagerDidOpenDoor:(ConnectionManager *)connectionManager;
- (void)connectionManager:(ConnectionManager *)connectionManager didFailOpenDoorWithError:(NSError *)error;

@end