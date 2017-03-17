//
//  Countdown+CoreDataProperties.h
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/24.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "Countdown+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Countdown (CoreDataProperties)

+ (NSFetchRequest<Countdown *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *date;

@end

NS_ASSUME_NONNULL_END
