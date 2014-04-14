//
//  BethelAPI.h
//  Bethel
//
//  Created by Albert Martin on 4/13/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "AFHTTPRequestOperationManager.h"

@interface BethelAPI : NSObject

- (void)getAllLocationsNear:(CLLocationCoordinate2D)center withRadius:(CLLocationDistance)radius completion:(void (^) (NSDictionary *locations, NSDictionary *ministries))completion;

@end
