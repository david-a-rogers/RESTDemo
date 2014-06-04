//
//  RDVenuCollection.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
  Implements a venue collection.
 */
@interface RDVenueCollection : NSObject

// writetostorage
// readfromstorage

+(RDVenueCollection*) venueCollectionFromYelp: (NSArray*) yelpCollection;

@end
