//
//  ChurchMainViewController.h
//  Bethel
//
//  Created by Albert Martin on 4/2/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChurchLocation.h"

@interface ChurchMainViewController : UIViewController

@property (nonatomic, retain) NSString *ministryId;
@property (nonatomic, retain) UIColor *interfaceColor;
@property (nonatomic, retain) ChurchLocation *location;

@end
