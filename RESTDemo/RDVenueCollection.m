//
//  RDVenuCollection.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDVenueCollection.h"

#define kPlistName @"venue.plist"

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

+ (RDVenueCollection*)venueCollectionFromYelp: (NSArray*) yelpCollection {
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

+ (NSString*) plistPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kPlistName];
    return plistPath;
}

- (BOOL)writeToStorage {
    NSString* plistPath = [RDVenueCollection plistPath];
    
    NSArray* arrayToSave = [self toArrayOfDictionaries];
    BOOL success = [arrayToSave writeToFile:plistPath atomically:YES];
    if (!success) {
        NSLog(@"%s - Failed to write to storage", __PRETTY_FUNCTION__);
    }
    return success;
}


- (NSArray*)toArrayOfDictionaries {
    NSMutableArray* dictionaryArray = [[NSMutableArray alloc] initWithCapacity: self.venueList.count];
    for (RDVenue* venue in self.venueList) {
        NSDictionary* dictionary = [venue toVenueDictionary];
        [dictionaryArray addObject: dictionary];
    }
    return dictionaryArray;
}

+ (RDVenueCollection*)readFromStorage {
    RDVenueCollection* newVenueCollection =  [[RDVenueCollection alloc] init];
    NSString* plistPath = [RDVenueCollection plistPath];
    NSArray* venueDictionaryArray = [NSArray arrayWithContentsOfFile: plistPath];
    NSMutableArray* venueList = [[NSMutableArray alloc] initWithCapacity: venueDictionaryArray.count];
    for (NSDictionary* venueDictionary in venueDictionaryArray) {
        RDVenue* newVenue = [RDVenue venueFromVenueDictionary: venueDictionary];
        [venueList addObject: newVenue];
    }
    newVenueCollection.venueList = venueList;
    return newVenueCollection;
}





@end
