//
//  FCPopTitleView.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

///提供一种简单的弹框标题视图，用在FCPopActionView里作topView
///内容就是主标题+副标题

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCPopTitleView : UIView

/** 主标题 */
@property (nonatomic) UILabel *titleLabel;
/** 副标题 */
@property (nonatomic) UILabel *subtitleLabel;

/** 边距,扣掉边距后剩余的空间里，整体上下居中显示 */
@property (nonatomic) UIEdgeInsets margins;

@end

NS_ASSUME_NONNULL_END
