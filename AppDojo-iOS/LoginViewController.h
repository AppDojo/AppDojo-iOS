//
//  LoginViewController.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>


- (IBAction)btnLoginTapped:(id)sender;
- (void) loginWithEmail:(NSString *)email password:(NSString *)password;

@end
