//
//  RDVenuCollection.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDVenueCollection.h"


@interface RDVenueCollection ()
// a list of RDVenue objects
@property (strong, nonatomic) NSArray* venueList;
@end

@implementation RDVenueCollection

- (NSUInteger)count {
    return self.venueList.count;
}

- (RDVenue*)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.venueList[idx];
}

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
    
    // venues must be sorted by distance
    
    [newVenueList sortUsingComparator:^NSComparisonResult(RDVenue* first, RDVenue* second) {
        return [first.distanceInMiles compare: second.distanceInMiles];
    }];

    newVenueCollection.venueList = newVenueList;
    return newVenueCollection;
}

@end
