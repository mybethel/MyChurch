//
//  MainViewController.h
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBParallaxScrollViewController.h"
#import "AppDelegate.h"
#import "ChurchLocation.h"

@interface MainViewController : QMBParallaxScrollViewController <QMBParallaxScrollViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray *locations;
@property (nonatomic, retain) UIColor *interfaceColor;
@property (nonatomic, retain) UITableView *locationsTableView;
@property (nonatomic, retain) UIView *backgroundMaskView;

@end
