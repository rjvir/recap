//
//  PostViewController.m
//  Recap
//
//  Created by Raj Vir on 5/13/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import "PostViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PostViewController ()

@end

@implementation PostViewController

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
    
    self.nameLabel.text = self.name;
    NSString *imgUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", self.userid];
    [self.profileImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loading.png"]];

    self.placeholderText = @"Add Quote or Caption";
    self.textLabel.delegate = self;
    self.textLabel.text = self.placeholderText;
    self.textLabel.textColor = [UIColor lightGrayColor]; //optional
    [self.textLabel becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (IBAction)buttonPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postButtonPressed:(id)sender {
    NSLog(@"Pressed");
    // get image, get friend, get text, get current user
    /* self.postImage.image || */ 
    if(!([self.textLabel.text isEqualToString:self.placeholderText] || [self.textLabel.text isEqual: @""])){
        NSLog(@"valid");
        PFObject *post = [PFObject objectWithClassName:@"Post"];
        [post setObject:self.textLabel.text forKey:@"text"];
        PFUser *user = [PFUser currentUser];
        [post setObject:user forKey:@"poster"];
        [post setObject:self.userid forKey:@"subject"];
        [post setObject:self.nameLabel.text forKey:@"subjectName"];
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
//        [self performSegueWithIdentifier:@"loadStream" sender:self];
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
    [_postButton release];
    [_textLabel release];
    [super dealloc];
}
@end
