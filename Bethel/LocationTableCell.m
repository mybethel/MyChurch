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
    
    UIView *frame = [[UIView alloc] initWithFrame:CGRectMake(10, 14, CGRectGetWidth(self.contentView.bounds)-20, CGRectGetHeight(self.contentView.bounds)-14)];
    frame.backgroundColor = [UIColor whiteColor];
    frame.tag = 99;
    [self.contentView insertSubview:frame atIndex:0];
    frame.layer.shadowOffset = CGSizeMake(0, 0);
    frame.layer.shadowColor = [[UIColor blackColor] CGColor];
    frame.layer.shadowRadius = 3.0;
    frame.layer.shadowOpacity = 0.2;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        [self viewWithTag:99].layer.shadowOpacity = 0.5;
        [self viewWithTag:99].backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    } else {
        [self viewWithTag:99].layer.shadowOpacity = 0.2;
        [self viewWithTag:99].backgroundColor = [UIColor whiteColor];
    }
}

@end
