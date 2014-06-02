//
//  RDNearby.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/2/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface RDNearby : NSObject
-(void) submitLocation: (CLLocation*) currentLocation;

@end
