//
//  NSArray+Category.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)

- (id)safeObjectAtIndex:(NSUInteger)index; // 数组安全取值(防止数组越界)

@end
