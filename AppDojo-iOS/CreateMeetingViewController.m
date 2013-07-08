//
//  CreateMeetingViewController.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 7/7/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "CreateMeetingViewController.h"

@interface CreateMeetingViewController ()

@end

@implementation CreateMeetingViewController

@synthesize startDatePicker;

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
    startDatePicker.backgroundColor = [UIColor whiteColor];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
