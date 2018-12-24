//
//  FCPopSimpleItem.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

///最简单的数据类型，一个图片+一个文字

#import <UIKit/UIKit.h>

@interface FCPopSimpleItem : NSObject


/**
 使用图标和标题列表构建数据，图片可以是字符串类型，会转成图片
 @param icons 图片列表
 @param titles 标题列表
 @return 数据列表
 */
+(NSArray<FCPopSimpleItem *> *)activeItemWithIcons:(NSArray *)icons titles:(NSArray<NSString *> *)titles;

@property (nonatomic) UIImage *icon;
@property (nonatomic) NSString *title;

/** 关联数据，可以用来做标识提供额外处理 */
@property (nonatomic) id releateData;

/** 选择相关数据 */

@property (nonatomic) BOOL selectable;
@property (nonatomic) UIImage *selectedIcon;
@property (nonatomic) UIColor *normalColor;
@property (nonatomic) UIColor *selectedColor;

@end
