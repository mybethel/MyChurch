//
//  MainViewController.m
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "ResultsViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Replacing the title with a custom view to allow the "Back" button to be a simple chevron.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"Bethel";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
    
    // Set the color of all newly created navbars.
    [[UINavigationBar appearance] setBarTintColor:self.interfaceColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setAlpha:0.7];
    
    // Set the color of the current navbar, displaying immediate change.
    self.navigationController.navigationBar.barTintColor = self.interfaceColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    
    MapViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    mapView.controller = self;
    ResultsViewController *resultsView = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsView"];
    resultsView.controller = self;
    self.locationsTableView = resultsView.tableView;
    self.delegate = self;
    
    _locations = [[NSMutableArray alloc] init];
    
    [self setupWithTopViewController:mapView andTopHeight:240 andBottomViewController:resultsView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = self.interfaceColor;
}

#pragma mark - Basic UI

- (UIColor *)interfaceColor
{
    return [UIColor colorWithRed:0.082 green:0.568 blue:0.709 alpha:1.0];
}

@end
