//
//  LocationAwareAlert.h
//  
//
//  Created by Albert Martin on 4/13/14.
//
//

#import <UIKit/UIKit.h>
#import "FBShimmeringView.h"

@interface LocationAwareAlert : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic, retain) UILabel *welcomeTitleLabel;
@property (nonatomic) BOOL isLocationAlertVisible;

- (void)showLocationAlert;
- (void)hideLocationAlert;

@end
