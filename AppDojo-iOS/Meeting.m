//
//  Meeting.m
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 7/6/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

- (Meeting *) initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
        
    if (self) {
        self.name      = [dictionary valueForKey:@"name"];
        self.startDate = [dictionary valueForKey:@"start_time"];
    }
    
    return self;
}

@end
