//
//  NSObject+Category.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)

- (BOOL)isNotEmptyNSString; // 判断是否为空字符串
- (BOOL)isNotEmptyArray; // 判断是否为空数组
- (BOOL)isNotEmptyDictionary; // 判断是否为空字典
- (BOOL)isNotEmptyNSNumberOrNSString; // 判断是否为空Number或字符串

@end
