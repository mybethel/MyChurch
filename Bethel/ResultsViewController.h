//
//  ResultsViewController.h
//  Bethel
//
//  Created by Albert Martin on 4/8/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface ResultsViewController : UITableViewController <QMBParallaxScrollViewHolder>

@property (strong, retain) MainViewController *controller;

@end
