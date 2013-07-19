//
//  MasterViewController.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/18/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CreateMeetingViewController.h"
#import "LoginViewController.h"

#import "DojoApiClient.h"
#import "User.h"
#import "Meeting.h"

#define ApiClient [DojoApiClient sharedInstance]


@interface MasterViewController () {
    NSMutableArray *_meetings;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![ApiClient isAuthorized]) 
        [self performSegueWithIdentifier:@"login" sender:nil];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showNewMeetingForm:)];
    UIImage *background = [UIImage imageNamed:@"bg.jpg"];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    [self.backgroundImageView setImage:background];
    
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
        
}

- (void)viewDidAppear:(BOOL)animated
{
    [self fetchMeetingList];

}

- (void)refreshTableView:(UIRefreshControl *)sender {
    // Do the request
    [sender endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Dojo Api

- (void) fetchMeetingList
{
    [[DojoApiClient sharedInstance] getPath:@"api/v1/meetings" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(!_meetings) {
            _meetings = [[NSMutableArray alloc] init];
        }
        
        NSArray *meetings = [responseObject objectForKey:@"meetings"];
        
        NSLog(@"Meetings %@", meetings);
        
        for(id meetingRow in meetings) {
            Meeting *meeting = [[Meeting alloc] initWithDictionary:(NSDictionary *)meetingRow];
            [_meetings insertObject:meeting atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id JSON = [(AFJSONRequestOperation *) operation responseJSON];
        NSLog(@"JSON = %@\n\nError: %@", JSON,error);
    }];
}

- (void)showNewMeetingForm:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CreateMeetingViewController *meetingFormViewController = [storyboard instantiateViewControllerWithIdentifier:@"MeetingForm"];
    [self presentViewController:meetingFormViewController animated:YES completion:nil];
    
//    NSDictionary *params = @{@"meeting": @{@"name": @"Awesome Meeting", @"start_time":[NSDate date]}};
//    
//    [[DojoApiClient sharedInstance] postPath:@"api/v1/meetings" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (!_meetings) {
//            _meetings = [[NSMutableArray alloc] init];
//        }
//        NSDictionary *meeting = [NSDictionary dictionaryWithDictionary:[responseObject valueForKey:@"meeting"]];
//        [_objects insertObject:[meeting valueForKey:@"name"] atIndex:0];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        id JSON = [(AFJSONRequestOperation *) operation responseJSON];
//        NSLog(@"JSON: %@", JSON);
//    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _meetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    NSString *name = _objects[indexPath.row];
//    
//    cell.textLabel.text = name;
//    cell.detailTextLabel.text = @"Awesome";
    Meeting *meeting = _meetings[indexPath.row];
    
    cell.textLabel.text = [meeting name];
    cell.detailTextLabel.text = [[meeting startDate] description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_meetings removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Meeting *meeting = _meetings[indexPath.row];
        [[segue destinationViewController] setDetailItem:meeting];
    }
}

@end
