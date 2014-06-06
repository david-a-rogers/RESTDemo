//
//  RDYelpNearbyTestCase.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/5/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import "RDYelpNearby.h"
#import "RDNearbyDelegate.h"

@interface RDYelpNearbyTestCase : XCTestCase <RDNearbyDelegate> {
    BOOL waitingForCompletion;
    BOOL nearbySuccess;
}
@property (strong, nonatomic) NSString* errorMessage;

@end

@implementation RDYelpNearbyTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample01
{
    CLLocation* testLocation = [[CLLocation alloc] initWithLatitude:41.897169 longitude:-87.643553];
    RDYelpNearby* nearby = [[RDYelpNearby alloc] init];
    nearby.delegate = self;
    waitingForCompletion = YES;
    [nearby submitLocation:testLocation];
    while(waitingForCompletion) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    if (!nearbySuccess) {
        XCTFail(@"%@", self.errorMessage);
    }

}

- (void)RDNearbyFinishedWithSuccess:(BOOL) success andVenues:(RDVenueCollection*) venueCollection {
    if (!success) {
        self.errorMessage = @"RDYelpNearby failed to return venues";
        nearbySuccess = NO;
        waitingForCompletion = NO;
        return;
    }
    
    if (venueCollection == nil || venueCollection.count == 0) {
        self.errorMessage = @"venuCollection was nil or empty";
        nearbySuccess = NO;
        waitingForCompletion = NO;
        return;

    }
    
    nearbySuccess = YES;
    waitingForCompletion = NO;
}

@end
