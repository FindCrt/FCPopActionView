//
//  FCPopTextController.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/19.
//  Copyright © 2018 shiwei. All rights reserved.
//

///默认配置：图标+文字显示类型

#import "FCPopItemController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCPopTextController : FCPopItemController

@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) CGFloat margin;

/** 指定高度 默认44 */
@property (nonatomic) CGFloat height;

@end

NS_ASSUME_NONNULL_END
