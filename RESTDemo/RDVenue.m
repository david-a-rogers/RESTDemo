//
//  RDVenue.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDVenue.h"

#define kYelpNameKey @"name"
#define kYelpDistanceKey @"distance"
#define kYelpClosedKey @"is_closed"
#define kYelpImageUrlKey @"image_url"
#define kYelpCategoriesKey @"categories"

#define kVenueNameKey @"name"
#define kVenueDistanceKey @"distance"
#define kVenueClosedKey @"closed"
#define kVenueImageUrlKey @"imageurl"
#define kVenueCategoryKey @"category"

#define kUnknownVenuCategory @"Unknown venue type"


@implementation RDVenue

+(RDVenue*) venueFromYelpDictionary: (NSDictionary*) yelpDictionary {
    RDVenue* newVenue = [[RDVenue alloc] init];
    if (yelpDictionary == nil) {
        return nil;
    }
    
    newVenue.name = yelpDictionary[kYelpNameKey];
    
    NSNumber* distanceInMeters = yelpDictionary[kYelpDistanceKey];
    double distanceInMiles = distanceInMeters.doubleValue * 0.000621371;
    newVenue.distanceInMiles = @(distanceInMiles);
    
    newVenue.isClosed = yelpDictionary[kYelpClosedKey];
    
    newVenue.imageUrl = [NSURL URLWithString: yelpDictionary[kYelpImageUrlKey]];

    // I cannot verify that there will always be an entry
    // for categories, so protecting the result.
    newVenue.category = kUnknownVenuCategory;
    NSArray* categoryPairList = yelpDictionary[kYelpCategoriesKey];
    if (categoryPairList != nil) {
        NSArray* categoryPair = categoryPairList[0];
        if (categoryPair != nil) {
            newVenue.category = categoryPair[0];
        }
    }
    
    return newVenue;
}

-(NSDictionary*) toVenueDictionary {
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    dictionary[kVenueNameKey] = self.name;
    dictionary[kVenueDistanceKey] = self.distanceInMiles;
    dictionary[kVenueClosedKey] = self.isClosed;
    dictionary[kVenueImageUrlKey] = self.imageUrl.absoluteString;
    dictionary[kVenueCategoryKey] = self.category;
    return dictionary;
}

+(RDVenue*) venueFromVenueDictionary: (NSDictionary*) venueDictionary {
    RDVenue* newVenue = [[RDVenue alloc] init];
    if (venueDictionary == nil) {
        return nil;
    }
    
    newVenue.name = venueDictionary[kVenueNameKey];
    newVenue.distanceInMiles = venueDictionary[kVenueDistanceKey];
    newVenue.isClosed = venueDictionary[kVenueClosedKey];
    newVenue.imageUrl = [NSURL URLWithString: venueDictionary[kVenueImageUrlKey]];
    newVenue.category = venueDictionary[kVenueCategoryKey];

    return newVenue;
}

@end
