//
//  Todaytd+CoreDataProperties.h
//  计划狗2
//
//  Created by 赵乐煜 on 2017/2/24.
//  Copyright © 2017年 Loyv Zhao. All rights reserved.
//

#import "Todaytd+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Todaytd (CoreDataProperties)

+ (NSFetchRequest<Todaytd *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contain;

@end

NS_ASSUME_NONNULL_END
