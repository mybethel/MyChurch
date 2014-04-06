//
//  ChurchMainViewController.h
//  Bethel
//
//  Created by Albert Martin on 4/2/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBParallaxScrollViewController.h"
#import "SVSegmentedControl.h"
#import "ChurchLocation.h"

@interface ChurchMainViewController : UIViewController <QMBParallaxScrollViewHolder>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScroller;
@property (weak, nonatomic) IBOutlet UIView *navigationToolbar;

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;

@end
