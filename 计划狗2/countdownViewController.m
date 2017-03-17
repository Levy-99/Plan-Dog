//
//  countdownViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/20.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "countdownViewController.h"
#import "addcountdownViewController.h"
#import "Countdown+CoreDataClass.h"
#import "editcountViewController.h"
#import "Countdown+CoreDataProperties.h"
#import <UserNotifications/UserNotifications.h>



@interface countdownViewController ()<UITableViewDataSource,UITableViewDelegate,UNUserNotificationCenterDelegate>{
    
    NSManagedObjectContext *context;//coredata上下文
    
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSDate *currentDate;
@property (nonatomic,strong) NSString *todayDate;
@property (nonatomic, strong) UNMutableNotificationContent *notiContent;
@property (nonatomic) int days;
@end

@implementation countdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.72 blue:0.40 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(click2)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=add;
    
    self.fetchedResultsController.delegate = self;
    
    self.notiContent = [[UNMutableNotificationContent alloc]init];
    [[UNUserNotificationCenter currentNotificationCenter]setDelegate:self];//引入代理
    
}

-(void)viewWillAppear:(BOOL)animated{
    // Do any additional setup after loading the view.
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
    
    NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
    request1.entity = [NSEntityDescription entityForName:@"Countdown" inManagedObjectContext:context];
    NSPredicate *predicatecontent = [NSPredicate predicateWithFormat:@"content like %@", @"*"];
    request1.predicate = predicatecontent;
    error = nil;
    _objs1 = [context executeFetchRequest:request1 error:&error];
    NSLog(@"Number of Countdowns: %lu", (unsigned long) [_objs1 count]);
    
    _cellText1 = [[NSMutableArray alloc] init];
    _cellText2 = [[NSMutableArray alloc] init];
    for (NSManagedObject *obj in _objs1) {
        NSLog(@"%@", [obj valueForKey:@"content"]);
        [_cellText1 addObject: [NSString stringWithFormat:@"%@", [obj valueForKey:@"content"]]];
        NSLog(@"%@", [obj valueForKey:@"date"]);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:[obj valueForKey:@"date"]];
        [_cellText2 addObject:dateString];
    }
    NSLog(@"todaytodoViewController: %@", NSHomeDirectory());//数据库会存在沙盒目录的Documents文件夹下
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];//去除多余分割线
    self.edgesForExtendedLayout = UIRectEdgeNone;//以导航栏底部为界
    [self.view addSubview:_tableview];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"%@",localeDate);
    
    NSDateFormatter *nowDate = [[NSDateFormatter alloc]init];
    [nowDate setDateFormat:@"yyyy-MM-dd"];
    _todayDate = [nowDate stringFromDate:localeDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)regiterLocalNotification:(UNMutableNotificationContent *)content cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    content.title = @"倒计时-就在今天";
    content.subtitle = [_cellText2 objectAtIndex:indexPath.row];
    content.body = [_cellText1 objectAtIndex:indexPath.row];
    
    //重复提醒，时间间隔要大于60s
    if(_days>=0){
        UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:_days*24*3600+2.0 repeats:NO];
    NSString *requertIdentifier = @"RequestIdentifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error.localizedDescription);
    }];
    }
}

-(void)click2{
    addcountdownViewController *addcountdown = [[addcountdownViewController alloc]init];
    [self.navigationController pushViewController:addcountdown animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}
-(void)post{
    addcountdownViewController *addtodo = [[addcountdownViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addtodo];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    //[self.navigationController pushViewController:nav animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellText1.count;
    //return self.fetchedResultsController.sections[section].numberOfObjects;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Countdown *countdown = [self.fetchedResultsController objectAtIndexPath:indexPath];
    static NSString *strCell = @"countdownCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
    if (!cell) {
        
    }

    cell.textLabel.text = [_cellText1 objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_cellText2 objectAtIndex:indexPath.row];
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width)-130, 25, 100, 50)];
    timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    timeLabel.backgroundColor = [UIColor whiteColor];

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[dateFormatter dateFromString:_todayDate];
    NSDate *date2=[dateFormatter dateFromString:[_cellText2 objectAtIndex:indexPath.row]];
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];

    _days = ((int)time)/(3600*24);  //一天是24小时*3600秒
    NSString * dateValue = [NSString stringWithFormat:@"%i",_days+1];
    
    if (_days>0) {
        timeLabel.text = dateValue;}
    else{
        timeLabel.text = @"终";}
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:timeLabel];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self regiterLocalNotification:self.notiContent cellForRowAtIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    editcountViewController *edit = [[editcountViewController alloc]init];
    edit.textString = [_cellText1 objectAtIndex:indexPath.row];
    edit.indexpathDate = [_cellText2 objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:edit animated:YES];
    //[self.navigationController presentViewController:edit animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    
    NSLog(@"%@", [_cellText1 objectAtIndex:indexPath.row]);
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
        request.entity = [NSEntityDescription entityForName:@"Countdown" inManagedObjectContext:context];//找到我们的Countdown
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content like %@", [NSString stringWithFormat:@"%@", [_cellText1 objectAtIndex:indexPath.row]]];//创建谓词语句
        request.predicate = predicate; //赋值给请求的谓词语句
        
        NSError *error = nil;
        _objs1 = [context executeFetchRequest:request error:&error];//执行我们的请求
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];//抛出异常
        }
        // 遍历数据
        for (NSManagedObject *obj in _objs1) {
            NSLog(@"content = %@", [obj valueForKey:@"content"]); //打印符合条件的数据
            [context deleteObject:obj];//删除数据
        }
        
        
        BOOL success = [context save:&error];
        if (!success) {
            [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
            
        } else {
            NSLog(@"删除成功");
        }
        
        [_cellText1 removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
