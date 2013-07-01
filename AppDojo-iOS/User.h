//
//  User.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSRails.h"

@interface User : NSRRemoteObject

@property (nonatomic, strong) NSString *email, *firstName, *lastName, *passwordDigest;

@end
