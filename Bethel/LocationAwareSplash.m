//
//  LocationAwareSplash.m
//  Bethel
//
//  Created by Albert Martin on 4/8/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationAwareSplash.h"
#import "LocationAwareAlert.h"

@implementation LocationAwareSplash

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    _welcomeTitleView = [[FBShimmeringView alloc] init];
    _welcomeTitleView.shimmering = YES;
    _welcomeTitleView.shimmeringBeginFadeDuration = 0.3;
    _welcomeTitleView.shimmeringOpacity = 0.6;
    _welcomeTitleView.shimmeringSpeed = 110;
    _welcomeTitleView.frame = CGRectMake(0, 15, self.view.frame.size.width, 200);
    [self.view addSubview:_welcomeTitleView];

    _welcomeTitleLabel = [[UILabel alloc] initWithFrame:_welcomeTitleView.bounds];
    _welcomeTitleLabel.text = @"Welcome to\nGlobal Community Church";
    _welcomeTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:36.0];
    _welcomeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _welcomeTitleLabel.numberOfLines = 4;
    _welcomeTitleLabel.textColor = [UIColor whiteColor];
    _welcomeTitleLabel.textAlignment = NSTextAlignmentCenter;

    _welcomeTitleView.contentView = _welcomeTitleLabel;
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)closeSplash:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIWindow *locationAlertWindow = [(AppDelegate *)[[UIApplication sharedApplication] delegate] locationAlertWindow];
        [(LocationAwareAlert *)locationAlertWindow.rootViewController showLocationAlert];
    }];
}

@end
