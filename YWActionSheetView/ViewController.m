//
//  ViewController.m
//  YWActionSheetView
//
//  Created by 张洋威 on 15/9/15.
//  Copyright (c) 2015年 YangWei Zhang. All rights reserved.
//

#import "ViewController.h"
#import "YWActionSheet.h"
@interface ViewController ()<YWActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)action
{
    YWActionSheet *action = [[YWActionSheet alloc] initWithTitle:@"拟定等jsdfajkljsfjsdkfjksjfkjsdfjkjfkjajfjfkjsfkjksjfkjskjafjsfjjfkjskjfkjfljsjfkjskjfkjkfjkjfkjkfjksjfkjkskfjlajfkjsfkljsdkfj多家设计" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:@"你好", nil];
    action.delegate = self;
    [action show];
}

- (void)actionSheet:(YWActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex: %ld", (long)buttonIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
