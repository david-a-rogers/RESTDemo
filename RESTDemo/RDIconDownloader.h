//
//  RDIconDownloader.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
  Supports deferred downloading of images from the internet.
 */

@class RDVenue;

@interface RDIconDownloader : NSObject

- (id) initWithVenue: (RDVenue*) venue andCompletionHandler: (void(^)(void))completionHandler;
- (void)startDownload;
- (void)cancelDownload;

@end
