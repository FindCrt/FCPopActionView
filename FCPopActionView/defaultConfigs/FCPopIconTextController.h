//
//  FCPopIconTextController.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/19.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopItemController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCPopIconTextController : FCPopItemController

@property (nonatomic) UIImageView *iconView;

@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) UIColor *backgroundColor;

/** 图片宽高 */
@property (nonatomic) CGFloat iconWidth;

/** 指定高度 默认44 */
@property (nonatomic) CGFloat height;

@end

NS_ASSUME_NONNULL_END
