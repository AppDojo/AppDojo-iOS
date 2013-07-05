//
//  MasterViewController.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/18/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "DojoApiClient.h"
#import "User.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    UIImage *background = [UIImage imageNamed:@"bg.jpg"];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    [self.backgroundImageView setImage:background];
    
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    [self userList];
    

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

- (void)insertNewObject:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://appdojo-api.herokuapp.com/"];
     
    NSDictionary *params = @{@"user":@{@"email":@"leo@cloud.com", @"first_name": @"leo", @"last_name": @"correa", @"password": @"awesome_password", @"password_confirmation": @"awesome_password"}};
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    [httpClient postPath:@"/users" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!_objects) {
            _objects = [[NSMutableArray alloc] init];
        }
        
        NSDictionary *user = [NSDictionary dictionaryWithDictionary:[responseObject valueForKey:@"user"]];
        [_objects insertObject:[user valueForKey:@"first_name"] atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([operation isKindOfClass:[AFJSONRequestOperation class]]) {
            id JSON = [(AFJSONRequestOperation *) operation responseJSON];
            NSLog(@"JSON: %@", JSON);
        }
        
    }]; 
}

-(void)userList
{

    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    [[DojoApiClient sharedInstance] getPath:@"api/v1/users" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *users = [responseObject objectForKey:@"users"];
        for(id userRow in users) {
            
            User *user = [[User alloc] initWithDictionary:(NSDictionary *)userRow];
            [_objects insertObject:user atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *JSON = [(AFJSONRequestOperation *) operation responseJSON];
        NSLog(@"JSON: %@", JSON);

    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    User *user = _objects[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [user firstName], [user lastName]];
    cell.detailTextLabel.text = [user email];
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
        [_objects removeObjectAtIndex:indexPath.row];
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
        NSDictionary *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
