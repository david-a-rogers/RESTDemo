//
//  RDYelpNearby.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/2/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDYelpNearby.h"
#import "RDVenueCollection.h"
#import "OAuthConsumer.h"
#import <CoreLocation/CoreLocation.h>



#define CONSUMER_KEY @"CLZVEP5pyzrjyvUt5qJwvA"
#define CONSUMER_SECRET @"DT8oehpqXoFgZyB0ZeGSyWWf7sg"
#define TOKEN @"FFS7fmkx_wk6Pf9LP5QzaK5OAghtMTFN"
#define TOKEN_SECRET @"NdefZosauWj5YfOniFwo57bJ_Dg"


@interface RDYelpNearby ()
@property (strong, nonatomic) OAConsumer *AuthConsumer;
@property (strong, nonatomic) OAToken *AuthToken;
@property (strong, nonatomic) id<OASignatureProviding, NSObject> AuthProvider;
@property (strong, nonatomic) NSMutableData* connectionData;
@end



@implementation RDYelpNearby
-(id) init {
	self = [super init];
	if (self != nil) {
        _AuthConsumer = [[OAConsumer alloc] initWithKey: CONSUMER_KEY secret: CONSUMER_SECRET];
        _AuthToken = [[OAToken alloc] initWithKey:TOKEN secret:TOKEN_SECRET];
        _AuthProvider = [[OAHMAC_SHA1SignatureProvider alloc] init];
        if (_AuthConsumer == nil || _AuthToken == nil || _AuthProvider == nil) {
            return nil;
        }
	}
	return self;
}

-(void) submitLocation: (CLLocation*) currentLocation {
    NSString* requestString = [NSString stringWithFormat: @"http://api.yelp.com/v2/search?ll=%lf,%lf", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    NSURL *URL = [NSURL URLWithString:requestString];
    OAMutableURLRequest* request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:self.AuthConsumer
                                                                      token:self.AuthToken
                                                                      realm:nil
                                                          signatureProvider:self.AuthProvider];
    [request prepare];
    self.connectionData = [[NSMutableData alloc] init];
    NSURLConnection* __unused connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

#pragma mark - Connection Responses

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@, %@", [error localizedDescription], [error localizedFailureReason]);
    self.connectionData = nil;
    if (self.delegate != nil) {
        [self.delegate RDNearbyFinishedWithSuccess:NO andVenues:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Nothing needs to be done yet.
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.connectionData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData: self.connectionData options:NSJSONReadingMutableContainers error: &e];
    NSArray* businesses = jsonDict[@"businesses"];
    
    RDVenueCollection* newCollection = [RDVenueCollection venueCollectionFromYelp: businesses];
    
    self.connectionData = nil;
    
    if (self.delegate != nil) {
        [self.delegate RDNearbyFinishedWithSuccess:YES andVenues: newCollection];
    }
    
}


@end
