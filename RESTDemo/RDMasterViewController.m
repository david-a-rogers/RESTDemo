//
//  RDMasterViewController.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/1/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import "RDMasterViewController.h"
#import "RDDetailViewController.h"
#import "RDYelpNearby.h"
#import "RDNearbyDelegate.h"
#import "RDVenueCell.h"
#import "RDIconDownloader.h"
#import "RDMapViewController.h"

@interface RDMasterViewController () <CLLocationManagerDelegate> {
    BOOL seekingLocation;
    BOOL waitingForVenueAnswer;
}
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) RDYelpNearby* nearby;
@property (strong, nonatomic) RDVenueCollection* venueCollection;
//Dictionary of RDIconDownloaders keyed by indexPath
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (strong, nonatomic) CLLocation* currentLocation;
@property (strong, nonatomic) UIButton* roseButton;

@end

@implementation RDMasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    waitingForVenueAnswer = NO;
    [self setupNavBar];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];

    [self initLocation];
    self.nearby = [[RDYelpNearby alloc] init];

    // Start the ball rolling
    [self requestLocation];

}

- (void) setupNavBar {
    self.title = @"Locations";

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Add compass button
    UIImage *roseImage = [UIImage imageNamed:@"compassRose"];
    self.roseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *grayRoseImage = [UIImage imageNamed:@"compassRose"];
    [self.roseButton setImage:roseImage forState:UIControlStateNormal];
    [self.roseButton setImage:grayRoseImage forState:UIControlStateDisabled];
    [self.roseButton sizeToFit];
    //roseButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
    // Initialize the UIBarButtonItem
    UIBarButtonItem* roseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.roseButton];
    
    // Set the Target and Action for aButton
    [self.roseButton addTarget:self action:@selector(loadMapController:) forControlEvents:UIControlEventTouchUpInside];
    
    // Then you can add the aBarButtonItem to the UIToolbar
    self.navigationItem.leftBarButtonItem = roseBarButtonItem;

}

- (void)loadFromPersistentData {
    self.venueCollection = [RDVenueCollection readFromStorage];
    self.currentLocation = [self.venueCollection venueSubmitLocation];
    
    if (self.venueCollection == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"REST Demo"
                                                        message: @"No saved venues to show"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"REST Demo"
                                                        message: @"No internet connection. Using saved data"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    [self requestLocation];
}

#pragma mark - Location methods

- (void)requestLocation {
    if ([self isConnectionAvailable]) {
        seekingLocation = YES;
        [self.locationManager startUpdatingLocation];
    } else {
        [self loadFromPersistentData];
    }
}

- (void) initLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    // Location manager doesn't always stop immediately
    if (seekingLocation) {
        seekingLocation = NO;
        self.currentLocation = [locations lastObject];
        //    NSLog(@"lat = %lf | long = %lf | lat acc = %lf | long acc = %lf",
        //          currentLocation.coordinate.latitude, currentLocation.coordinate.longitude,
        //          currentLocation.horizontalAccuracy, currentLocation.verticalAccuracy);
        self.nearby.delegate = self;
        if (!waitingForVenueAnswer) {
            waitingForVenueAnswer = YES;
            [self.nearby submitLocation: self.currentLocation];
        } else {
            NSLog(@"Stopped from executing!");
        }
    }
}

#pragma mark - Nearby methods

- (void)RDNearbyFinishedWithSuccess:(BOOL) success andVenues:(RDVenueCollection*) venueCollection {
    waitingForVenueAnswer = NO;
    if (success) {
        //Persist venu data
        BOOL success = [venueCollection writeToStorage];
        if (!success) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"REST Demo"
                                                            message: @"Failed to save venue information. Storage may be full."
                                                           delegate: nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        // terminate all pending download connections
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
        [self.imageDownloadsInProgress removeAllObjects];
        
        // Use venue data
        self.venueCollection = venueCollection;
        [self.tableView reloadData];
    }
}

#pragma mark - Map methods
- (void)loadMapController:(id)sender {
    if (![self isConnectionAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"REST Demo"
                                                        message: @"No internet connection. Can't do maps."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    [self performSegueWithIdentifier:@"mapSegue" sender:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venueCollection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RDVenueCell *cell = (RDVenueCell *)[tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
    
    // Configure Cell
    RDVenue* venue = self.venueCollection[indexPath.row];
    
    cell.name.text = venue.name;
    cell.distance.text = [NSString stringWithFormat: @"%0.2lf miles", venue.distanceInMiles.doubleValue];
    cell.category.text = venue.category;
    if (venue.isClosed.boolValue) {
        cell.open.text = @"closed";
        cell.open.textColor = [UIColor lightTextColor];
    } else {
        cell.open.text = @"open";
        cell.open.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
    }
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!venue.image)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownload:venue forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
    }
    else
    {
        cell.imageView.image = venue.image;
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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

#pragma mark - Deferred icon helpers

- (void)startIconDownload:(RDVenue *)venue forIndexPath:(NSIndexPath *)indexPath
{
    RDIconDownloader* iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) {
        iconDownloader = [[RDIconDownloader alloc] initWithVenue: venue andCompletionHandler: ^{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = venue.image;
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        self.imageDownloadsInProgress[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

- (void)loadImagesForOnscreenRows
{
    if (self.venueCollection.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            RDVenue* venue = self.venueCollection[indexPath.row];
            
            if (!venue.image)
            {
                [self startIconDownload:venue forIndexPath:indexPath];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        RDDetailViewController* detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailViewController.venue = self.venueCollection[indexPath.row];
    } else if ([[segue identifier] isEqualToString:@"mapSegue"]) {
        RDMapViewController* mapViewController = [segue destinationViewController];
        mapViewController.currentLocation = self.currentLocation;
        mapViewController.venueCollection = self.venueCollection;
    }
}

#pragma mark - Internet Access

- (BOOL) isConnectionAvailable
{
	SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"dipinkrishna.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    } else {
		return TRUE;
	}
}
@end
