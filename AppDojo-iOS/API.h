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

@interface API : AFHTTPClient

@property (nonatomic, strong) NSDictionary *user;

-(BOOL)isAuthorized;
-(void)commandWithParams:(NSMutableDictionary *)params path:(NSString *)path onCompletion:(JSONResponseBlock)completionBlock;
+(API *)sharedInstance;
@end
