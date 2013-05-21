//
//  PostViewController.h
//  Recap
//
//  Created by Raj Vir on 5/13/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface PostViewController : UIViewController<UINavigationControllerDelegate, UITextViewDelegate>
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (retain, nonatomic) IBOutlet UITextView *textLabel;
@property (retain, nonatomic) NSString *placeholderText;
@end