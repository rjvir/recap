//
//  LoginViewController.m
//  Recap
//
//  Created by Raj Vir on 5/7/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import "LoginViewController.h"
#import "BasicViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    NSLog(@"View did load");
	// Do any additional setup after loading the view.
}

- (IBAction)LoginWithFacebook:(UIButton *)sender {
    NSLog(@"Pressed Login With Facebook");
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    [testObject setObject:@"bar" forKey:@"foo"];
//    [testObject save];

    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    [_loginLoader startAnimating];
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            [_loginLoader stopAnimating];
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else {
            NSLog(@"Data saved");
            //NSString *facebookId = [user objectForKey:@"id"];
            //NSLog(@"%@", facebookId);
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSString *fbid = [result objectForKey:@"id"];
                    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        
                        if (!error) {
                            NSArray *data = [result objectForKey:@"data"];
                            NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:data.count];
                            for (NSDictionary *friendData in data) {
                                [facebookIds addObject:[friendData objectForKey:@"id"]];
                            }
                            
                            [[PFUser currentUser] setObject:facebookIds forKey:@"facebookFriends"];
                            [[PFUser currentUser] setObject:fbid forKey:@"facebookId"];
                            
                            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [_loginLoader stopAnimating];
                                // We're in!
                                NSLog(@"test");
                                [self performSegueWithIdentifier:@"loadStream" sender:self];
                            }];
                        } else {
                            NSLog(@"Error");
                        }
                    }];
                }
            }];
                        
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                // USER LOGGED IN!
                NSLog(@"logged in!");
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loginLoader release];
    [super dealloc];
}
@end
