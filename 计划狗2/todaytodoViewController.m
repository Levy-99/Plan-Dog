//
//  todaytodoViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/20.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//


#import "todaytodoViewController.h"
#import "addtodoViewController.h"
#import "editTodayViewController.h"
#import "Todaytd+CoreDataClass.h"
#import <UserNotifications/UserNotifications.h>


@interface todaytodoViewController ()<UITableViewDataSource,UITableViewDelegate,UNUserNotificationCenterDelegate>{
    
    NSManagedObjectContext *context;//coredata上下文
   
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSInteger flag;
@property (nonatomic, strong) UNMutableNotificationContent *notiContent;
@property (nonatomic) NSNumber *num;

@end

@implementation todaytodoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.72 blue:0.40 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(post)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=add;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *move = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(move)];
    self.navigationItem.leftBarButtonItem = move;
    
    self.notiContent = [[UNMutableNotificationContent alloc]init];
    [[UNUserNotificationCenter currentNotificationCenter]setDelegate:self];//引入代理
    

}
-(void)viewWillAppear:(BOOL)animated{


    
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
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Todaytd" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contain like %@", @"*"];
    request.predicate = predicate;
    error = nil;
    _objs = [context executeFetchRequest:request error:&error];
    NSLog(@"Number of TODOs: %lu", (unsigned long) [_objs count]);
    
    _cellText = [[NSMutableArray alloc] init];
    for (NSManagedObject *obj in _objs) {
        NSLog(@"%@", [obj valueForKey:@"contain"]);
        [_cellText addObject: [NSString stringWithFormat:@"%@", [obj valueForKey:@"contain"]]];
    }
    
    
    NSLog(@"todaytodoViewController: %@", NSHomeDirectory());//数据库会存在沙盒目录的Documents文件夹下
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor whiteColor];    
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];//去除多余分割线
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//以导航栏底部为界
    [self.view addSubview:_tableview];
    self.flag = 1;
    
    _num = [NSNumber numberWithUnsignedInteger:self.cellText.count];
    [self regiterLocalNotification:self.notiContent];
}



- (void)regiterLocalNotification:(UNMutableNotificationContent *)content{
    
    
    content.badge = _num;
    UNTimeIntervalNotificationTrigger *trigger1;
    NSString *requertIdentifier = @"RequestIdentifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error.localizedDescription);
            }
     ];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
       // Dispose of any resources that can be recreated.
}
-(void)post{
    addtodoViewController *addtodo = [[addtodoViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addtodo];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    //[self.navigationController pushViewController:nav animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellText.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"todayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
    }

    cell.textLabel.text = [_cellText objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    editTodayViewController *edit = [[editTodayViewController alloc]init];
    edit.textString = [_cellText objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:edit animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@", [_cellText objectAtIndex:indexPath.row]);
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
        request.entity = [NSEntityDescription entityForName:@"Todaytd" inManagedObjectContext:context];//找到我们的Todaytd
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contain like %@", [NSString stringWithFormat:@"%@", [_cellText objectAtIndex:indexPath.row]]];//创建谓词语句
        request.predicate = predicate; //赋值给请求的谓词语句
        
        NSError *error = nil;
        _objs = [context executeFetchRequest:request error:&error];//执行我们的请求
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];//抛出异常
        }
        // 遍历数据
        for (NSManagedObject *obj in _objs) {
            NSLog(@"contain = %@", [obj valueForKey:@"contain"]); //打印符合条件的数据
            [context deleteObject:obj];//删除数据
        }
        
        
        BOOL success = [context save:&error];
        if (!success) {
            [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
            
        } else {
            NSLog(@"删除成功");
        }
        [_cellText removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableview reloadData];
    }
}

// 设置 cell 是否允许移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}
// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    [self.cellText exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

-(void)move{
    if(self.flag == 1)
    {
        _tableview.editing = true;
        self.flag = 0;
    }
    else
    {
        _tableview.editing = false;
        self.flag = 1;
    }
}

#pragma mark - delegate
//只有当前处于前台才会走，加上返回方法，使在前台显示信息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSLog(@"执行willPresentNotificaiton");
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    
    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
    NSLog(@"收到通知：%@",response.notification.request.content);
    
    if ([categoryIdentifier isEqualToString:@"Categroy"]) {
        //识别需要被处理的拓展
        if ([response.actionIdentifier isEqualToString:@"replyAction"]){
            //识别用户点击的是哪个 action
            UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
            //获取输入内容
            NSString *userText = textResponse.userText;
            //发送 userText 给需要接收的方法
            NSLog(@"要发送的内容是：%@",userText);
            //[ClassName handleUserText: userText];
        }else if([response.actionIdentifier isEqualToString:@"enterAction"]){
            NSLog(@"点击了进入应用按钮");
        }else{
            NSLog(@"点击了取消");
        }
        
    }
    completionHandler();
    
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
