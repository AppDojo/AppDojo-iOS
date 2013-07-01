//
//  API.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "API.h"

#define kAPIHost @"http://localhost:3000"
#define kAPIPath @"/"

@implementation API

@synthesize user;

-(API *)init {
    self = [super init];
    
    if (self != nil) {
        user = nil;
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

-(BOOL)isAuthorized {
    return [[user objectForKey:@"id"] intValue] > 0;
}

-(void)commandWithParams:(NSMutableDictionary *)params path:(NSString *)path onCompletion:(JSONResponseBlock)completionBlock {
    NSMutableURLRequest *apiRequest = [self multipartFormRequestWithMethod:@"POST" path:path parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        // TODO: Attach file if needed
    }];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Success
        completionBlock(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}
/**
 * Singleton Methods
 */
+(API *)sharedInstance {
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    return sharedInstance;
}
@end
