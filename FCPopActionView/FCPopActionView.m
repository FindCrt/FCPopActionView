//
//  FCPopActionView.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import "FCPopActionView.h"

#define kFCPopContentWidth (self.frame.size.width)

@interface FCPopActionView (){
    UIScrollView *_scrollZone;
    NSMutableArray<UIView *> *_itemViews;
}

@property (nonatomic) UIView *contentView;

@end

@implementation FCPopActionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _itemViews = [[NSMutableArray alloc] init];
        
        _scrollZone = [[UIScrollView alloc] init];
        _scrollZone.showsVerticalScrollIndicator = NO;
        
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
    }
    return self;
}

-(void)setTopView:(UIView *)topView{
    [_topView removeFromSuperview];
    
    _topView = topView;
    [self addSubview:_topView];
}

-(void)setBottomView:(UIView *)bottomView{
    [_bottomView removeFromSuperview];
    
    _bottomView = bottomView;
    [self addSubview:_bottomView];
}

-(void)setItems:(NSArray *)items{
    _items = items;
    
    [self reloadData];
}

-(void)reloadData{
    
    if (![self.delegate respondsToSelector:@selector(popActionView:itemControllerForItem:)]) {
        return;
    }
    
    [_itemViews removeAllObjects];
    
    [_scrollZone.subviews makeObjectsPerformSelector:@selector(removeAllObjects)];
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeAllObjects)];
    [_contentView addSubview:_scrollZone];
    
    NSInteger scrollStart = _scrollRange.location;
    NSInteger scrollEnd = MIN(_items.count-1, _scrollRange.location+_scrollRange.length-1);
    
    for (int i = 0; i<_items.count; i++) {
        FCPopItemController *controller = [self.delegate popActionView:self itemControllerForItem:_items[i]];
//        controller.item = _items[i];
        
        BOOL inScrollRange = i>=scrollStart && i<=scrollEnd;
        UIView *parentView = inScrollRange?_scrollZone:_contentView;
        UIView *itemView = controller.displayView;
        
        [parentView addSubview:itemView];
        [_itemViews addObject:itemView];
    }
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = _topView.frame;
    frame.origin.y = 0;
    frame.origin.x = 0;
    frame.size.width = kFCPopContentWidth;
    _topView.frame = frame;
    
    _contentView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), kFCPopContentWidth, 10);
    [self layoutContentView];
    
    frame = _bottomView.frame;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(_contentView.frame);
    frame.size.width = kFCPopContentWidth;
    _bottomView.frame = frame;
}

-(void)layoutContentView{
    CGFloat width = _contentView.frame.size.width;
    
    NSInteger scrollStart = _scrollRange.location;
    NSInteger scrollEnd = MIN(_items.count-1, _scrollRange.location+_scrollRange.length-1);
    
    CGFloat curY1 = 0;  //外层
    CGFloat curY2 = 0;  //内层，滚动区域
    for (int i = 0; i<_itemViews.count; i++) {
        
        BOOL inScrollRange = i>=scrollStart && i<=scrollEnd;
        
        CGRect frame = _itemViews[i].frame;
        frame.origin.x = 0;
        frame.origin.y = inScrollRange?curY2:curY1;
        frame.size.width = width;
        _itemViews[i].frame = frame;
        
        if (inScrollRange) {
            curY2 += frame.size.height;
        }else{
            curY1 += frame.size.height;
        }
        
        //从内层跳回外层，内层的高度叠加到外层
        if (i == scrollEnd) {
            curY1 += curY2;
        }
    }
}

@end
