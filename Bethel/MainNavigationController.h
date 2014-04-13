//
//  MainNavigationController.h
//  Bethel
//
//  Created by Albert Martin on 4/13/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationAwareAlert.h"

@interface MainNavigationController : UINavigationController

@property (nonatomic, strong) LocationAwareAlert *locationBanner;

@end
