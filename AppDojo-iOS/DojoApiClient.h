//
//  API.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

typedef void(^JSONResponseBlock)(NSDictionary *json);

@interface DojoApiClient : AFHTTPClient

@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *authToken;

-(BOOL)isAuthorized;
-(void)commandWithParams:(NSMutableDictionary *)params path:(NSString *)path onCompletion:(JSONResponseBlock)completionBlock;
+(DojoApiClient *)sharedInstance;
@end
