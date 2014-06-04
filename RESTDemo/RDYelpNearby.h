//
//  RDYelpNearby.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/2/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDNearbyDelegate.h"

/*!
  Given a current location, returns an RDVenueCollection
  
  - Allocate the RDYelpNearby object.
  - Set yourself as RDNearbyDelegate.
  - Submit the request with the location of interest.
  - The RDVenueCollection will be returned asynchronously throught the delegate protocol.
 */


@class CLLocation;

@interface RDYelpNearby : NSObject

@property (weak, nonatomic) id<RDNearbyDelegate> delegate;

-(void) submitLocation: (CLLocation*) currentLocation;

@end
