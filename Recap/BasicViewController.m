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
//    self.cellArray = [[NSMutableArray alloc] initWithObjects:@"one", @"two", @"three", nil];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    self.cell = [[StreamViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    [_streamLoader startAnimating];
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

- (StreamViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    StreamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StreamViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.text.frame = CGRectMake(10,
                                     360,
                                     [cell.text.text sizeWithFont:cell.text.font].width,
                                     [cell.text.text sizeWithFont:cell.text.font].height);
    }

//    NSString *text = [self.cellArray objectAtIndex:indexPath.row];
    PFObject *object = [self.cellArray objectAtIndex:indexPath.row];
    PFUser *poster = (PFUser *)[object objectForKey:@"poster"];
    PFObject *posterData = [poster objectForKey:@"profile"];
    NSString *posterName = [posterData objectForKey:@"name"];
    //cell.subject.text = [object objectForKey:@"subjectName"];
    cell.poster.text = [NSString stringWithFormat:@"via %@", posterName];
    cell.subject.text = [object objectForKey:@"subjectName"];
    cell.text.text = [object objectForKey:@"text"];
    NSString *str =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [object objectForKey:@"subject"]];
    [cell.subjectImage setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:nil] options:SDWebImageRefreshCached];
    //PFFile *subImg = [];
//    cell.subjectImage.image = subjectImg;
    if([object objectForKey:@"image"]){
        PFFile *file = [object objectForKey:@"image"];
        cell.image.file = file;
        [cell.image loadInBackground];
        [cell.image setFrame:CGRectMake(10.0, 50.0, 200.0, 200.0)];
    } else {
        cell.image = nil;
        //[cell.image removeFromSuperview];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(StreamViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    PFObject *object = [self.cellArray objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.cellArray objectAtIndex:indexPath.row];
    //NSString *text = [object objectForKey:@"text"];
    //    sv.text =  @"When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.";
    //    sv.lineBreakMode = UILineBreakModeWordWrap;
    //    sv.numberOfLines = 0;
    //    [sv sizeToFit];
    int height = 50;
    if([object objectForKey:@"image"]){
        height = height + 300;
    }
    if([object objectForKey:@"text"]){
        height = height + 100;
    }
//    StreamViewCell *cell = self.cell;
//    CGFloat h = 24 + [@"text" sizeWithFont:cell.text.font constrainedToSize: (CGSize){cell.text.frame.size.width, CGFLOAT_MAX} lineBreakMode:cell.text.lineBreakMode].height;
//    return MAX(h, 44.0f);
//    height = height + h;
    return height;
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
    [super dealloc];
}
@end
