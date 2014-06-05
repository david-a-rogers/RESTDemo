//
//  RDVenueMapPoint.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/5/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RDVenueMapPoint : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
