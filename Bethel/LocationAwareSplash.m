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

    FBShimmeringView *welcomeTitleView = [[FBShimmeringView alloc] init];
    welcomeTitleView.shimmering = YES;
    welcomeTitleView.shimmeringBeginFadeDuration = 0.3;
    welcomeTitleView.shimmeringOpacity = 0.6;
    welcomeTitleView.shimmeringSpeed = 110;
    welcomeTitleView.frame = CGRectMake(0, 15, self.view.frame.size.width, 200);
    [self.view addSubview:welcomeTitleView];

    UILabel *welcomeTitleLabel = [[UILabel alloc] initWithFrame:welcomeTitleView.bounds];
    welcomeTitleLabel.text = [NSString stringWithFormat:@"Welcome to\n%@", [(AppDelegate *)[[UIApplication sharedApplication] delegate] liveLocation].title];
    welcomeTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:37.0];
    welcomeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    welcomeTitleLabel.numberOfLines = 4;
    welcomeTitleLabel.textColor = [UIColor whiteColor];
    welcomeTitleLabel.textAlignment = NSTextAlignmentCenter;

    welcomeTitleView.contentView = welcomeTitleLabel;
    
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
