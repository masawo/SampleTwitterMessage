//
//  ViewController.m
//  SampleTwitterMessage
//
//  Created by Masao S on 2016/04/27.
//  Copyright © 2016年 masawo. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ACAccountStore *accountStore;
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
                                                if (granted) {
                                                    NSLog(@"%s: granted", sel_getName(_cmd));
                                                    NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
                                                    if (accounts.count > 0) {
                                                        // TODO 複数アカウントがある場合に選ばせる
                                                        ACAccount *account = [accounts lastObject];
                                                        NSLog(@"account = %@", account);
                                                        [self getTwitterFollowers:account];
                                                    }
                                                } else {
                                                    NSLog(@"%s: NOT granted", sel_getName(_cmd));
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

}


@end
