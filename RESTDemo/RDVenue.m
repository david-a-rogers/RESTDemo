//
//  RDVenue.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDVenue.h"

@implementation RDVenue

+(RDVenue*) venueFromYelpDictionary: (NSDictionary*) yelpDictionary {
    RDVenue* newVenue = [[RDVenue alloc] init];
    if (yelpDictionary == nil) {
        return nil;
    }
    
    newVenue.name = yelpDictionary[@"name"];
    
    NSNumber* distanceInMeters = yelpDictionary[@"distance"];
    double distanceInMiles = distanceInMeters.doubleValue * 0.000621371;
    newVenue.distanceInMiles = @(distanceInMiles);
    
    newVenue.isClosed = yelpDictionary[@"is_closed"];
    
    newVenue.imageUrl = [NSURL URLWithString: yelpDictionary[@"image_url"]];

    // I cannot verify that there will always be an entry
    // for categories, so protecting the result.
    newVenue.category = @"unknown venue type";
    NSArray* categoryPairList = yelpDictionary[@"categories"];
    if (categoryPairList != nil) {
        NSArray* categoryPair = categoryPairList[0];
        if (categoryPair != nil) {
            newVenue.category = categoryPair[0];
        }
    }
    
    return newVenue;
}

@end
