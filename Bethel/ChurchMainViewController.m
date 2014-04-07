//
//  ChurchMainViewController.m
//  Bethel
//
//  Created by Albert Martin on 4/2/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "AppDelegate.h"
#import "ChurchMainViewController.h"

@interface ChurchMainViewController()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end

@implementation ChurchMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SVSegmentedControl *navigation = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Media", @"About", @"Connect", nil]];
    [navigation addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    navigation.thumb.tintColor = [(AppDelegate *)[[UIApplication sharedApplication] delegate] interfaceColor];
    navigation.height = 46;
    navigation.textShadowColor = [UIColor clearColor];
    navigation.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    navigation.backgroundTintColor = [UIColor clearColor];
    navigation.innerShadowColor = [UIColor clearColor];
    navigation.thumb.gradientIntensity = 0.05;
    navigation.thumb.shouldCastShadow = FALSE;
    navigation.thumb.textShadowColor = [UIColor clearColor];
    navigation.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    navigation.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    
	[_navigationToolbar addSubview:navigation];
    [navigation setSelectedSegmentIndex:1 animated:NO];
    
    navigation.center = CGPointMake(160, 25);
    
    _churchDescription.attributedText = [(AppDelegate *)[[UIApplication sharedApplication] delegate] activeLocation].description;
    CGSize textViewSize = [_churchDescription sizeThatFits:CGSizeMake(_churchDescription.frame.size.width, FLT_MAX)];
    self.textViewHeightConstraint.constant = textViewSize.height;
    [_churchDescription layoutIfNeeded];
}

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
    
}

- (UIScrollView *)scrollViewForParallexController
{
    return self.scrollView;
}

@end
