//
//  Todaytd+CoreDataProperties.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/24.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "Todaytd+CoreDataProperties.h"

@implementation Todaytd (CoreDataProperties)

+ (NSFetchRequest<Todaytd *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Todaytd"];
}

@dynamic contain;

@end
