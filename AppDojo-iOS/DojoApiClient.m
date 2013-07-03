//
//  API.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "DojoApiClient.h"

#define DojoAPIBaseURLString @"http://localhost:3000/"
#define DojoAPIToken @"some_token"


@implementation DojoApiClient

@synthesize user;

-(BOOL)isAuthorized {
    return user != nil && [user authToken] != nil;
}

-(id) initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self setDefaultHeader:@"x-api-token" value:DojoAPIToken];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
    }
    
    return self;
}

/**
 * Singleton Methods
 */
+(DojoApiClient *)sharedInstance {
    static DojoApiClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[DojoApiClient alloc] initWithBaseURL:[NSURL URLWithString:DojoAPIBaseURLString]];
    });
    
    return __sharedInstance;
}
@end


