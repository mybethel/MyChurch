//
//  ChurchLocation.m
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import "ChurchLocation.h"
#import <AddressBook/AddressBook.h>
#import "NSAttributedStringMarkdownParser.h"

@interface ChurchLocation ()

@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation ChurchLocation

- (id)initWithLocation:(NSDictionary *)location ministry:(NSDictionary *)ministry
{
    if ((self = [super init])) {
        self.name = location[@"name"];
        self.location = location;
        self.ministry = ministry;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [location[@"loc"][1] doubleValue];
        coordinate.longitude = [location[@"loc"][0] doubleValue];
        
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)uuid {
    return _location[@"_id"];
}

- (NSString *)title {
    return _ministry[@"name"];
}

- (NSString *)subtitle {
    return _name;
}

- (NSAttributedString *)description
{
    NSAttributedStringMarkdownParser* parser = [[NSAttributedStringMarkdownParser alloc] init];
    parser.paragraphFont = [UIFont systemFontOfSize:15];
    return [parser attributedStringFromMarkdownString: _ministry[@"description"]];
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end