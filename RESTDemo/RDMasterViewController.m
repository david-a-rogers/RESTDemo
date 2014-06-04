//
//  RDMasterViewController.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/1/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "RDMasterViewController.h"
#import "RDDetailViewController.h"
#import "RDYelpNearby.h"
#import "RDNearbyDelegate.h"
#import "RDVenueCell.h"

@interface RDMasterViewController () <CLLocationManagerDelegate> {
    NSMutableArray *_objects;
}
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) RDYelpNearby* nearby;
@property (strong, nonatomic) NSArray* venueArray;
@end

@implementation RDMasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Locations";
    [self initLocation];
    self.nearby = [[RDYelpNearby alloc] init];
    //TODO: nil check
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    [self.locationManager startUpdatingLocation];
    
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Location methods

- (void) initLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* currentLocation = [locations lastObject];
    NSLog(@"lat = %lf | long = %lf | lat acc = %lf | long acc = %lf",
          currentLocation.coordinate.latitude, currentLocation.coordinate.longitude,
          currentLocation.horizontalAccuracy, currentLocation.verticalAccuracy);
    [manager stopUpdatingLocation];
    self.nearby.delegate = self;
    [self.nearby submitLocation: currentLocation];

}

#pragma mark - Nearby methods

- (void)RDNearbyFinishedWithSuccess:(BOOL) success andVenues:(NSArray*) venueArray {
    if (success) {
        // Save nearby data
        self.venueArray = venueArray;
        [self.tableView reloadData];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venueArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RDVenueCell *cell = (RDVenueCell *)[tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
    
    // Configure Cell
    NSDictionary* venuDict = self.venueArray[indexPath.row];
    cell.name.text = venuDict[@"name"];
    // Distance is in meters.  Convert to miles.
    double distance = [((NSNumber*) venuDict[@"distance"]) doubleValue];
    distance *= 0.000621371;
    cell.distance.text = [NSString stringWithFormat: @"%0.2lf miles", distance];
    cell.type.text = venuDict[@"category"];
    if ([((NSNumber*) venuDict[@"is_closed"]) boolValue]) {
        cell.open.text = @"closed";
    } else {
        cell.open.text = @"open";
    }
    NSURL* imageURL = [NSURL URLWithString:venuDict[@"image_url"]];
    UIImage* image = [UIImage imageWithData: [NSData dataWithContentsOfURL: imageURL]];
    UIImage* sizedImage = [self resizeImage: image];
    cell.imageView.image = sizedImage;
    return cell;
}

-(UIImage*) resizeImage: (UIImage*) image {
    UIImage* newImage;
    if (image.size.width != 48 || image.size.height != 48)
	{
        CGSize itemSize = CGSizeMake(48, 48);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        newImage = image;
    }
    return newImage;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
