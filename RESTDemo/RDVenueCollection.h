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

// writetostorage
// readfromstorage

- (NSUInteger)count;
- (RDVenue*)objectAtIndexedSubscript:(NSUInteger)idx;

+(RDVenueCollection*) venueCollectionFromYelp: (NSArray*) yelpCollection;

@end
