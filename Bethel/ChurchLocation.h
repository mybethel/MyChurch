//
//  ChurchLocation.h
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ChurchLocation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ministryName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSAttributedString *description;
@property (nonatomic, copy) NSDictionary *ministry;

- (id)initWithName:(NSString*)name ministry:(NSDictionary*)ministry coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end