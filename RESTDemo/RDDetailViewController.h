//
//  RDDetailViewController.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/1/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVenue.h"

@interface RDDetailViewController : UIViewController
@property (weak, nonatomic) RDVenue* venue;

// views
@property (strong, nonatomic) UILabel*  nameLabel;
@property (strong, nonatomic) UILabel*  addressLabel1;
@property (strong, nonatomic) UILabel*  addressLabel2;
@property (strong, nonatomic) UILabel*  addressLabel3;
@property (strong, nonatomic) UILabel*  phoneLabel;
@property (strong, nonatomic) UIImageView* imageView;

@end
