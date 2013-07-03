//
//  CurrentUser.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 7/2/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser

@synthesize authToken;

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:[dictionary objectForKey:@"user"]];
    
    if(self) {
        self.authToken = [dictionary valueForKey:@"auth_token"];
    }
    
    return self;
}
@end
