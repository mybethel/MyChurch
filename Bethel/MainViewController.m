//
//  MainViewController.m
//  Bethel
//
//  Created by Albert Martin on 11/17/13.
//  Copyright (c) 2013 Albert Martin. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainViewController.h"
#import "ChurchDetailViewController.h"
#import "ChurchMainViewController.h"
#import "ChurchLocation.h"
#import "LocationTableCell.h"
#import "AppDelegate.h"

#define METERS_PER_MILE 1609.344;

@interface MainViewController ()

@property (nonatomic, retain) NSMutableArray *locations;

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
    
    // Set up the table view defaults
    _locationsTableView.backgroundView = nil;
    _locationsTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    
    firstLaunch = TRUE;
    _locations = [[NSMutableArray alloc] init];
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
    
    // todo: Pin clustering if we're all the way zoomed out!
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:locationQuery parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *locations = [NSJSONSerialization JSONObjectWithData:[[operation responseString] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        _locationResults = [locations objectForKey: @"locations"];
        _ministryResults = [locations objectForKey: @"ministries"];
        
        ChurchLocation *locationResult;
        NSMutableArray *keepLocations = [[NSMutableArray alloc] init];
        BOOL skipLocationAdd;
        
        for (id location in _locationResults) {
            skipLocationAdd = FALSE;
            for (ChurchLocation *oldLocation in _locations) {
                NSString *locationId = oldLocation.uuid;
                if ([locationId isEqualToString: location[@"obj"][@"_id"]]) {
                    skipLocationAdd = TRUE;
                    [keepLocations addObject:locationId];
                }
            }
            if (!skipLocationAdd) {
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [location[@"obj"][@"loc"][1] doubleValue];
                coordinate.longitude = [location[@"obj"][@"loc"][0] doubleValue];

                locationResult = [[ChurchLocation alloc] initWithLocation:location[@"obj"] ministry:_ministryResults[location[@"obj"][@"ministry"]] coordinate:coordinate];
                [keepLocations addObject:location[@"obj"][@"_id"]];

                [_mapView addAnnotation:locationResult];
                [_locations addObject:locationResult];
            }
        }
        for (id<MKAnnotation> annotation in _mapView.annotations) {
            if ([annotation isKindOfClass:[ChurchLocation class]] && ![keepLocations containsObject: [(ChurchLocation *)annotation uuid]]) {
                [_mapView removeAnnotation:annotation];
                [_locations removeObjectIdenticalTo:annotation];
            }
        }
        
        [keepLocations removeAllObjects];
        [_locationsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Make sure the user location pin isn't changed.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
    } else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"ChurchDetail" sender:(ChurchLocation *)view.annotation];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of locations in view.
    return [_locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableCell *cell = (LocationTableCell *)[tableView dequeueReusableCellWithIdentifier:@"MinistryLocationCell"];

    ChurchLocation *location = _locations[indexPath.row];
    cell.ministryName.text = location.title;
    cell.locationName.text = location.subtitle;
    [cell.logoView setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://cdn.bethel.io/150x150/%@", location.ministry[@"image"]]]
                   placeholderImage:[UIImage imageNamed:@"Placeholder"]
                   options:SDWebImageRefreshCached];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ChurchDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChurchDetail"]) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];

        if ([sender isKindOfClass:[ChurchLocation class]]) {
            app.activeLocation = sender;
            [_mapView deselectAnnotation:sender animated:YES];
        } else {
            app.activeLocation = [_locations objectAtIndex: [_locationsTableView indexPathForSelectedRow].row];
            [_locationsTableView deselectRowAtIndexPath:[_locationsTableView indexPathForSelectedRow] animated:YES];
        }
    }
}

@end
