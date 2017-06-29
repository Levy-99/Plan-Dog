//
//  addtodoViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/20.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "addtodoViewController.h"
#import "Todaytd+CoreDataClass.h"
#import "todaytodoViewController.h"

@interface addtodoViewController ()<UITextViewDelegate>{
    
    NSManagedObjectContext *context;//coredata上下文
    
}

@property (strong,nonatomic) UITextView *text;

@end

@implementation addtodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:242/255 green:242/255 blue:242/255 alpha:0.3];
    self.title = @"输入待办事件";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel1)];
    self.navigationItem.leftBarButtonItem = cancel;
    UIBarButtonItem *save=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save1)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.72 blue:0.40 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=save;
    
    
//     _text = [[UITextField alloc]initWithFrame:CGRectMake(20, 100,self.view.frame.size.width-40, 50)];
//    //text.borderStyle = UITextBorderStyleBezel;
//    //text.backgroundColor = [UIColor whiteColor];
//
//    _text.textColor = [UIColor grayColor];
//    _text.tag=100;
//    _text.textAlignment = NSTextAlignmentLeft;
//    _text.keyboardType = UIKeyboardTypeDefault;
//    _text.returnKeyType = UIReturnKeyDone;
//    _text.delegate = self;
    
    _text =[[UITextView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400)];
    _text.delegate = self;
    _text.font = [UIFont systemFontOfSize:16];//字体大小
    [_text becomeFirstResponder];//获得焦点
    _text.returnKeyType = UIReturnKeyNext;
    _text.keyboardType = UIKeyboardTypeDefault;
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20,150, self.view.frame.size.width-40, 1)];
//    lineView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:lineView];
    
    [self.view addSubview:_text];

    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Todaytd.sqlite"]];//设置数据库的路径和文件名称和类型
    
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
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cancel1
{
     [self dismissViewControllerAnimated:YES completion:nil];
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
    NSManagedObject *s1 = [NSEntityDescription    insertNewObjectForEntityForName:@"Todaytd" inManagedObjectContext:context];
    if ([_text.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"写点什么吧" message:nil buttonText:@"好的"];
        return;
    }
    else {
    [s1 setValue:_text.text forKey:@"contain"];
    [_text resignFirstResponder];
    NSError *error = nil;
    
    BOOL success = [context save:&error];
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        NSLog(@"插入成功");
        //[self.tableview reloadData];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
        //[self.navigationController popViewControllerAnimated:YES];
    }
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
