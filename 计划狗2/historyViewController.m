//
//  historyViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/20.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "historyViewController.h"

@interface historyViewController ()

@end

@implementation historyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.72 blue:0.40 alpha:1];
    

    uiview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        uiview.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕

    NSURL *url=[[NSURL alloc]initWithString:@"https://baike.baidu.com/calendar/"];
    NSURLRequest *request=[[NSURLRequest alloc ]initWithURL:url];
    [uiview loadRequest:request];
   [self.view addSubview:uiview];
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(click)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem=refresh;


    // Do any additional setup after loading the view.
}
                              

-(void)click{
    NSURL *url=[[NSURL alloc]initWithString:@"https://baike.baidu.com/calendar/"];
    NSURLRequest *request=[[NSURLRequest alloc ]initWithURL:url];
    [uiview loadRequest:request];
}

- (void)setSingleLineTitle:(NSString *)title{
    //自定义导航栏标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;//属性赋值
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
