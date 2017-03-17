//
//  addcountdownViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/20.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "addcountdownViewController.h"
#import "Countdown+CoreDataClass.h"
#import "countdownViewController.h"


@interface addcountdownViewController ()<UITextFieldDelegate>{
    
    NSManagedObjectContext *context;//coredata上下文
    NSDate * date;
}
@property (strong,nonatomic) UITextField *text;
@property (strong,nonatomic) UIDatePicker *datePicker;
@end

@implementation addcountdownViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新增倒计时";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.72 blue:0.40 alpha:1];
    UIBarButtonItem *backItem2 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel1)];
    self.navigationItem.leftBarButtonItem = backItem2;
    UIBarButtonItem *Item4=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save1)];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=Item4;
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(50, 400, self.view.frame.size.width-100, 216)];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    [self.view addSubview:_datePicker];
    
    _text = [[UITextField alloc]initWithFrame:CGRectMake(20, 100,self.view.frame.size.width-40, 50)];
    //text.borderStyle = UITextBorderStyleBezel;
    //text.backgroundColor = [UIColor whiteColor];
    _text.placeholder = @"输入事件";
    _text.textColor = [UIColor grayColor];
    _text.tag=110;
    _text.textAlignment = NSTextAlignmentLeft;
    _text.keyboardType = UIKeyboardTypeDefault;
    _text.returnKeyType = UIReturnKeyDone;
    _text.delegate = self;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20,150, self.view.frame.size.width-40, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineView];
    
    [self.view addSubview:_text];
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Countdown.sqlite"]];//设置数据库的路径和文件名称和类型
    
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    
    NSLog(@"%@",NSHomeDirectory());//数据库会存在沙盒目录的Documents文件夹下
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonText:(NSString *)buttonText{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonText style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
                                 
}

- (void)cancel1
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)save1
{
    NSManagedObject *s1 = [NSEntityDescription    insertNewObjectForEntityForName:@"Countdown" inManagedObjectContext:context];
    if ([_text.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"写点什么吧" message:nil buttonText:@"知道了"];
        return;
    }
    else {
        [s1 setValue:_text.text forKey:@"content"];
        date = _datePicker.date;
        [s1 setValue:date forKey:@"date"];
        NSError *error = nil;
        
        BOOL success = [context save:&error];
        
        if (!success) {
            [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
            
        }else
        {
            NSLog(@"插入成功");
            //[self.tableview reloadData];
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
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
