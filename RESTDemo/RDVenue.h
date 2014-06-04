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
@property (strong, nonatomic) NSNumber* distanceMiles;
@property (strong, nonatomic) NSNumber* isClosed;
@property (strong, nonatomic) NSURL* imageUrl;
@property (strong, nonatomic) NSString* category;
//TODO: address

+(RDVenue*) venueFromYelpDictionary: (NSDictionary*) yelpDictionary;

@end



