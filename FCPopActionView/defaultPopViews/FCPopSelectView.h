//
//  FCPopSelectView.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

///选择类型的弹框视图;
///数据控制器可实现<FCPopItemSelectable>协议来调整数据的选择类型和被选中后的样式变化

#import "FCPopActionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCPopSelectView : FCPopActionView

@property (nonatomic) NSSet *selectedItems;

/** 允许多选，默认为YES */
@property (nonatomic) BOOL allowMultiSelect;

-(void)noticeClickItem:(FCPopItemBox *)itemBox;

@end

NS_ASSUME_NONNULL_END
