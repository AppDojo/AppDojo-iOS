//
//  LoginViewController.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "LoginViewController.h"

#import "DojoApiClient.h"
#import "CurrentUser.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize emailTextField;
@synthesize passwordTextField;

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
	
    [emailTextField becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginTapped:(id)sender {
    if(emailTextField.text.length < 4 || passwordTextField.text.length < 4) {
        NSLog(@"Invalid stuff");
        return;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"email": emailTextField.text, @"password":passwordTextField.text}];
    
    [[DojoApiClient sharedInstance] postPath:@"api/v1/users/sign_in.json" parameters:params success:^(AFHTTPRequestOperation *operation, id response){
        CurrentUser *user = [[CurrentUser alloc] initWithDictionary:response];
        [[DojoApiClient sharedInstance] setUser:user];
        
        NSLog(@"AUTH TOKEN %@", [[[DojoApiClient sharedInstance] user] authToken]);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        
        [[[UIAlertView alloc] initWithTitle:@"Logged In" message:[NSString stringWithFormat:@"Welcome %@", [[[DojoApiClient sharedInstance] user] firstName]] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO Handle Failures...
    }];    
}
@end
