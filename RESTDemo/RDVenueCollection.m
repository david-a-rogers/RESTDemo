//
//  RDVenuCollection.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDVenueCollection.h"
#import "RDVenue.h"


@interface RDVenueCollection ()
// a list of RDVenue objects
@property (strong, nonatomic) NSArray* venueList;
@end

@implementation RDVenueCollection


+(RDVenueCollection*) venueCollectionFromYelp: (NSArray*) yelpCollection {
    RDVenueCollection* newVenueCollection =  [[RDVenueCollection alloc] init];
    if (yelpCollection == nil) {
        return nil;
    }
    NSMutableArray* newVenueList = [[NSMutableArray alloc] initWithCapacity:yelpCollection.count];
    for (NSDictionary* yelpDictionary in yelpCollection) {
        RDVenue* newVenue = [RDVenue venueFromYelpDictionary:yelpDictionary];
        [newVenueList addObject: newVenue];
    }
    newVenueCollection.venueList = newVenueList;
    return newVenueCollection;
}

@end
