//
//  RDVenuCollection.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDVenueCollection.h"

#define kPlistName @"venue.plist"
#define kLocationArchiveName @"locationArchive"

@interface RDVenueCollection ()
// a list of RDVenue objects
@property (strong, nonatomic) NSArray* venueList;
@property (strong, nonatomic) CLLocation* submitLocation;
@end

@implementation RDVenueCollection

- (NSUInteger)count {
    return self.venueList.count;
}

- (RDVenue*)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.venueList[idx];
}

+ (RDVenueCollection*)venueCollectionFromYelp: (NSArray*) yelpCollection forLocation:(CLLocation *)location {
    RDVenueCollection* newVenueCollection =  [[RDVenueCollection alloc] init];
    if (yelpCollection == nil) {
        return nil;
    }
    newVenueCollection.submitLocation = location;
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

+ (NSString*) venuePlistPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kPlistName];
    return plistPath;
}

+ (NSString*) locationArchivePath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = paths[0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:kLocationArchiveName];
    return archivePath;
}

- (BOOL)writeToStorage {
    NSString* plistPath = [RDVenueCollection venuePlistPath];
    
    NSArray* arrayToSave = [self toArrayOfDictionaries];
    BOOL success = [arrayToSave writeToFile:plistPath atomically:YES];
    if (!success) {
        NSLog(@"%s - Failed to persist venues", __PRETTY_FUNCTION__);
    } else {
        // archive the location for the venues
        success = [NSKeyedArchiver archiveRootObject:self.submitLocation
                                              toFile:[RDVenueCollection locationArchivePath]];
        if (!success) {
            NSLog(@"%s - Failed to persist location", __PRETTY_FUNCTION__);
        }
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
    NSString* plistPath = [RDVenueCollection venuePlistPath];
    NSArray* venueDictionaryArray = [NSArray arrayWithContentsOfFile: plistPath];
    if (venueDictionaryArray == nil) {
        return nil;
    }
    
    NSMutableArray* venueList = [[NSMutableArray alloc] initWithCapacity: venueDictionaryArray.count];
    for (NSDictionary* venueDictionary in venueDictionaryArray) {
        RDVenue* newVenue = [RDVenue venueFromVenueDictionary: venueDictionary];
        [venueList addObject: newVenue];
    }
    newVenueCollection.venueList = venueList;
    
    newVenueCollection.submitLocation = [NSKeyedUnarchiver unarchiveObjectWithFile: [RDVenueCollection locationArchivePath]];
    if (newVenueCollection.submitLocation == nil) {
        return nil;
    }
    return newVenueCollection;
}

- (CLLocation*) venueSubmitLocation {
    return self.submitLocation;
}



@end
