//
// Created by Masao S on 2016/04/28.
// Copyright (c) 2016 masawo. All rights reserved.
//

#import "MessageCell.h"


@implementation MessageCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        [_textView sizeToFit];
        [self.contentView addSubview:_textView];
    }

    return self;
}

@end