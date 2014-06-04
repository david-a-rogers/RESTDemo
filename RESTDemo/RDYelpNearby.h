//
//  RDNearby.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/2/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDNearbyDelegate.h"

@class CLLocation;

@interface RDYelpNearby : NSObject

@property (weak, nonatomic) id<RDNearbyDelegate> delegate;

-(void) submitLocation: (CLLocation*) currentLocation;

@end
