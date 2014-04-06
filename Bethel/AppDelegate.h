//
//  AppDelegate.h
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChurchLocation.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ChurchLocation *activeLocation;
@property (nonatomic, retain) UIColor *interfaceColor;

@end
