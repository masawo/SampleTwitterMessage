//
//  MessageViewController.m
//  SampleTwitterMessage
//
//  Created by Masao S on 2016/04/27.
//  Copyright © 2016年 masawo. All rights reserved.
//

#import "MessageViewController.h"
#import "Message.h"


@interface MessageViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *inputAccessoryView;

@property (nonatomic) NSMutableArray *messages;
@property (nonatomic) NSString *cellIdentifier;

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

    self.cellIdentifier = @"messageCell";

    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    self.messages = [NSMutableArray array];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO セルのデザイン
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    Message *message = self.messages[(NSUInteger) indexPath.row];
    if (message) {
        UILabel *label = [cell viewWithTag:1];
        if (label) {
            label.text = message.body;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - 投稿

- (IBAction)postButtonDidTapped:(id)sender {
    NSString *body = self.textField.text;
    if (body.length > 0) {
        Message *message = [Message initWithScreenName:self.myScreenName body:body];
        message.isMine = YES;
        [self post:message];
        // TODO 1秒後にオウム返し
        self.textField.text = @"";
    }
}

- (void)post:(Message *)message {
    NSLog(@"message = %@", message);
    [self.messages addObject:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
