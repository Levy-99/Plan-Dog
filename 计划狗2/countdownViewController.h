//
//  countdownViewController.h
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/20.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface countdownViewController : UIViewController<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, retain) NSArray *objs1;
@property (nonatomic, retain) NSMutableArray *cellText1;
@property (nonatomic, retain) NSMutableArray *cellText2;

@end
