//
//  editcountViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/27.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "editcountViewController.h"
#import "Countdown+CoreDataClass.h"
#import "countdownViewController.h"

@interface editcountViewController ()<UITextFieldDelegate>{
    
    NSManagedObjectContext *context;//coredata上下文
    
}

@property (strong,nonatomic) UITextField *text;
@property (strong,nonatomic) UIDatePicker *datePicker;
@end

@implementation editcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255 green:242/255 blue:242/255 alpha:0.3];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel1)];
    self.navigationItem.leftBarButtonItem = cancel;
    UIBarButtonItem *save=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save1)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.72 blue:0.40 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=save;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[dateFormatter dateFromString:_indexpathDate];
    
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(50, 400, self.view.frame.size.width-100, 216)];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    _datePicker.date = date1;
    [self.view addSubview:_datePicker];
    
    _text = [[UITextField alloc]initWithFrame:CGRectMake(20, 100,self.view.frame.size.width-40, 50)];
    //text.borderStyle = UITextBorderStyleBezel;
    //text.backgroundColor = [UIColor whiteColor];
    _text.text = self.textString;
    _text.textColor = [UIColor blackColor];
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

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cancel1
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSFetchRequest *request = [[NSFetchRequest alloc] init];//创建请求
    request.entity = [NSEntityDescription entityForName:@"Countdown" inManagedObjectContext:context];//找到我们的Countdown
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content like %@", self.textString];//查询条件：content等于原内容
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];//执行请求
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    //todaytodoViewController *today = [[todaytodoViewController alloc]init];
    // 遍历数据
    if ([_text.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"写点什么吧" message:nil buttonText:@"知道了"];
        return;
    }

    for (NSManagedObject *obj in objs) {

        [obj setValue:_text.text forKey:@"content"];//查到数据后，将它的content修改成新的
        [obj setValue:_datePicker.date forKey:@"date"];
    }
    
    BOOL success = [context save:&error];
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    } else {
        NSLog(@"修改成功");
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
