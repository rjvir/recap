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

@interface PostViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate, FBFriendPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate, UITextViewDelegate>
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;
//@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (retain, nonatomic) IBOutlet UIImageView *postImage;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (retain, nonatomic) IBOutlet UITextView *captionLabel;
@property (retain, nonatomic) NSString *placeholderText;
@property (retain, nonatomic) NSArray *subject;
@end