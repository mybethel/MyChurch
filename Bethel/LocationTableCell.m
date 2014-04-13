//
//  LocationTableCell.m
//  Bethel
//
//  Created by Albert Martin on 4/5/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "LocationTableCell.h"

@implementation LocationTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *frame = [[UIView alloc] initWithFrame:CGRectMake(10, 14, CGRectGetWidth(self.bounds)-20, CGRectGetHeight(self.bounds)-14)];
    frame.backgroundColor = [UIColor whiteColor];
    [self insertSubview:frame atIndex:0];
    [frame.layer setShadowOffset:CGSizeMake(0, 0)];
    [frame.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [frame.layer setShadowRadius:3.0];
    [frame.layer setShadowOpacity:0.2];
}

@end
