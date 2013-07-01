//
//  DetailViewController.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/18/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
