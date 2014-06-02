//
//  RDNearby.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/2/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDNearby.h"
#import "OAuthConsumer.h"
#import <CoreLocation/CoreLocation.h>


#define CONSUMER_KEY @"CLZVEP5pyzrjyvUt5qJwvA"
#define CONSUMER_SECRET @"DT8oehpqXoFgZyB0ZeGSyWWf7sg"
#define TOKEN @"FFS7fmkx_wk6Pf9LP5QzaK5OAghtMTFN"
#define TOKEN_SECRET @"NdefZosauWj5YfOniFwo57bJ_Dg"


@interface RDNearby ()
@property (strong, nonatomic) OAConsumer *AuthConsumer;
@property (strong, nonatomic) OAToken *AuthToken;
@property (strong, nonatomic) id<OASignatureProviding, NSObject> AuthProvider;
@property (strong, nonatomic) NSMutableData* connectionData;
@end



@implementation RDNearby
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
    //NSURL *URL = [NSURL URLWithString:@"http://api.yelp.com/v2/search?term=restaurants&location=new%20york"];
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
    //[self notify:kGHUnitWaitStatusFailure forSelector:@selector(test)];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //[_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.connectionData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData: self.connectionData options:NSJSONReadingMutableContainers error: &e];
    NSArray* businesses = jsonDict[@"businesses"];
    
    
    // We only need a subset of all the stuff Yelp provides and we're going to have to store
    // what we use for offline purposes. So lets trim it down now.
    
    NSMutableArray* trimmedBusinesses = [[NSMutableArray alloc] initWithCapacity: businesses.count];
    for (NSDictionary* entry in businesses) {
        NSMutableDictionary* newEntry = [[NSMutableDictionary alloc] initWithCapacity:10];
        newEntry[@"name"] = entry[@"name"];
        newEntry[@"distance"] = entry[@"distance"];
        newEntry[@"is_closed"] = entry[@"is_closed"];
        newEntry[@"location"] = entry[@"location"];
        newEntry[@"image_url"] = entry[@"image_url"];
        [trimmedBusinesses addObject: newEntry];
    }
    
    
    [trimmedBusinesses sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDictionary* first = (NSDictionary*)a;
        NSDictionary* second = (NSDictionary*)b;
        return [first[@"distance"] compare: second[@"distance"]];
    }];
    
    int __unused x = 42;
    

}


@end
