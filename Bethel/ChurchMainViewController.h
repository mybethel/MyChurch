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

@interface ChurchMainViewController : UIViewController <QMBParallaxScrollViewHolder, UIScrollViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *navigationToolbar;
@property (strong, nonatomic) IBOutlet UITextView *churchDescription;
@property (strong, nonatomic) NSLayoutConstraint *descriptionHeightConstraint;

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;

@end
