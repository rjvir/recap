//
//  BasicViewController.h
//  Recap
//
//  Created by Raj Vir on 5/13/13.
//  Copyright (c) 2013 Raj Vir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BasicViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
}
@property (nonatomic, strong) NSArray *cellArray;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *streamLoader;

@end