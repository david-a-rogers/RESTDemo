//
//  RDNearbyDelegate.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/3/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDVenueCollection.h"

@protocol RDNearbyDelegate <NSObject>

- (void)RDNearbyFinishedWithSuccess:(BOOL) success andVenues:(RDVenueCollection*) venueCollection;

@end
