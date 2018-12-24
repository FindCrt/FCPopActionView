//
//  FCPopSimpleView.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopSimpleView.h"
#import "FCPopCheckBoxController.h"

#pragma mark -

@implementation FCPopSimpleView

///不再使用父类的委托，为了更细化的处理交互
-(void)setDelegate:(id<FCPopActionViewDelegate>)delegate{
    NSAssert(delegate, @"delegate不可用");
}

-(void)setRowHeight:(CGFloat)rowHeight{
    _rowHeight = rowHeight;
    
    for (FCPopItemBox *itemBox in self.itemBoxs) {
        [(FCPopIconTextController *)itemBox.controller setHeight:_rowHeight];
    }
    [self layoutWithNorm:(FCPopLayoutNormContent)];
}

-(FCPopItemController *)getControllerForItem:(FCPopSimpleItem *)item{
    
    NSAssert([item isKindOfClass:[FCPopSimpleItem class]], @"item必须为FCPopSimpleItem类型");
    
    if (item.selectable) {
        FCPopCheckBoxController *controller = [[FCPopCheckBoxController alloc] initWithItem:item];
        controller.titleLabel.text = item.title;
        
        controller.normalIcon = item.icon;
        controller.checkIcon = item.selectedIcon;
        controller.checkColor = item.selectedColor;
        controller.normalIcon = item.icon;
        controller.normalColor = item.normalColor;
        if (_rowHeight>0) controller.height = _rowHeight;
        
        return controller;
        
    }else{
        FCPopIconTextController *controller = [[FCPopIconTextController alloc] initWithItem:item];
        controller.iconView.image = item.icon;
        controller.titleLabel.text = item.title;
        if (_rowHeight>0) controller.height = _rowHeight;
        
        return controller;
    }
}

-(void)noticeClickItem:(FCPopItemBox *)itemBox{
    if (self.clickBlock) {
        self.clickBlock(self, itemBox.item);
    }
}

-(FCPopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[FCPopTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        self.topView = _titleView;
    }
    
    return _titleView;
}

-(void)setTitle:(NSString *)title{
    self.titleView.titleLabel.text = title;
}

-(void)setSubtitle:(NSString *)subtitle{
    self.titleView.subtitleLabel.text = subtitle;
}

@end
