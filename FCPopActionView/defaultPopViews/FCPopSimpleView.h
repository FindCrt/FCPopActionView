//
//  FCPopSimpleView.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

///最简单的样式：每行都是“图片(可无)+文字”，点击一项回调操作，然后关闭弹框；或者点击进行多选。
///传入类型使用FCPopSimpleItem，并且父类委托无效

#import "FCPopSelectView.h"
#import "FCPopSimpleItem.h"
#import "FCPopTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCPopSimpleView : FCPopSelectView

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) FCPopTitleView *titleView;

@property (nonatomic) void(^clickBlock)(FCPopSimpleView *actionView, FCPopSimpleItem *item);

@end

NS_ASSUME_NONNULL_END
