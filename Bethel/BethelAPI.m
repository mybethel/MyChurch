//
//  BethelAPI.m
//  Bethel
//
//  Created by Albert Martin on 4/13/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "BethelAPI.h"

@implementation BethelAPI

- (NSURL *)apiUrl
{
    return [NSURL URLWithString:@"https://my.bethel.io/"];
}

- (NSURL *)constructQueryUrl:(NSString *)query
{
    return [NSURL URLWithString:query relativeToURL:self.apiUrl];
}

- (void)getAllLocationsNear:(CLLocationCoordinate2D)center withRadius:(CLLocationDistance)radius completion:(void (^) (NSDictionary *locations, NSDictionary *ministries))completion
{
    NSURL *locationQuery = [self constructQueryUrl: [NSString stringWithFormat:@"location/map/%f/%f/%f", center.latitude, center.longitude, radius]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[locationQuery absoluteString] parameters:nil success:^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *locations = [NSJSONSerialization JSONObjectWithData:[[op responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        NSDictionary *ministries = [locations objectForKey: @"ministries"];
        locations = [locations objectForKey: @"locations"];
        
        completion(locations,ministries);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
