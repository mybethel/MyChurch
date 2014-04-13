//
//  ChurchDetailViewController.h
//  Bethel
//
//  Created by Albert Martin on 4/6/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAPaperCollectionViewController.h"
#import "QMBParallaxScrollViewController.h"
#import "ChurchLocation.h"
#import "HATransitionController.h"

@interface ChurchDetailViewController : HAPaperCollectionViewController <UIScrollViewDelegate, HATransitionControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) ChurchLocation *location;
@property (nonatomic) HATransitionController *transitionController;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *reflected;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSLayoutConstraint *constraintHeight;
@property (nonatomic, strong) NSMutableArray *contrainstArray;

@property (nonatomic, assign) BOOL pageOpened;

@end
