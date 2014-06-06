//
//  RDMasterViewController.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/1/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "RDNearbyDelegate.h"

@interface RDMasterViewController : UITableViewController <RDNearbyDelegate, CLLocationManagerDelegate>

@end
