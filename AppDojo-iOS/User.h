//
//  User.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 6/30/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import <Foundation/Foundation.h>

// {
//    "user" =     {
//      "created_at" = "2013-07-02T18:21:18.739Z";
//      email = "leo@cloud.com";
//      "first_name" = Leo;
//      id = 1;
//      "last_name" = Correa;
//      "updated_at" = "2013-07-03T00:38:32.246Z";
//    }
//  };

@interface User : NSObject

@property (nonatomic, strong) NSString *email, *firstName, *lastName;

-(id) initWithDictionary:(NSDictionary *)dictionary;

@end
