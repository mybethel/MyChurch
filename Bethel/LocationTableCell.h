//
//  LocationTableCell.h
//  Bethel
//
//  Created by Albert Martin on 4/5/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *ministryName;
@property (nonatomic, weak) IBOutlet UILabel *locationName;
@property (nonatomic, weak) IBOutlet UIImageView *logoView;

@end
