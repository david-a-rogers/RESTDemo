//
//  RDMapViewController.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDMapViewController.h"
#import "RDVenue.h"
#import "RDVenueMapPoint.h"

#define kMargin 200

@implementation RDMapViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Show our location as the blue dot
    self.mapView.showsUserLocation = true;
    
    // Set the visible area
    double bounds = [self determineBounds];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, bounds, bounds);
    [self.mapView setRegion:region animated:YES];

    // Drop the venu location pins
    for (int index = 0; index < self.venueCollection.count; ++index) {
        RDVenue* venue = self.venueCollection[index];
        [self placeMapPointFromVenu:venue];
    }

}

-(double)determineBounds {
    // Since the venues are in distance order, the farthest is the last.
    RDVenue* farthestVenu = self.venueCollection[self.venueCollection.count - 1];
    
    // The max distance is distance from the origin or center, so we double that as the
    // height & width of the map then add a margin of 200 meters so that no pin is right at the edge
    double distance = (farthestVenu.distanceInMeters.doubleValue * 2) + kMargin;
    return distance;
}

-(void)placeMapPointFromVenu: (RDVenue*) venu {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:venu.address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            RDVenueMapPoint* venueMapPoint = [[RDVenueMapPoint alloc] init];
            venueMapPoint.title = venu.name;
            venueMapPoint.subtitle = venu.category;
            venueMapPoint.coordinate = placemark.location.coordinate;
            [self.mapView addAnnotation:venueMapPoint];
        }
    }];

}

@end
