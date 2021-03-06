//
//  MasterViewController.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/18/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "User.h"

@interface MasterViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (void)showNewMeetingForm:(id)sender;
- (void)fetchMeetingList;
//- (void)userList;
- (void)refreshTableView:(UIRefreshControl *)sender;
@end
