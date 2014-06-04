//
//  RDVenuCollection.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDVenue.h"


/*!
  Implements a venue collection.
 */
@interface RDVenueCollection : NSObject

// readfromstorage

- (NSUInteger)count;
- (RDVenue*)objectAtIndexedSubscript:(NSUInteger)idx;
- (BOOL)writeToStorage;
+ (RDVenueCollection*)readFromStorage;
+ (RDVenueCollection*)venueCollectionFromYelp: (NSArray*) yelpCollection;

@end
