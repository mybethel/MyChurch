//
//  ResultsViewController.m
//  Bethel
//
//  Created by Albert Martin on 4/8/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "AppDelegate.h"
#import "ResultsViewController.h"
#import "AFHttpRequestOperationManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LocationTableCell.h"
#import "MainNavigationController.h"
#import "BethelAPI.h"

#define kMapOffsetY -200.0
#define kMapHeight 240.0

@implementation ResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the navigation controller to be transparent.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = TRUE;
    self.navigationController.navigationBarHidden = TRUE;
    
    // Set up the table view defaults
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    
    [self setupMapView];
    [self setupBranding];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] liveLocation]) {
        [[(MainNavigationController *)window.rootViewController locationBanner] showLocationAlert];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark Map View

- (void)setupMapView
{
    UIView *tableHeader;
    tableHeader = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), kMapHeight)];
    tableHeader.backgroundColor = [UIColor clearColor];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, kMapOffsetY, CGRectGetWidth(self.view.frame), CGRectGetHeight(tableHeader.frame) + ABS(kMapOffsetY))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = TRUE;
    [self.view insertSubview:_mapView belowSubview:self.tableView];
    
    self.tableView.tableHeaderView = tableHeader;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDistanceFilter: kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
    
    _mapCenter = locationManager.location.coordinate;
    _mapCenter.latitude = _mapCenter.latitude + 0.012;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_mapCenter, 4000, 4000);
    [_mapView setRegion:region animated:YES];
    _mapView.delegate = self;
    
    _locations = [[NSMutableArray alloc] init];
    
    [self setupMapMath];
}

- (void)setupMapMath
{
    CLLocationCoordinate2D referencePosition, referencePosition2;
    referencePosition = [_mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:_mapView];
    referencePosition2 = [_mapView convertPoint:CGPointMake(0, 100) toCoordinateFromView:_mapView];
    deltaLatFor1px = (referencePosition2.latitude - referencePosition.latitude)/100;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self updateMapPins];
}

- (void)updateMapPins
{
    if (firstLaunch || isScrolling) return;
    
    // Get the east and west points on the map so we can calculate the zoom level of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    double currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    [[BethelAPI new] getAllLocationsNear:self.mapView.centerCoordinate withRadius:currentDist/1000 completion:^(NSDictionary *locations, NSDictionary *ministries) { [self processLocations:locations ministries:ministries]; }];
}

- (void)processLocations:(NSDictionary *)locations ministries:(NSDictionary *)ministries
{
    ChurchLocation *locationResult;
    NSMutableArray *keepLocations = [[NSMutableArray alloc] init];
    BOOL skipLocationAdd;
    
    for (id location in locations) {
        skipLocationAdd = FALSE;
        for (ChurchLocation *oldLocation in _locations) {
            NSString *locationId = oldLocation.uuid;
            if ([locationId isEqualToString: location[@"obj"][@"_id"]]) {
                skipLocationAdd = TRUE;
                [keepLocations addObject:locationId];
            }
        }
        if (!skipLocationAdd) {
            locationResult = [[ChurchLocation alloc] initWithLocation:location[@"obj"] ministry:ministries[location[@"obj"][@"ministry"]]];
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
    [self.tableView reloadData];
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

#pragma mark Scroll View

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _mapCenter = _mapView.centerCoordinate;
    isScrolling = TRUE;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset < 0) {
        double deltaLat = scrollOffset * deltaLatFor1px;
        CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(_mapCenter.latitude-deltaLat/2, _mapCenter.longitude);
        _mapView.centerCoordinate = newCenter;
        _branding.frame = CGRectMake(0, scrollOffset, CGRectGetWidth(_branding.frame), CGRectGetHeight(_branding.frame));
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isScrolling = FALSE;
}

#pragma mark Table View

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_locations count]-1) {
        return 99+36;
    }
    
    return 89;
}

#pragma mark General UI

- (void)setupBranding
{
    // Content perfect pixel
    UIView *pixel = [[UIView alloc] initWithFrame:CGRectMake(0, kMapHeight, CGRectGetWidth(self.view.bounds), 1)];
    pixel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [self.view addSubview:pixel];
    
    _branding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mapView.bounds), 40)];
    [self.view addSubview:_branding];
    
    // Gradient to top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, CGRectGetWidth(_mapView.bounds), 40);
    gradient.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor],
                        (id)[[UIColor colorWithWhite:0.0 alpha:0] CGColor]];
    [_branding.layer addSublayer:gradient];
    
    CALayer *logo = [CALayer layer];
    logo.frame = CGRectMake((self.view.bounds.size.width/2)-(97/2), 10, 97, 20);
    logo.contents = (id)[UIImage imageNamed:@"Logo"].CGImage;
    [gradient addSublayer:logo];
    
    // Content perfect pixel
    UIView *perfectPixelContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mapView.bounds), 1)];
    perfectPixelContent.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    [_branding addSubview:perfectPixelContent];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.navigationController.view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.navigationController.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.navigationController.view.layer.mask = maskLayer;
    self.navigationController.view.layer.masksToBounds = TRUE;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChurchDetail"]) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setActiveLocation: [_locations objectAtIndex: [self.tableView indexPathForSelectedRow].row]];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

@end
