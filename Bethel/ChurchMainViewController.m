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
    
    // Change the navbar color based on the church settings.
    self.navigationController.navigationBar.barTintColor = self.interfaceColor;
}

@end
