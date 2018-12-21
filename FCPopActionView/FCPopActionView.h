//
//  FCPopActionView.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

/**
 一个用来弹出显示的操作视图：
 分成3部分：头部、中间和底部，中间在数据多时会滚动显示。
 头部和底部都是直接提供view，中间通过提供的数据来生成，通过delegate给每条数据提供控制器，它负责从数据生成指定的视图和相关数据操作
 */

#import <UIKit/UIKit.h>
#import "FCPopActionViewDef.h"
#import "FCPopItemController.h"

@class FCPopItemBox;

@interface FCPopActionView : UIView

/** 顶部视图 */
@property (nonatomic) UIView *topView;
/** 底部视图 */
@property (nonatomic) UIView *bottomView;
/** 内容视图 */
@property (nonatomic, readonly) UIView *contentView;

/** 内容视图部分的数据列表，每条数据对应一行内容 */
@property (nonatomic) NSArray *items;
/** 数据的打包内容，给子类管理数据使用 */
@property (nonatomic, readonly) NSArray<FCPopItemBox *> *itemBoxs;

/** 委托对象 */
@property (nonatomic) id<FCPopActionViewDelegate> delegate;

/** 出在滚动区域内的子项范围，如NSRange(2,4),则2、3、4、5这4个都在滚动区域内 */
@property (nonatomic) NSRange scrollRange;
/** 滑动区域的最大高度，默认为INT_MAX,即没有限制 */
@property (nonatomic) CGFloat scrollZoneMaxHeight;

/** 重载数据; 默认会layout并且根据内容修改大小 */
-(void)reloadData;
/** 子类可重载 */
-(FCPopItemController *)getControllerForItem:(id)item;
/** 布局变化时调用 */
-(void)layoutWithNorm:(FCPopLayoutNorm)norm;

/**  分割线相关属性 */
@property (nonatomic) BOOL showSeparateLine;
@property (nonatomic) UIEdgeInsets separateInsets;
@property (nonatomic) UIColor *separateColor;

/** 圆角 */
@property (nonatomic) CGFloat cornerRadius;

/** 顶部和底部留白 */
@property (nonatomic) CGFloat topSpace;
@property (nonatomic) CGFloat bottomSpace;

/** 子类可重载 */
-(void)clickedItem:(FCPopItemBox *)itemBox;

@end


#pragma mark -

//相关的数据做了一个包装
@interface FCPopItemBox : NSObject

@property (nonatomic) id item;
@property (nonatomic) FCPopItemController *controller;
@property (nonatomic) UIView *displayView;
@property (nonatomic) UIView *separateLine;

@end
