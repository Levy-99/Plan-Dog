//
//  feedbackViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/23.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "feedbackViewController.h"

@interface feedbackViewController ()<UITextViewDelegate>

@property (strong,nonatomic) UITextView *text;
@property (nonatomic) NSInteger passer;
@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *save=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(save1)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.72 blue:0.40 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=save;
    
    _text =[[UITextView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    _text.delegate = self;
    _text.font = [UIFont systemFontOfSize:16];//字体大小
    [_text becomeFirstResponder];//获得焦点
    _text.returnKeyType = UIReturnKeyNext;
    _text.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:_text];
    self.flag = 1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonText
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)save1
{
    if ([_text.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"写点什么吧" message:nil buttonText:@"知道了"];
        return;
    }
         //[self dismissViewControllerAnimated:YES completion:nil];
    self.flag = 1;
    _passer = self.flag;
        [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%ld",(long)self.flag);
    }

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [_text resignFirstResponder];
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
