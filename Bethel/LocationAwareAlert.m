//
//  LocationAwareAlert.m
//  
//
//  Created by Albert Martin on 4/13/14.
//
//

#import "AppDelegate.h"
#import "LocationAwareAlert.h"

@implementation LocationAwareAlert

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _welcomeTitleView = [[FBShimmeringView alloc] init];
    _welcomeTitleView.shimmering = YES;
    _welcomeTitleView.shimmeringBeginFadeDuration = 0.3;
    _welcomeTitleView.shimmeringOpacity = 0.6;
    _welcomeTitleView.shimmeringSpeed = 110;
    _welcomeTitleView.frame = CGRectMake(15, 8, 290, 20);
    [self.view addSubview:_welcomeTitleView];
    
    _welcomeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 0)];
    _welcomeTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    _welcomeTitleLabel.text = @"Welcome to Bethel";
    _welcomeTitleLabel.backgroundColor = [UIColor clearColor];
    _welcomeTitleLabel.textColor = [UIColor whiteColor];
    [_welcomeTitleLabel sizeToFit];
    [_welcomeTitleLabel setClipsToBounds:NO];
    [_welcomeTitleLabel.layer setShadowOffset:CGSizeMake(0, 0)];
    [_welcomeTitleLabel.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_welcomeTitleLabel.layer setShadowRadius:1.0];
    [_welcomeTitleLabel.layer setShadowOpacity:0.6];
    _welcomeTitleView.contentView = _welcomeTitleLabel;
}

- (void)setupLocationAlert
{
    _welcomeTitleLabel.text = [NSString stringWithFormat:@"Welcome to %@", [(AppDelegate *)[[UIApplication sharedApplication] delegate] liveLocation].title];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    } else {
        return NO;
    }
}

@end
