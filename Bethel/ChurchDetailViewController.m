//
//  ChurchDetailViewController.m
//  Bethel
//
//  Created by Albert Martin on 4/6/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "HACollectionViewSmallLayout.h"
#import "HACollectionViewLargeLayout.h"
#import "ChurchDetailViewController.h"

@implementation ChurchDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    self.navigationItem.title = [(AppDelegate *)[[UIApplication sharedApplication] delegate] activeLocation].title;
    
    [self setupGalleryView];
    [self setupTopView];
}

- (void)setupGalleryView
{
    // Init mainView
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 4;
    _mainView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:_mainView belowSubview:self.collectionView];
    
    self.collectionView.collectionViewLayout = [[HACollectionViewSmallLayout alloc] init];
    self.collectionView.backgroundColor = [UIColor clearColor];
    _transitionController = [[HATransitionController alloc] initWithCollectionView:self.collectionView];
    _transitionController.delegate = self;
    
    // ImageView on top
    _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _topImage.contentMode = UIViewContentModeScaleAspectFill;
    _topImage.image = [UIImage imageNamed:@"TemporaryImage.jpg"];
    _reflected = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topImage.bounds), 320, 320)];
    _reflected.image =[UIImage imageNamed:@"TemporaryImage.jpg"];
    _reflected.contentMode = UIViewContentModeScaleAspectFill;
    
    [_mainView addSubview:_topImage];
    [_mainView addSubview:_reflected];
    
    _topImage.layer.masksToBounds = TRUE;
    _reflected.layer.masksToBounds = TRUE;
    
    _reflected.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    // Gradient to top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _topImage.bounds;
    gradient.colors = @[(id)[[UIColor colorWithWhite:0 alpha:0.4] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_topImage.layer insertSublayer:gradient atIndex:0];
    
    // Gradient to reflected image
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    gradientReflected.frame = _reflected.bounds;
    gradientReflected.colors = @[(id)[[UIColor blackColor] CGColor],
                                 (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_reflected.layer insertSublayer:gradientReflected atIndex:0];
    
    UIView *topPixel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_topImage.bounds), 1)];
    topPixel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [_topImage addSubview:topPixel];
}

- (void)setupTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), [(HACollectionViewSmallLayout *)self.collectionView.collectionViewLayout sectionInset].top)];
    [self.view insertSubview:topView aboveSubview:self.collectionView];
    
    // Setup ministry name label
    UILabel *ministryName = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 290, 0)];
    ministryName.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    ministryName.text = self.navigationItem.title;
    [self setupLabel: ministryName];
    [topView addSubview:ministryName];
    
    // Setup ministry location label
    UILabel *ministryLocation = [[UILabel alloc] initWithFrame:CGRectMake(15, ministryName.frame.origin.y + CGRectGetHeight(ministryName.frame)+2, 290, 0)];
    ministryLocation.font = [UIFont fontWithName:@"Helvetica" size:13];
    ministryLocation.text = [(AppDelegate *)[[UIApplication sharedApplication] delegate] activeLocation].name;
    [self setupLabel: ministryLocation];
    [topView addSubview:ministryLocation];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [label setClipsToBounds:NO];
    [label.layer setShadowOffset:CGSizeMake(0, 0)];
    [label.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [label.layer setShadowRadius:1.0];
    [label.layer setShadowOpacity:0.6];
}

- (void)interactionBeganAtPoint:(CGPoint)point
{
    // Very basic communication between the transition controller and the top view controller
    // It would be easy to add more control, support pop, push or no-op
    ChurchDetailViewController *presentingVC = (ChurchDetailViewController *)[self.navigationController topViewController];
    ChurchDetailViewController *presentedVC = (ChurchDetailViewController *)[presentingVC nextViewControllerAtPoint:point];
    
    if (presentedVC != nil) {
        [self.navigationController pushViewController:presentedVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (animationController==_transitionController) {
        return _transitionController;
    }
    return nil;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (![fromVC isKindOfClass:[UICollectionViewController class]] || ![toVC isKindOfClass:[UICollectionViewController class]] || !self.transitionController.hasActiveInteraction) {
        return nil;
    }
    
    self.transitionController.navigationOperation = operation;
    return self.transitionController;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [self nextViewControllerAtPoint:CGPointZero];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)point
{
    // We could have multiple section stacks and find the right one,
    HACollectionViewLargeLayout *largeLayout = [[HACollectionViewLargeLayout alloc] init];
    HAPaperCollectionViewController *nextCollectionViewController = [[HAPaperCollectionViewController alloc] initWithCollectionViewLayout:largeLayout];
    
    nextCollectionViewController.useLayoutToLayoutNavigationTransitions = YES;
    return nextCollectionViewController;
}

- (UICollectionViewLayout *)collectionViewLayout
{
    HACollectionViewSmallLayout *smallLayout = [[HACollectionViewSmallLayout alloc] init];
    return smallLayout;
}

@end
