//
//  RDVenuCollection.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "RDVenue.h"


/*!
  Implements a venue collection.
 */
@interface RDVenueCollection : NSObject

// readfromstorage

- (NSUInteger)count;
- (RDVenue*)objectAtIndexedSubscript:(NSUInteger)idx;
- (BOOL)writeToStorage;
- (CLLocation*) venueSubmitLocation;
+ (RDVenueCollection*)readFromStorage;
+ (RDVenueCollection*)venueCollectionFromYelp: (NSArray*) yelpCollection forLocation:(CLLocation*) location;

@end
