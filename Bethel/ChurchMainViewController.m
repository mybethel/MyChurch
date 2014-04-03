//
//  ChurchMainViewController.m
//  Bethel
//
//  Created by Albert Martin on 4/2/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "ChurchMainViewController.h"

@implementation ChurchMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = _location[@"name"];
    
    // Change the navbar color based on the church settings.
    UIColor* navBarColor = [UIColor colorWithRed:0.580 green:0.760 blue:0.282 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = navBarColor;
}

@end
