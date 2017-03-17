//
//  versionViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/23.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "versionViewController.h"

@interface versionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation versionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"当前版本";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];//去除多余分割线
    [self.view addSubview:tableview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//重复利用cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(indexPath.row == 0){
        cell.textLabel.text = @"计划狗";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"V 0.2";
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"2017年3月9日";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
