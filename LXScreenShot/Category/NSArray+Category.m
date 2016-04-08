//
//  NSArray+Category.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (id)safeObjectAtIndex:(NSUInteger)index {
    
    id obj = nil;
    if (index < self.count) {
        obj = [self objectAtIndex:index];
    }
    return obj;
}

@end
