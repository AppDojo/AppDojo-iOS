//
//  API.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "CurrentUser.h"

typedef void(^JSONResponseBlock)(NSDictionary *json);

@interface DojoApiClient : AFHTTPClient

@property (nonatomic, strong) CurrentUser *user;

-(BOOL)isAuthorized;

+(DojoApiClient *)sharedInstance;

@end
