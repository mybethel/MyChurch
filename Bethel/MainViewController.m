//
//  MainViewController.m
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"
#import "MainViewController.h"
#import "ChurchMainViewController.h"
#import "ChurchLocation.h"

#define METERS_PER_MILE 1609.344;

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Replacing the title with a custom view to allow the "Back" button to be a simple chevron.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"Bethel";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
    
    // Set the color of all newly created navbars.
    [[UINavigationBar appearance] setBarTintColor:self.interfaceColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setAlpha:0.7];
    
    // Set the color of the current navbar, displaying immediate change.
    self.navigationController.navigationBar.barTintColor = self.interfaceColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    
    // Set up the Map View defaults (the rest should move to it's own class)
    _mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate: self];
    [locationManager setDistanceFilter: kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
    
    firstLaunch = TRUE;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = self.interfaceColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showDebugDistance:(id)sender
{
    if ([_locationResults count]) {
        CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude: [[_locationResults objectAtIndex: 0][@"obj"][@"loc"][1] floatValue] longitude: [[_locationResults objectAtIndex: 0][@"obj"][@"loc"][0] floatValue]];
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude: _mapView.userLocation.coordinate.latitude longitude: _mapView.userLocation.coordinate.longitude];
        CLLocationDistance distance = [pinLocation distanceFromLocation:userLocation];
    
        // If the user is within 0.2 kilometers of a church campus, they should be considered at the campus.
        NSString *closest = [NSString stringWithFormat:@"Closest location is %4.0f meters away.", distance];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Debug"
                                                      message:closest
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
        [message show];
    }
}

#pragma mark - Basic UI

- (UIColor *)interfaceColor
{
    return [UIColor colorWithRed:0.082 green:0.568 blue:0.709 alpha:1.0];
}

#pragma mark - Map View

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if ([mapView showsUserLocation] && firstLaunch) {
        MKCoordinateRegion region;
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 4000, 4000);
        [mapView setRegion:region animated:YES];
        firstLaunch = FALSE;
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    // Get the east and west points on the map so we can calculate the zoom level of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));

    currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    currentCenter = self.mapView.centerCoordinate;
    
    NSString *locationQuery = [NSString stringWithFormat:@"http://my.bethel.io/location/map/%f/%f/%d", currentCenter.latitude, currentCenter.longitude, currentDist/1000];
    
    // todo: Update the API to filter only by points within location.
    // Oh and don't forget about pin clustering if we're all the way zoomed out!
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:locationQuery parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (id<MKAnnotation> annotation in _mapView.annotations) {
            if ([annotation isKindOfClass:[ChurchLocation class]]) {
                [_mapView removeAnnotation:annotation];
            }
        }
        NSDictionary *locations = [NSJSONSerialization JSONObjectWithData:[[operation responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        [self setLocationResults:[locations objectForKey: @"locations"]];
        [self setMinistryResults:[locations objectForKey: @"ministries"]];
        [_locationsTableView reloadData];
        
        for (id location in _locationResults) {
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [location[@"obj"][@"loc"][1] doubleValue];
            coordinate.longitude = [location[@"obj"][@"loc"][0] doubleValue];
            ChurchLocation *annotation = [[ChurchLocation alloc] initWithName:location[@"obj"][@"name"] address:location[@"obj"][@"address"] coordinate:coordinate];
            [_mapView addAnnotation:annotation];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of locations in view.
    return [_locationResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MinistryLocationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *item = [_locationResults objectAtIndex:[indexPath row]];

    [[cell textLabel] setText:_ministryResults[item[@"obj"][@"ministry"]][@"name"]];
    [[cell detailTextLabel] setText:item[@"obj"][@"address"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ChurchDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChurchDetail"]) {
        ChurchMainViewController *controller = [segue destinationViewController];
        controller.location = [_locationResults objectAtIndex:[_locationsTableView indexPathForSelectedRow].row][@"obj"];
        controller.ministryId = controller.location[@"ministry"];
        [_locationsTableView deselectRowAtIndexPath:[_locationsTableView indexPathForSelectedRow] animated:YES];
    }
}

@end
