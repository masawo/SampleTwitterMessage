//
//  MessageViewController.h
//  SampleTwitterMessage
//
//  Created by Masao S on 2016/04/27.
//  Copyright © 2016年 masawo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController

@property (nonatomic) NSDictionary *userData;

+ (instancetype)messageViewController;

@end
