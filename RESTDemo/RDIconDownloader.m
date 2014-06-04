//
//  RDIconDownloader.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/4/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDIconDownloader.h"
#import "RDVenue.h"

#define kAppIconSize 48


@interface RDIconDownloader ()
@property (nonatomic, strong) NSMutableData *imageData;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property (strong, nonatomic) RDVenue* venue;
@property (nonatomic, copy) void (^completionHandler)(void);
@end

@implementation RDIconDownloader

-(id) initWithVenue: (RDVenue*) venue andCompletionHandler: (void(^)(void))completionHandler {
	self = [super init];
	if (self != nil) {
        if (venue == nil || completionHandler == nil) {
            return nil;
        }
        self.completionHandler = completionHandler;
        self.venue = venue;
	}
	return self;
}

- (void)startDownload
{
    self.imageData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: self.venue.imageUrl];
    
    // Begin connection to get image data
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.imageData = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the imageData property to allow later attempts
    self.imageData = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.imageData];
    
    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
	{
        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.venue.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.venue.image = image;
    }
    
    self.imageData = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}



@end
