//
//  friendPickerViewController.m
//  Recap
//
//  Created by Raj Vir on 5/20/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import "friendPickerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PostViewController.h"

@interface friendPickerViewController ()

@end

@implementation friendPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Friend picker did lowd!");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *facebookFriends = [defaults objectForKey:@"facebookFriends"];
    NSArray *sortedFriends;
    sortedFriends = [facebookFriends sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [a objectAtIndex:1];
        NSString *second = [b objectAtIndex:1];
        return [first compare:second];
    }];
    self.sortedFriends = [sortedFriends mutableCopy];
    self.friendArray = [sortedFriends mutableCopy];
    //self.friendArray = sortedFriends;
    //self.navigationItem.title = @"Pick Friend";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friendArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendPickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableArray *friend = [self.friendArray objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [friend objectAtIndex:1];
    NSString *imgUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [friend objectAtIndex:0]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loading.png"]];
    //[cell.imageView
//    NSString *str =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [object objectForKey:@"subject"]];
//    [cell.subjectImage setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:nil] options:SDWebImageRefreshCached];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.friendArray removeAllObjects]; // remove all data that belongs to previous search
    if([searchText isEqualToString:@""]){ //searchText==nil){
        self.friendArray = [self.sortedFriends mutableCopy];
        [self.tableView reloadData];
        return;
    }
    NSInteger counter = 0;
    for(NSMutableArray *name in self.sortedFriends){
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        //NSLog(@"%@", [name objectAtIndex:1]);
        
        NSRange r = [[[name objectAtIndex:1] lowercaseString] rangeOfString:[searchText lowercaseString]];
        if(r.location != NSNotFound)
        {
            if(0 || r.location== 0)//that is we are checking only the start of the names.
            {
                [self.friendArray addObject:name];
            }
        }
        
        counter++;
        [pool release];
        
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view delegate

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
    [self.searchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"loadForm" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"loadForm"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *object = self.friendArray[indexPath.row];
        PostViewController *postView = (PostViewController *)segue.destinationViewController;
        postView.name = [object objectAtIndex:1];
        postView.userid = [object objectAtIndex:0];
    }
}

- (void)dealloc {
    [_tableView release];
    [_searchBar release];
    [super dealloc];
}
@end
