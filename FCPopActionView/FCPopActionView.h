//
//  FCPopActionView.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

/**
 分成3部分：头部、中间和底部。中间在内容多时会滚动显示。
 头部和底部都是直接提供view，中间通过提供的数据来生成，通过delegate给每条数据提供控制器，它负责从数据生成指定的视图和相关数据操作
 */

#import <UIKit/UIKit.h>
#import "FCPopActionViewDef.h"

@interface FCPopActionView : UIView

@property (nonatomic) UIView *topView;
@property (nonatomic) UIView *bottomView;

@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic) NSArray *items;

@property (nonatomic) id<FCPopActionViewDelegate> delegate;

@property (nonatomic) NSRange scrollRange;
@property (nonatomic) CGFloat scrollZoneMaxHeight;


-(void)reloadData;


@property (nonatomic) BOOL showSeparateLine;
@property (nonatomic) UIEdgeInsets separateInsets;
@property (nonatomic) UIColor *separateColor;

@property (nonatomic) CGFloat cornerRadius;

@end
