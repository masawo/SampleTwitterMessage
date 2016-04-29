//
//  MessageViewController.m
//  SampleTwitterMessage
//
//  Created by Masao S on 2016/04/27.
//  Copyright © 2016年 masawo. All rights reserved.
//

#import "MessageViewController.h"
#import "Message.h"
#import "MessageCell.h"


@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate>

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
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:self.cellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    Message *message = self.messages[(NSUInteger) indexPath.row];
    if (message) {
        CGFloat maxWidth = CGRectGetWidth(self.view.frame);

        CGRect rect = [MessageCell rectForCell:message.body width:(CGFloat) (maxWidth - 60.0)];
        CGFloat height = [MessageCell textViewHeightForCell:message.body width:CGRectGetWidth(rect)];
        cell.textView.text = message.body;
        cell.textView.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFrame:CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect))];

        UIImage *bubbleImage;
        UIImageView *imageView;
        UIView *backgroundView;

        if (message.isMine) {
            [cell.textView setFrame:CGRectMake((CGFloat) (maxWidth - 40.0 - CGRectGetWidth(rect)), 0, CGRectGetWidth(rect), height)];
            bubbleImage = [[UIImage imageNamed:@"right_bubble.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(
                    (CGFloat) (maxWidth - 50.0 - CGRectGetWidth(rect)), 0,
                    CGRectGetWidth(rect) + 35, height + 10
            )];
            backgroundView = [[UIView alloc] initWithFrame:CGRectMake(
                    0, 0,
                    CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame)
            )];
        } else {
            [cell.textView setFrame:CGRectMake(20.0, 0, CGRectGetWidth(rect), height)];
            bubbleImage = [[UIImage imageNamed:@"left_bubble.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(
                    0, 0,
                    CGRectGetWidth(rect) + 35, height + 10
            )];
            backgroundView = [[UIView alloc] initWithFrame:CGRectMake(
                    0, 0,
                    CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame)
            )];
        }
        [imageView setImage:bubbleImage];
        [backgroundView addSubview:imageView];
        [cell setBackgroundView:backgroundView];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[(NSUInteger) indexPath.row];
    if (message) {
        CGFloat height = [MessageCell textViewHeightForCell:message.body width:260];
        return height + 20;
    }
    return 44;
}


#pragma mark - 投稿

- (IBAction)postButtonDidTapped:(id)sender {
    NSString *body = self.textField.text;
    if (body.length > 0) {
        Message *message = [Message initWithScreenName:self.myScreenName body:body];
        message.isMine = YES;
        [self post:message];
        self.textField.text = @"";

        Message *echoMessage = [Message initWithScreenName:@"echo" body:[NSString stringWithFormat:@"%@%@", message.body, message.body]];
        dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(waitTime, dispatch_get_main_queue(), ^(void){
            [self post:echoMessage];
        });
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
