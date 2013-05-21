//
//  BasicViewController.m
//  Recap
//
//  Created by Raj Vir on 5/13/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import "BasicViewController.h"
#import "StreamViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface BasicViewController ()
@property (nonatomic, retain) StreamViewCell *cell;
@end

@implementation BasicViewController

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

    self.cell = [StreamViewCell alloc];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [_streamLoader startAnimating];
    [self refresh:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self refresh:nil];    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    
    PFQuery *postsAboutFriends = [PFQuery queryWithClassName:@"Post"];
    [postsAboutFriends whereKey:@"subject" containedIn:[[PFUser currentUser] objectForKey:@"facebookFriends"]];
    
    NSLog(@"%@", [[PFUser currentUser] objectForKey:@"facebookId"]);
    
    PFQuery *postsAboutMe = [PFQuery queryWithClassName:@"Post"];
    [postsAboutFriends whereKey:@"subject" equalTo:[[PFUser currentUser] objectForKey:@"facebookId"]];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[postsAboutFriends, postsAboutMe]];
    [query orderByDescending:@"createdAt"];
    
    [query includeKey:@"poster"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if(refreshControl){
            [refreshControl endRefreshing];
        } else {
            [_streamLoader stopAnimating];
        }
        if (!error) {
            self.cellArray = objects;
            [self.tableView reloadData];
            NSLog(@"Successfully retrieved %d scores.", objects.count);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 2;
    return [self.cellArray count];
}

//- (StreamViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    StreamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[StreamViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.text.frame = CGRectMake(10,
//                                     360,
//                                     [cell.text.text sizeWithFont:cell.text.font].width,
//                                     [cell.text.text sizeWithFont:cell.text.font].height);
//    }
//
//    PFObject *object = [self.cellArray objectAtIndex:indexPath.row];
//    PFUser *poster = (PFUser *)[object objectForKey:@"poster"];
//    PFObject *posterData = [poster objectForKey:@"profile"];
//    NSString *posterName = [posterData objectForKey:@"name"];
//    //cell.subject.text = [object objectForKey:@"subjectName"];
//    cell.poster.text = [NSString stringWithFormat:@"via %@", posterName];
//    cell.subject.text = [object objectForKey:@"subjectName"];
//    cell.text.text = [object objectForKey:@"text"];
//    NSString *str =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [object objectForKey:@"subject"]];
//    [cell.subjectImage setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"loading.png"] options:SDWebImageRefreshCached];
//    return cell;
//}

- (StreamViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    StreamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PFObject *object = [self.cellArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[StreamViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.text.text = [object objectForKey:@"text"];
    [cell.text sizeToFit];
    PFUser *poster = (PFUser *)[object objectForKey:@"poster"];
    PFObject *posterData = [poster objectForKey:@"profile"];
    NSString *posterName = [posterData objectForKey:@"name"];
    cell.subject.text = [object objectForKey:@"subjectName"];
    cell.poster.text = [NSString stringWithFormat:@"via %@", posterName];

    NSString *str =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", [object objectForKey:@"subject"]];
    [cell.subjectImage setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"loading.png"] options:SDWebImageRefreshCached];
    CALayer * l = [cell.subjectImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(StreamViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    PFObject *object = [self.cellArray objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.cellArray objectAtIndex:indexPath.row];

    CGSize maximumLabelSize = CGSizeMake(232,232); //Or whatever size you need to be the max
    CGSize expectedLabelSize = [[object objectForKey:@"text"] sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:maximumLabelSize lineBreakMode: NSLineBreakByWordWrapping];
    return (46 + expectedLabelSize.height);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc {
    [_tableView release];
    [_streamLoader release];
    [_subject release];
    [super dealloc];
}
@end
