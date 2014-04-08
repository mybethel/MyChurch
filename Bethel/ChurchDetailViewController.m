//
//  ChurchDetailViewController.m
//  Bethel
//
//  Created by Albert Martin on 4/6/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "AppDelegate.h"
#import "ChurchDetailViewController.h"

@implementation ChurchDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = [(AppDelegate *)[[UIApplication sharedApplication] delegate] activeLocation].title;
    
    ChurchGalleryViewController *churchGalleryView = [self.storyboard instantiateViewControllerWithIdentifier:@"ChurchGalleryView"];
    ChurchMainViewController *churchMainView = [self.storyboard instantiateViewControllerWithIdentifier:@"ChurchMainView"];
    self.delegate = self;

    [self setupWithTopViewController:churchGalleryView andTopHeight:240 andBottomViewController:churchMainView];
    self.minimumTopHeight = 180;
    
    // Change the navbar color based on the church settings.
    self.navigationController.navigationBar.barTintColor = [(AppDelegate *)[[UIApplication sharedApplication] delegate] interfaceColor];
}

@end
