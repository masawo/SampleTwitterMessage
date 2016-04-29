//
// Created by Masao S on 2016/04/28.
// Copyright (c) 2016 masawo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic) UITextView *textView;

+ (CGRect)rectForCell:(NSString *)string width:(CGFloat)width;
+ (CGFloat)textViewHeightForCell:(NSString *)string width:(CGFloat)width;

@end