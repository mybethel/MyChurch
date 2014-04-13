//
//  LocationAwareAlert.h
//  
//
//  Created by Albert Martin on 4/13/14.
//
//

#import <UIKit/UIKit.h>
#import "FBShimmeringView.h"

@interface LocationAwareAlert : UIViewController

@property (nonatomic, retain) FBShimmeringView *welcomeTitleView;
@property (nonatomic, retain) UILabel *welcomeTitleLabel;
@property (nonatomic, retain) NSString *welcomeTitle;

- (void)setupLocationAlert;

@end
