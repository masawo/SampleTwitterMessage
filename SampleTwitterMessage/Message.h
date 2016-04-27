//
// Created by Masao S on 2016/04/27.
// Copyright (c) 2016 masawo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Message : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *postedAt;
@property (nonatomic) BOOL isMine;

+ (id)initWithScreenName:(NSString *)screenName body:(NSString *)body;
@end