//
//  Countdown+CoreDataProperties.m
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/24.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "Countdown+CoreDataProperties.h"

@implementation Countdown (CoreDataProperties)

+ (NSFetchRequest<Countdown *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Countdown"];
}

@dynamic content;
@dynamic date;

@end