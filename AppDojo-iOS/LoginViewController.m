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

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationTextField;
@property (weak, nonatomic) IBOutlet UILabel *signUpLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)signUp:(id)sender;

@end

@implementation LoginViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.emailTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapped.numberOfTapsRequired = 1;
    tapped.numberOfTouchesRequired = 1;
    tapped.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapped];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(avoidKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(avoidKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.nameTextField.alpha = 0.0;
    self.passwordConfirmationTextField.alpha = 0.0;
    
    [super viewDidAppear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)moveViewForKeyboardUp:(BOOL)up
{
    const int movementDistance = 150;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
        
    [UIView animateWithDuration:movementDuration animations:^{
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    }];
}

- (void)avoidKeyboard:(NSNotification *)note
{
    if ([note.name isEqualToString:UIKeyboardWillShowNotification]) {
        [self moveViewForKeyboardUp:YES];
    } else {
        [self moveViewForKeyboardUp:NO];
    }
}

- (IBAction)resignAndLogin:(id)sender {
    UITextField *tf = (UITextField *)sender;
    
    if (tf.tag == 1) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [sender resignFirstResponder];
        
        [self loginWithEmail:self.emailTextField.text password:self.passwordTextField.text];
    }
}


- (void)tapped:(UITapGestureRecognizer *)sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.passwordConfirmationTextField resignFirstResponder];
}


- (IBAction)btnLoginTapped:(id)sender
{
    if ([[[sender titleLabel] text] isEqualToString:@"Login"]) {
        if(self.emailTextField.text.length < 4 || self.passwordTextField.text.length < 4) {
            [[[UIAlertView alloc] initWithTitle:@"Invalid credentials" message:@"Email and password required" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [self loginWithEmail:self.emailTextField.text password:self.passwordTextField.text];
    } else {
        [self signUpWithName:self.nameTextField.text
                       email:self.emailTextField.text
                    password:self.passwordTextField.text andPasswordConfirmation:self.passwordConfirmationTextField.text];
    }
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password {
 
    NSDictionary *params = @{@"email": email, @"password":password};
    
    [[DojoApiClient sharedInstance] postPath:@"api/v1/users/sign_in.json" parameters:params success:^(AFHTTPRequestOperation *operation, id response){
        CurrentUser *user = [[CurrentUser alloc] initWithDictionary:response];
        [[DojoApiClient sharedInstance] setUser:user];
        [[DojoApiClient sharedInstance] setDefaultHeader:@"X-AUTH-TOKEN" value:[[[DojoApiClient sharedInstance] user] authToken]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *JSON = [(AFJSONRequestOperation *) operation responseJSON];
        [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:[JSON valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        [self.passwordTextField setText:@""];
        
    }];
}

- (void)signUpWithName:(NSString *)name email:(NSString *)email password:(NSString *)password andPasswordConfirmation:(NSString *)passwordConfirmation
{
    NSArray *nameList = [name componentsSeparatedByString:@" "];
    NSString *firstName = [nameList objectAtIndex:0];
   
    NSString *lastName = [[nameList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, nameList.count - 1)]] componentsJoinedByString:@" "];
    
    
    NSDictionary *params = @{@"user": @{@"first_name":firstName, @"last_name":lastName, @"email":email, @"password":password, @"password_confirmation":passwordConfirmation}};
    
    [[DojoApiClient sharedInstance] postPath:@"api/v1/users.json" parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        // TODO: Refactor with the login one as well
        CurrentUser *user = [[CurrentUser alloc] initWithDictionary:response];
        [[DojoApiClient sharedInstance] setUser:user];
        [[DojoApiClient sharedInstance] setDefaultHeader:@"X-AUTH-TOKEN" value:[[[DojoApiClient sharedInstance] user] authToken]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *JSON = [(AFJSONRequestOperation *) operation responseJSON];
        NSString *message = @"";
        // TODO: Failure message could be better...
        for (NSString *key in [JSON[@"errors"] allKeys]) {
            NSString *firstMessage = [NSString stringWithFormat:@"%@ %@\n", [key capitalizedString], [JSON[@"errors"][key] firstObject]];
            message = [message stringByAppendingString:firstMessage];
        }
        [[[UIAlertView alloc] initWithTitle:@"Registration Failed" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }];
}


- (IBAction)signUp:(id)sender
{

    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"Sign Up"]) {
        self.nameTextField.frame = CGRectMake(0, self.nameTextField.frame.origin.y, 0, self.nameTextField.frame.size.height);
        self.passwordConfirmationTextField.frame = CGRectMake(0, self.passwordConfirmationTextField.frame.origin.y, 0, self.passwordConfirmationTextField.frame.size.height);
        
        [UIView animateWithDuration:0.2 animations:^{
            self.nameTextField.frame = CGRectMake(20, self.nameTextField.frame.origin.y, 280, self.nameTextField.frame.size.height);
            self.passwordConfirmationTextField.frame = CGRectMake(20, self.passwordConfirmationTextField.frame.origin.y, 280, self.passwordConfirmationTextField.frame.size.height);
            self.nameTextField.alpha = 1.0;
            self.passwordConfirmationTextField.alpha = 1.0;
            self.signUpLabel.alpha = 0.0f;
            [self.signUpButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [self.loginButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.nameTextField.frame = CGRectMake(self.view.frame.size.width, self.nameTextField.frame.origin.y, self.nameTextField.frame.size.width, self.nameTextField.frame.size.height);
            self.passwordConfirmationTextField.frame = CGRectMake(self.view.frame.size.width, self.passwordConfirmationTextField.frame.origin.y, self.passwordConfirmationTextField.frame.size.width, self.passwordConfirmationTextField.frame.size.height);
            self.nameTextField.alpha = 0.0;
            self.passwordConfirmationTextField.alpha = 0.0;
            self.signUpLabel.alpha = 1.0;
            [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
            [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        }];
    }
    
}
@end


