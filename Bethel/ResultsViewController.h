//
//  ResultsViewController.h
//  Bethel
//
//  Created by Albert Martin on 4/8/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ChurchLocation.h"

@interface ResultsViewController : UITableViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>
{
    CLLocationManager *locationManager;
    double deltaLatFor1px;
    BOOL firstLaunch;
    BOOL isScrolling;
}

@property (nonatomic, strong) UIView *branding;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D mapCenter;
@property (nonatomic, retain) NSMutableArray *locations;

@end
