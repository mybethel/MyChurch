//
//  MainNavigationController.m
//  Bethel
//
//  Created by Albert Martin on 4/13/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "MainNavigationController.h"
#import "LocationAwareAlert.h"

@implementation MainNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the location aware banner to the view heirarchy.
    _locationBanner = [[LocationAwareAlert alloc] init];
    _locationBanner.view.frame = CGRectMake(0, self.view.bounds.size.height, 320, 36);
    _locationBanner.view.backgroundColor = [UIColor blackColor];
    [_locationBanner viewWillAppear:TRUE];
    [self.view addSubview:_locationBanner.view];
}

@end
