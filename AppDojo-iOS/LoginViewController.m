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

- (IBAction)resignAndLogin:(id)sender {
    UITextField *tf = (UITextField *)sender;
    
    if (tf.tag == 1) {
        [passwordTextField becomeFirstResponder];
    } else {
        [sender resignFirstResponder];
        
        [self loginWithEmail:emailTextField.text password:passwordTextField.text];
    }
}

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
    
    [self loginWithEmail:emailTextField.text password:passwordTextField.text];
    
}

- (void) loginWithEmail:(NSString *)email password:(NSString *)password {
 
    NSDictionary *params = @{@"email": email, @"password":password};
    
    [[DojoApiClient sharedInstance] postPath:@"api/v1/users/sign_in.json" parameters:params success:^(AFHTTPRequestOperation *operation, id response){
        CurrentUser *user = [[CurrentUser alloc] initWithDictionary:response];
        [[DojoApiClient sharedInstance] setUser:user];
        [[DojoApiClient sharedInstance] setDefaultHeader:@"X-AUTH-TOKEN" value:[[[DojoApiClient sharedInstance] user] authToken]];
        
        
        [[[UIAlertView alloc] initWithTitle:@"Logged In" message:[NSString stringWithFormat:@"Welcome %@", [[[DojoApiClient sharedInstance] user] firstName]] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Invalid email/password combination" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        [passwordTextField setText:@""];
    }];
}
@end


