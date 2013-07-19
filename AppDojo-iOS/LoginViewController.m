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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animatedTextField:textField up:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animatedTextField:textField up:NO];
}

- (void) animatedTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 150;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
        
    [UIView animateWithDuration:movementDuration animations:^{
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    }];
//    [UIView beginAnimations:@"anim" context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
}


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
    
    [emailTextField setDelegate:self];
    [passwordTextField setDelegate:self];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapped.numberOfTapsRequired = 1;
    tapped.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:tapped];
}

- (void)tapped:(UITapGestureRecognizer *)sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginTapped:(id)sender {
    if(emailTextField.text.length < 4 || passwordTextField.text.length < 4) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid credentials" message:@"Email and password required" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
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
        
        
//        [[[UIAlertView alloc] initWithTitle:@"Logged In" message:[NSString stringWithFormat:@"Welcome %@", [[[DojoApiClient sharedInstance] user] firstName]] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *JSON = [(AFJSONRequestOperation *) operation responseJSON];
        [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:[JSON valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        [passwordTextField setText:@""];
        
    }];
}
@end


