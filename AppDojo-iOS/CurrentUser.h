//
//  CurrentUser.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 7/2/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "User.h"

@interface CurrentUser : User

@property (nonatomic, strong) NSString *authToken;

-(id) initWithDictionary:(NSDictionary *) dictionary;

@end
