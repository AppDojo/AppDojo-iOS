//
//  Meeting.h
//  AppDojo-iOS
//
//  Created by Leonardo Correa on 7/6/13.
//  Copyright (c) 2013 Leonardo Correa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate   *startDate;

- (Meeting *) initWithDictionary:(NSDictionary *)dictionary;

@end
