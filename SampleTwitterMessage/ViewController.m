//
//  ViewController.m
//  SampleTwitterMessage
//
//  Created by Masao S on 2016/04/27.
//  Copyright © 2016年 masawo. All rights reserved.
//

#import "ViewController.h"
#import "MessageViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccount *twitterAccount;
@property (nonatomic) NSMutableArray *followers;
@property (nonatomic) NSString *cellIdentifier;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.followers = [NSMutableArray array];
    self.cellIdentifier = @"cell";

    [self authTwitter];
}

- (void)authTwitter {
    if (!self.accountStore) {
        self.accountStore = [ACAccountStore new];
    }
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error) {
                                                if (error) {
                                                    NSLog(@"error = %@", error);
                                                    return;
                                                }
                                                if (granted) {
                                                    NSLog(@"%s: granted", sel_getName(_cmd));
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
                                                    if (accounts.count > 0) {
                                                        // TODO 複数アカウントがある場合に選ばせる
                                                        ACAccount *account = [accounts lastObject];
                                                        NSLog(@"account = %@", account);
                                                        self.twitterAccount = account;
                                                        [self getTwitterFollowers:account];
                                                    } else {
                                                        [self showDialog:@"twitterアカウントが見つかりません。設定アプリでtwitterアカウントを設定してください"];
                                                    }
                                                } else {
                                                    [self showDialog:@"設定アプリでtwitterへのアクセスを許可してください"];
                                                }
                                            }];
}

- (void)getTwitterFollowers:(ACAccount *)account {
    // API document: https://dev.twitter.com/rest/reference/get/followers/list
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:@{
                                                       @"skip_status" : @"true",
                                                       @"include_user_entities" : @"false"
                                               }];
    request.account = account;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
        } else {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"result = %@", result);
            for (NSDictionary *dictionary in result[@"users"]) {
                [self.followers addObject:dictionary];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)showDialog:(NSString *)message {
    UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:nil
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    NSDictionary *userData = self.followers[(NSUInteger) indexPath.row];
    if (userData) {
        cell.textLabel.text = [NSString stringWithFormat:@"@%@", userData[@"screen_name"]];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageViewController *controller = [MessageViewController messageViewController];
    controller.userData = self.followers[(NSUInteger) indexPath.row];
    controller.myScreenName = self.twitterAccount.username;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
