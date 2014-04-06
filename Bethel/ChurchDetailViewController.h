//
//  ChurchDetailViewController.h
//  Bethel
//
//  Created by Albert Martin on 4/6/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBParallaxScrollViewController.h"
#import "ChurchLocation.h"
#import "ChurchGalleryViewController.h"
#import "ChurchMainViewController.h"

@interface ChurchDetailViewController : QMBParallaxScrollViewController <QMBParallaxScrollViewControllerDelegate>

@property (nonatomic, retain) ChurchLocation *location;

@end
