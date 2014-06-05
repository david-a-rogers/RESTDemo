//
//  RDVenue.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
  Represents a single venue's information.
 */

@interface RDVenue : NSObject


@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSNumber* distanceInMeters;
@property (strong, nonatomic) NSNumber* isClosed;
@property (strong, nonatomic) NSURL* imageUrl;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString* address;

// Only available at runtime
@property (strong, nonatomic) UIImage* image;

-(NSNumber*)distanceInMiles;
-(NSDictionary*) toVenueDictionary;
+(RDVenue*) venueFromYelpDictionary: (NSDictionary*) yelpDictionary;
+(RDVenue*) venueFromVenueDictionary: (NSDictionary*) venueDictionary;

@end




