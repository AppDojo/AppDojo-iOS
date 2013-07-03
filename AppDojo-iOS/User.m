//
//  User.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize email, firstName, lastName;

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    
    if (self) {
        self.email      = [dictionary valueForKey:@"email"];
        self.firstName  = [dictionary valueForKey:@"first_name"];
        self.lastName   = [dictionary valueForKey:@"last_name"];
    }
    
    return self;
}

@end
