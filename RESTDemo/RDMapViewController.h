//
//  RDMapViewController.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RDVenueCollection.h"

/*!
  Display the positions of the venue collection on a map using MapKit
 */

@interface RDMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) RDVenueCollection* venueCollection;
@property (weak, nonatomic) CLLocation* currentLocation;
@end
