//
//  MapViewController.h
//  Bethel
//
//  Created by Albert Martin on 4/8/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCenter;
    int currentDist;
    BOOL firstLaunch;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, retain) MainViewController *controller;
@property (nonatomic, retain) NSArray *locationResults;
@property (nonatomic, retain) NSDictionary *ministryResults;

- (void)updateMapPins:(UIGestureRecognizer*)gestureRecognizer;

@end
