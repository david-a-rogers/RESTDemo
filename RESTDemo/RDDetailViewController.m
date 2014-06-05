//
//  RDDetailViewController.m
//  RESTDemo
//
//  Created by David A. Rogers on 6/1/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import "RDDetailViewController.h"
#import "UIView+SimpleLayout.h"

@interface RDDetailViewController ()
- (void)configureView;
@end

@implementation RDDetailViewController


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Create the controls and set their standard size
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.width = kAppIconSize;
    self.imageView.height = kAppIconSize;
    [self.view addSubview: self.imageView];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.nameLabel setFont:[UIFont boldSystemFontOfSize:24]];
    self.nameLabel.text = @" ";
    [self.nameLabel sizeToFit];
    [self.view addSubview: self.nameLabel];
    
    self.addressLabel1 = [[UILabel alloc] init];
    self.addressLabel1.text = @" ";
    [self.addressLabel1 sizeToFit];
    [self.view addSubview: self.addressLabel1];
    
    self.addressLabel2 = [[UILabel alloc] init];
    self.addressLabel2.text = @" ";
    [self.addressLabel2 sizeToFit];
    [self.view addSubview: self.addressLabel2];
    
    self.addressLabel3 = [[UILabel alloc] init];
    self.addressLabel3.text = @" ";
    [self.addressLabel3 sizeToFit];
    [self.view addSubview: self.addressLabel3];
    
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.text = @" ";
    [self.phoneLabel sizeToFit];
    [self.view addSubview: self.phoneLabel];
}



#pragma mark - Managing the detail item

-(void)setVenue:(RDVenue *)newVenue {
    if (_venue != newVenue) {
        _venue = newVenue;
        
        // Update the view.
        [self configureView];
    }
 
}

- (void)configureView
{
    // Update the user interface for the detail item.
    self.imageView.image = self.venue.image;
    [self.imageView sizeToFit];

    self.nameLabel.text = self.venue.name;
    NSUInteger addressCount = self.venue.address.count;
    if (addressCount > 0) {
        self.addressLabel1.text = self.venue.address[0];
    }
    if (addressCount > 1) {
        self.addressLabel2.text = self.venue.address[1];
    }
    if (addressCount > 2) {
        self.addressLabel3.text = self.venue.address[2];
    }
    self.phoneLabel.text = self.venue.phone;
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    [self configureView];
}

#pragma mark - Layout

/*!
  Position controls easily using SimpleLayout
 */
- (void)viewWillLayoutSubviews {
    
    if (self.view.height > self.view.width) {
        // Portrait (more or less)
        
        // Position the icon about 1/4 down from the top and about 10% to the right
        self.imageView.left = self.view.boundsWidth * .10;
        self.imageView.bottom = self.view.boundsHeight * .25;
        
        // Position the name
        self.nameLabel.left = self.imageView.left;
        self.nameLabel.width = self.view.boundsWidth - self.nameLabel.left - kSLEdgeStandardSpace;
        self.nameLabel.top = self.imageView.bottom + kSLEdgeStandardSpace;
        
        // Position address 1
        
        self.addressLabel1.left = self.nameLabel.left;
        self.addressLabel1.top = self.nameLabel.bottom + kSLInterStandardSpace;
        self.addressLabel1.width = self.nameLabel.width;
        
        // Position address 2
        
        self.addressLabel2.left = self.nameLabel.left;
        self.addressLabel2.top = self.addressLabel1.bottom + kSLInterStandardSpace;
        self.addressLabel2.width = self.nameLabel.width;
  
        // Position address 3
        
        self.addressLabel3.left = self.nameLabel.left;
        self.addressLabel3.top = self.addressLabel2.bottom + kSLInterStandardSpace;
        self.addressLabel3.width = self.nameLabel.width;

        // Position phone
        
        self.phoneLabel.left = self.nameLabel.left;
        self.phoneLabel.top = self.addressLabel3.bottom + kSLInterStandardSpace;
        self.phoneLabel.width = self.nameLabel.width;
       
        
    } else {
        
        // Position the icon about 30% down from the top and about 20% to the right
        self.imageView.left = self.view.boundsWidth * .20;
        self.imageView.bottom = self.view.boundsHeight * .30;
        
        // Position the name
        self.nameLabel.left = self.imageView.right + kSLEdgeStandardSpace;
        self.nameLabel.width = self.view.boundsWidth - self.nameLabel.left - kSLEdgeStandardSpace;
        self.nameLabel.bottom = self.imageView.bottom;
        
        // Position address 1
        
        self.addressLabel1.left = self.nameLabel.left;
        self.addressLabel1.top = self.nameLabel.bottom + kSLInterStandardSpace;
        self.addressLabel1.width = self.nameLabel.width;
        
        // Position address 2
        
        self.addressLabel2.left = self.nameLabel.left;
        self.addressLabel2.top = self.addressLabel1.bottom + kSLInterStandardSpace;
        self.addressLabel2.width = self.nameLabel.width;
        
        // Position address 3
        
        self.addressLabel3.left = self.nameLabel.left;
        self.addressLabel3.top = self.addressLabel2.bottom + kSLInterStandardSpace;
        self.addressLabel3.width = self.nameLabel.width;
        
        // Position phone
        
        self.phoneLabel.left = self.nameLabel.left;
        self.phoneLabel.top = self.addressLabel3.bottom + kSLInterStandardSpace;
        self.phoneLabel.width = self.nameLabel.width;
   
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
