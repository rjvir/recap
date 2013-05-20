//
//  friendPickerViewController.h
//  Recap
//
//  Created by Raj Vir on 5/20/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface friendPickerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sortedFriends;
@property (nonatomic, strong) NSMutableArray *friendArray;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@end
