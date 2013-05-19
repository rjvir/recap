//
//  StreamViewCell.h
//  Recap
//
//  Created by Raj Vir on 5/11/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StreamViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *poster;
@property (retain, nonatomic) IBOutlet UILabel *subject;
@property (retain, nonatomic) IBOutlet UILabel *text;
@property (retain, nonatomic) IBOutlet UIImageView *subjectImage;
@property (retain, nonatomic) IBOutlet PFImageView *image;

@end
