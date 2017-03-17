//
//  settingViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/20.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "settingViewController.h"
#import "versionViewController.h"
#import "aboutUsViewController.h"
#import "feedbackViewController.h"
#import "alarmViewController.h"

@interface settingViewController ()

@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.72 blue:0.40 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor whiteColor];

    tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];//去除多余分割线
    [self.view addSubview:tableview];


    

}
-(void)viewWillAppear:(BOOL)animated{
    feedbackViewController *feed = [[feedbackViewController alloc]init];
    NSLog(@"%ld",feed.flag);
    if(feed.flag == 1){
        [self showAlertWithTitle:@"谢谢你的反馈" message:nil buttonText:@"知道了"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//重复利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //static NSString *cellIdentifier = @"options";
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(indexPath.row == 0){
        cell.textLabel.text = @"当前版本";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"关于我们";
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"提醒方式";
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"反馈意见";
    }
    
   // if(cell == nil){
   // cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
   // cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        versionViewController *version = [[versionViewController alloc]init];
        [self.navigationController pushViewController:version animated:YES];
    }
    else if (indexPath.row == 1){
        aboutUsViewController *aboutUs = [[aboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutUs animated:YES];
    }
    else if (indexPath.row == 2){
        alarmViewController *alarm = [[alarmViewController alloc]init];
        [self.navigationController pushViewController:alarm animated:YES];
    }
    else{
        feedbackViewController *feedback = [[feedbackViewController alloc]init];
        [self.navigationController pushViewController:feedback animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
