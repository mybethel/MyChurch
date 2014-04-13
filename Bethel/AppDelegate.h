//
//  AppDelegate.h
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "ChurchLocation.h"
#import "LocationAwareAlert.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ChurchLocation *activeLocation;
@property (nonatomic, retain) UIColor *interfaceColor;
@property (nonatomic, retain) UIWindow *locationAlertWindow;

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) ChurchLocation *liveLocation;

@end
