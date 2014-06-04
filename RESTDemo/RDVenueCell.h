//
//  RDVenueCell.h
//  RESTDemo
//
//  Created by David A. Rogers on 6/3/14.
//  Copyright (c) 2014 David Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDVenueCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView* iconView;
@property (weak, nonatomic) IBOutlet UILabel* name;
@property (weak, nonatomic) IBOutlet UILabel* distance;
@property (weak, nonatomic) IBOutlet UILabel* type;
@property (weak, nonatomic) IBOutlet UILabel* open;



@end
