//
//  PostViewController.m
//  Recap
//
//  Created by Raj Vir on 5/13/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

@synthesize friendPickerController = _friendPickerController;
@synthesize searchBar = _searchBar;
@synthesize searchText = _searchText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.placeholderText = @"Add Quote or Caption";
    self.captionLabel.delegate = self;
    self.captionLabel.text = self.placeholderText;
    self.captionLabel.textColor = [UIColor lightGrayColor]; //optional
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (IBAction)buttonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PickCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];        
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Select Friend";
//            if(!self.profileImage){
//                cell.imageView.image = self.profileImage;                
//            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc]
                                       initWithNibName:nil bundle:nil];
        self.friendPickerController.allowsMultipleSelection = NO;
        self.friendPickerController.title = @"Select Friend";
    }
    
    self.friendPickerController.delegate = self;
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    [self presentViewController:self.friendPickerController animated:true completion:^{
        [self addSearchBarToFriendPickerView];
    }];
}

- (void) handlePickerDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self handlePickerDone];
    //self.
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        NSLog(@"Friend selected: %@", user.name); //user.id
        NSString *str =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", user.id];
        UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
        self.profileImage.image = img;
        self.name = user.name;
        self.nameLabel.text = self.name;
        self.userid = user.id;
    }
    
    [self handlePickerDone];
}

- (void)addSearchBarToFriendPickerView
{
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        [self.searchBar becomeFirstResponder];
        [self.friendPickerController.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.friendPickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.friendPickerController.tableView.frame = newFrame;
    }
}

- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self handleSearch:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchString {
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchText = nil;
    [searchBar resignFirstResponder];
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
    return YES;
}

//- (IBAction)cameraButtonPressed:(id)sender {
//    NSLog(@"BP!");
//    if ([UIImagePickerController isSourceTypeAvailable:
//         UIImagePickerControllerSourceTypeCamera] == YES){
//        // Create image picker controller
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        
//        // Set source to the camera
//        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
//        imagePicker.allowsEditing = YES;
////        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showCamera:)];
////        imagePicker.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:button];
//        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Library" style:UIBarButtonItemStylePlain target:self action:@selector(showLibrary:)];
//        imagePicker.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:button];
//        imagePicker.navigationItem.title = @"Take Photo";
//        imagePicker.navigationController.navigationBarHidden = NO; //        // Delegate is self
//        imagePicker.delegate = self;
//        
//        // Show image picker
//        [self presentViewController:imagePicker animated:YES completion:nil];
////        [self presentModalViewController:imagePicker animated:YES];
//    } else {
//        NSLog(@"yo!");
//    }
//}
//
//
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    NSLog(@"picked!");
////    // Access the uncropped image from info dictionary
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    self.postImage.image = image;
////
////    // Dismiss controller
//    [picker dismissViewControllerAnimated:YES completion:nil];
////
////    // Resize image
////    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
////    [image drawInRect: CGRectMake(0, 0, 640, 960)];
////    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    
////    // Upload image
////    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
////    [self uploadImage:imageData];
//
//}

- (IBAction)postButtonPressed:(id)sender {
    NSLog(@"Pressed");
    // get image, get friend, get text, get current user
    /* self.postImage.image || */ 
    if(!([self.captionLabel.text isEqualToString:self.placeholderText] || [self.captionLabel.text isEqual: @""])){
        NSLog(@"valid");
        PFObject *post = [PFObject objectWithClassName:@"Post"];
        //PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation(self.postImage.image, 0.05f)];
        //if(!([self.captionLabel.text isEqualToString:self.placeholderText] || [self.captionLabel.text isEqual: @""])){
        //}
        [post setObject:self.captionLabel.text forKey:@"text"];
        PFUser *user = [PFUser currentUser];
        [post setObject:user forKey:@"poster"];
        //[post setObject:imageFile forKey:@"image"];
        [post setObject:self.userid forKey:@"subject"];
        [post setObject:self.name forKey:@"subjectName"];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong"
                                                                message:@"Please try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong"
                                                        message:@"Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        NSLog(@"invalid");
    }

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"test!");
    if ([textView.text isEqualToString:self.placeholderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeholderText;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)dealloc {
    [_nameLabel release];
    [_profileImage release];
    [_postImage release];
    [_postButton release];
    [_captionLabel release];
    [super dealloc];
}
@end
