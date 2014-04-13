//
//  AppDelegate.m
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNavigationController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIColor* navBarColor = [UIColor colorWithRed:0.047 green:0.568 blue:0.709 alpha:1.0];

    [[UINavigationBar appearance] setTintColor:navBarColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setAlpha:0.7];
    [[UIToolbar appearance] setTintColor:navBarColor];
    
    self.window.tintColor = navBarColor;
    
    _currentLocation = [[CLLocation alloc] init];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    CLLocationDistance distance = [newLocation distanceFromLocation: _currentLocation];
    
    // Only check if the user is greater than 10 meters from the last known position.
    if (distance > 10) {
        _currentLocation = newLocation;
        
        // Query the API with a radius limit of 100 meters.
        NSString *locationQuery = [NSString stringWithFormat:@"http://my.bethel.io/location/map/%f/%f/%f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude, 0.1];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:locationQuery parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *locations = [NSJSONSerialization JSONObjectWithData:[[operation responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            
            // The API has returned a location within 100 meters, the user is here!
            if ([[locations objectForKey:@"locations"] count] > 0 && [locations objectForKey:@"locations"][0]) {
                NSDictionary *location = [locations objectForKey:@"locations"][0][@"obj"];
                NSDictionary *ministry = [locations objectForKey:@"ministries"][location[@"ministry"]];
                
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [location[@"loc"][1] doubleValue];
                coordinate.longitude = [location[@"loc"][0] doubleValue];
                
                // Populate the ChurchLocation object to use in the splash dialogue.
                _liveLocation = [[ChurchLocation alloc] initWithLocation:location ministry:ministry coordinate:coordinate];
                
                [[(MainNavigationController *)self.window.rootViewController locationBanner] showLocationAlert];
            } else {
                [[(MainNavigationController *)self.window.rootViewController locationBanner] hideLocationAlert];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setActiveLocation:(ChurchLocation *)activeLocation
{
    _activeLocation = activeLocation;
    
    NSScanner *scanner = [NSScanner scannerWithString:_activeLocation.ministry[@"color"]];
    NSString *junk, *red, *green, *blue;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&red];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&green];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&blue];
    
    _interfaceColor = [UIColor colorWithRed:red.intValue/255.0 green:green.intValue/255.0 blue:blue.intValue/255.0 alpha:1.0];
}

@end
