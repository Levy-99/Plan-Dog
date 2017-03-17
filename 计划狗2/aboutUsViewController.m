//
//  aboutUsViewController.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/23.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "aboutUsViewController.h"

@interface aboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation aboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];//去除多余分割线
    [self.view addSubview:tableview];
   // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    


    // Do any additional setup after loading the view.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    if(indexPath.row == 0){
        cell.textLabel.text = @"制作";
        cell.detailTextLabel.text = @"OurEDA";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"联系方式";
        cell.detailTextLabel.text = @"362809422@qq.com";
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
