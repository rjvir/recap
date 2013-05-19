//
//  StreamViewCell.m
//  Recap
//
//  Created by Raj Vir on 5/11/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import "StreamViewCell.h"

@implementation StreamViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_poster release];
    [_poster release];
    [_subject release];
    [_text release];
    [_subjectImage release];
    [_image release];
    [super dealloc];
}
@end
