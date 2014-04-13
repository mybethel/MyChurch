//
//  MapViewController.m
//  Bethel
//
//  Created by Albert Martin on 4/8/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AFNetworking/AFNetworking.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "ChurchLocation.h"

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the Map View defaults (the rest should move to it's own class)
    _mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate: self];
    [locationManager setDistanceFilter: kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
    
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateMapPins:)];
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];
    
    // Gradient to top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, CGRectGetWidth(_mapView.bounds), 40);
    gradient.colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor],
                        (id)[[UIColor colorWithWhite:0.0 alpha:0] CGColor]];
    [_mapView.layer addSublayer:gradient];
    
    CALayer *logo = [CALayer layer];
    logo.frame = CGRectMake((self.view.bounds.size.width/2)-(97/2), 10, 97, 20);
    logo.contents = (id)[UIImage imageNamed:@"Logo"].CGImage;
    [self.view.layer addSublayer:logo];
    
    // Content perfect pixel
    UIView *perfectPixelContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mapView.bounds), 1)];
    perfectPixelContent.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    [self.view addSubview:perfectPixelContent];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_mapView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _mapView.bounds;
    maskLayer.path = maskPath.CGPath;
    _mapView.layer.mask = maskLayer;
    _mapView.layer.masksToBounds = TRUE;
    
    firstLaunch = TRUE;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if ([mapView showsUserLocation] && firstLaunch) {
        MKCoordinateRegion region;
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 4000, 4000);
        [mapView setRegion:region animated:YES];
        firstLaunch = FALSE;
    }
}

- (void)updateMapPins:(UIGestureRecognizer*)gestureRecognizer
{
    if (firstLaunch || (gestureRecognizer && gestureRecognizer.state != UIGestureRecognizerStateEnded)) return;
    
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
            for (ChurchLocation *oldLocation in _controller.locations) {
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
                [_controller.locations addObject:locationResult];
            }
        }
        for (id<MKAnnotation> annotation in _mapView.annotations) {
            if ([annotation isKindOfClass:[ChurchLocation class]] && ![keepLocations containsObject: [(ChurchLocation *)annotation uuid]]) {
                [_mapView removeAnnotation:annotation];
                [_controller.locations removeObjectIdenticalTo:annotation];
            }
        }
        
        [keepLocations removeAllObjects];
        [_controller.locationsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // Allow animated map changes (no user pan/zoom) to update pin locations.
    if (animated) {
        [self updateMapPins: nil];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChurchDetail"]) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.activeLocation = sender;
        [_mapView deselectAnnotation:sender animated:YES];
    }
}

@end
