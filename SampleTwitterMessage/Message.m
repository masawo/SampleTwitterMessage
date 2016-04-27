//
// Created by Masao S on 2016/04/27.
// Copyright (c) 2016 masawo. All rights reserved.
//

#import "Message.h"


@implementation Message

+ (id)initWithScreenName:(NSString *)screenName body:(NSString *)body {
    Message *message = [[Message alloc] init];
    message.screenName = screenName;
    message.body = body;
    message.postedAt = [NSDate date];
    return message;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.screenName = [coder decodeObjectForKey:@"self.screenName"];
        self.body = [coder decodeObjectForKey:@"self.body"];
        self.postedAt = [coder decodeObjectForKey:@"self.postedAt"];
        self.isMine = [coder decodeBoolForKey:@"self.isMine"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.screenName forKey:@"self.screenName"];
    [coder encodeObject:self.body forKey:@"self.body"];
    [coder encodeObject:self.postedAt forKey:@"self.postedAt"];
    [coder encodeBool:self.isMine forKey:@"self.isMine"];
}

- (id)copyWithZone:(NSZone *)zone {
    Message *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.screenName = self.screenName;
        copy.body = self.body;
        copy.postedAt = self.postedAt;
        copy.isMine = self.isMine;
    }

    return copy;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToMessage:other];
}

- (BOOL)isEqualToMessage:(Message *)message {
    if (self == message)
        return YES;
    if (message == nil)
        return NO;
    if (self.screenName != message.screenName && ![self.screenName isEqualToString:message.screenName])
        return NO;
    if (self.body != message.body && ![self.body isEqualToString:message.body])
        return NO;
    if (self.postedAt != message.postedAt && ![self.postedAt isEqualToDate:message.postedAt])
        return NO;
    if (self.isMine != message.isMine)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.screenName hash];
    hash = hash * 31u + [self.body hash];
    hash = hash * 31u + [self.postedAt hash];
    hash = hash * 31u + self.isMine;
    return hash;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.screenName=%@", self.screenName];
    [description appendFormat:@", self.body=%@", self.body];
    [description appendFormat:@", self.postedAt=%@", self.postedAt];
    [description appendFormat:@", self.isMine=%d", self.isMine];
    [description appendString:@">"];
    return description;
}

@end