//
//  MainViewController.m
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "ResultsViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the navigation controller to be transparent.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = TRUE;
    self.navigationController.navigationBarHidden = TRUE;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    
    [self setupParallaxScroller];
}

- (void)setupParallaxScroller
{
    MapViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    mapView.controller = self;
    ResultsViewController *resultsView = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsView"];
    resultsView.controller = self;
    
    _locations = [[NSMutableArray alloc] init];
    self.locationsTableView = resultsView.tableView;
    self.delegate = self;
    
    [self setupWithTopViewController:mapView andTopHeight:240 andBottomViewController:resultsView];
    self.maxHeight = self.view.frame.size.height;
    
    _backgroundMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.topViewController.view.bounds))];
    _backgroundMaskView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:_backgroundMaskView belowSubview:self.topViewController.view];
}

#pragma mark - QMBParallaxScrollView delegate functions

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    _backgroundMaskView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.topHeight-scrollView.contentOffset.y);
}

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeTopHeight:(CGFloat)height
{
    _backgroundMaskView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), height);
}

#pragma mark - Basic UI

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIColor *)interfaceColor
{
    return [UIColor colorWithRed:0.082 green:0.568 blue:0.709 alpha:1.0];
}

@end
