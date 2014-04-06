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
    self.navigationItem.title = _location.title;
    
    NSScanner *scanner = [NSScanner scannerWithString:_location.ministry[@"color"]];
    NSString *junk, *red, *green, *blue;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&red];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&green];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&blue];
    
    _interfaceColor = [UIColor colorWithRed:red.intValue/255.0 green:green.intValue/255.0 blue:blue.intValue/255.0 alpha:1.0];
    
    SVSegmentedControl *navigation = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Media", @"About", @"Connect", nil]];
    [navigation addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    navigation.thumb.tintColor = _interfaceColor;
    navigation.height = 46;
    navigation.textShadowColor = [UIColor clearColor];
    navigation.font = [UIFont boldSystemFontOfSize:17];
    navigation.backgroundTintColor = nil;
    navigation.innerShadowColor = [UIColor clearColor];
    navigation.thumb.gradientIntensity = 0.05;
    navigation.thumb.shouldCastShadow = FALSE;
    navigation.thumb.textShadowColor = [UIColor clearColor];
    navigation.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    navigation.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    
	[self.view addSubview:navigation];
    [navigation setSelectedSegmentIndex:1 animated:NO];
	
	navigation.center = CGPointMake(160, 200);
    
    // Change the navbar color based on the church settings.
    self.navigationController.navigationBar.barTintColor = self.interfaceColor;
}

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
	NSLog(@"segmentedControl %i did select index %i (via UIControl method)", segmentedControl.tag, segmentedControl.selectedSegmentIndex);
}

@end
