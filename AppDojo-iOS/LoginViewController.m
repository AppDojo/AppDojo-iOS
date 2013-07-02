//
//  LoginViewController.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "LoginViewController.h"

#import "DojoApiClient.h"

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
    
    // TODO more stuff...
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"email": emailTextField.text, @"password":passwordTextField.text}];
    
    [[DojoApiClient sharedInstance] commandWithParams:params path:@"/login" onCompletion:^(NSDictionary *json) {
        if ([json objectForKey:@"error"] == nil && [json objectForKey:@"user"] != nil) {
            NSDictionary *user = [NSDictionary dictionaryWithDictionary:[json objectForKey:@"user"]];
            [[DojoApiClient sharedInstance] setUser:user];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            [[[UIAlertView alloc] initWithTitle:@"Logged In" message:[NSString stringWithFormat:@"Welcome %@", [user objectForKey:@"first_name"]] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        } else {
            NSLog(@"%@", [json objectForKey:@"error"]);
        }
    }];
    
}
@end
