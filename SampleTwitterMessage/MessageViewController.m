//
//  MessageViewController.m
//  SampleTwitterMessage
//
//  Created by Masao S on 2016/04/27.
//  Copyright © 2016年 masawo. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *inputAccessoryView;

@end

@implementation MessageViewController {
    BOOL _showInputView;
}

+ (instancetype)messageViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageViewController" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *title = [NSString stringWithFormat:@"@%@", self.userData[@"screen_name"]];
    if (title) {
        self.title = title;
    }

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _showInputView = YES;
    [self reloadInputViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _showInputView = NO;
    [self reloadInputViews];
}

- (UIView *)inputAccessoryView {
    if (_showInputView) {
        return _inputAccessoryView;
    }
    return nil;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - 投稿

- (IBAction)postButtonDidTapped:(id)sender {
}

@end
