//
//  FCPopActionView.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import "FCPopActionView.h"

#define kFCPopContentWidth (self.frame.size.width)
#define kFCPopLineWidth (1.0f/[UIScreen mainScreen].scale)

//相关的数据做了一个包装
@interface FCPopItemBox : NSObject

@property (nonatomic) id item;
@property (nonatomic) FCPopItemController *controller;
@property (nonatomic) UIView *displayView;
@property (nonatomic) UIView *separateLine;

@end

@implementation FCPopItemBox
@end

#pragma mark -

@interface FCPopActionView (){
    //滚动区域视图
    UIScrollView *_scrollZone;
    //所有的数据
    NSMutableArray<FCPopItemBox *> *_itemBoxs;
}

//内容视图
@property (nonatomic) UIView *contentView;
//topView和contentView之间的分割线
@property (nonatomic) UIView *topViewLine;
//滚动区域底部分割线
@property (nonatomic) UIView *scrollBottomLine;
//contentView和bottomView之间的分割线
@property (nonatomic) UIView *contentViewLine;

@end

@implementation FCPopActionView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _itemBoxs = [[NSMutableArray alloc] init];
        
        _separateColor = [UIColor colorWithWhite:0.9 alpha:1];
        _showSeparateLine = YES;
        
        _scrollZone = [[UIScrollView alloc] init];
        _scrollZone.showsVerticalScrollIndicator = NO;
        _scrollZoneMaxHeight = INT_MAX;
        
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setTopView:(UIView *)topView{
    [_topView removeFromSuperview];
    
    _topView = topView;
    [self addSubview:_topView];
    
    self.topViewLine.hidden = _topView == nil;
    
    [self setNeedsLayout];
}

-(void)setBottomView:(UIView *)bottomView{
    [_bottomView removeFromSuperview];
    
    _bottomView = bottomView;
    [self addSubview:_bottomView];
    
    self.contentViewLine.hidden = _bottomView == nil;
    
    [self setNeedsLayout];
}

-(void)setItems:(NSArray *)items{
    _items = items;
    
    [self reloadData];
}

-(void)setDelegate:(id<FCPopActionViewDelegate>)delegate{
    _delegate = delegate;
    
    [self reloadData];
}

-(void)setScrollRange:(NSRange)scrollRange{
    _scrollRange = scrollRange;
    
    [self reloadData];
}

-(void)reloadData{
    
    if (![self.delegate respondsToSelector:@selector(popActionView:itemControllerForItem:)]) {
        return;
    }
    
    for (FCPopItemBox *box in _itemBoxs) {
        [box.displayView removeFromSuperview];
        [box.separateLine removeFromSuperview];
    }
    [_itemBoxs removeAllObjects];
    
    [_scrollZone.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_contentView addSubview:_scrollZone];
    
    NSInteger scrollStart = _scrollRange.location;
    NSInteger scrollEnd = MIN(_items.count, _scrollRange.location+_scrollRange.length)-1;
    
    for (int i = 0; i<_items.count; i++) {
        FCPopItemController *controller = [self.delegate popActionView:self itemControllerForItem:_items[i]];
        FCPopItemBox *box = [[FCPopItemBox alloc] init];
        box.item = _items[i];
        box.controller = controller;
        
        BOOL inScrollRange = i>=scrollStart && i<=scrollEnd;
        UIView *parentView = inScrollRange?_scrollZone:_contentView;
        UIView *itemView = controller.displayView;
        
        box.displayView = itemView;
        [parentView addSubview:itemView];
        
        [_itemBoxs addObject:box];
    }
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat currentY = _topSpace;
    
    CGRect frame = _topView.frame;
    frame.origin.y = currentY;
    frame.origin.x = 0;
    frame.size.width = kFCPopContentWidth;
    _topView.frame = frame;
    currentY += frame.size.height;
    
    if (_topView) {
        self.topViewLine.frame = CGRectMake(0,frame.size.height-kFCPopLineWidth, kFCPopContentWidth, kFCPopLineWidth);
    }
    
    _contentView.frame = CGRectMake(0, currentY, kFCPopContentWidth, 10);
    [self layoutContentView];
    currentY += _contentView.frame.size.height;
    
    if (_bottomView) {
        self.contentViewLine.frame = CGRectMake(0,CGRectGetMaxY(_contentView.frame)-kFCPopLineWidth, kFCPopContentWidth, kFCPopLineWidth);
    }
    
    frame = _bottomView.frame;
    frame.origin.x = 0;
    frame.origin.y = currentY;
    frame.size.width = kFCPopContentWidth;
    _bottomView.frame = frame;
    currentY += frame.size.height;
    
    CGFloat totalHeight = currentY+_bottomSpace;
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, totalHeight);
}

-(void)layoutContentView{
    CGFloat width = _contentView.frame.size.width;
    
    NSInteger scrollStart = _scrollRange.location;
    NSInteger scrollEnd = MIN(_items.count, _scrollRange.location+_scrollRange.length)-1;
    
    CGFloat curY1 = 0;  //外层
    CGFloat curY2 = 0, innerStart = 0;  //内层，滚动区域
    for (int i = 0; i<_itemBoxs.count; i++) {
        
        FCPopItemBox *box = _itemBoxs[i];
        BOOL inScrollRange = i>=scrollStart && i<=scrollEnd;
        
        CGRect frame = box.displayView.frame;
        frame.origin.x = 0;
        frame.origin.y = inScrollRange?curY2:curY1;
        frame.size.width = width;
        box.displayView.frame = frame;
        [box.controller layoutDisplayView];
        
        //最后一个视图不加分割线，避免和contentViewLine重叠
        if (_showSeparateLine && !box.separateLine &&
            (i != _itemBoxs.count-1 && i != scrollEnd)) {
            box.separateLine = [self addBottomLineTo:box.displayView];
        }
        box.separateLine.frame = CGRectMake(_separateInsets.left, frame.size.height-kFCPopLineWidth, frame.size.width-_separateInsets.left-_separateInsets.right, kFCPopLineWidth);
        
        if (inScrollRange) {
            curY2 += frame.size.height;
        }else{
            curY1 += frame.size.height;
        }
        
        //从内层跳回外层，内层的高度叠加到外层
        if (i == scrollEnd) {
            curY1 += MIN(curY2, self.scrollZoneMaxHeight);
            
            self.scrollBottomLine.hidden = scrollEnd>=scrollStart;
            self.scrollBottomLine.frame = CGRectMake(_separateInsets.left, curY1-kFCPopLineWidth, frame.size.width-_separateInsets.left-_separateInsets.right, kFCPopLineWidth);
        }else if (i == scrollStart){
            innerStart = curY1; //内层开始位置
        }
    }
    
    CGRect frame = _contentView.frame;
    frame.size.height = curY1;
    _contentView.frame = frame;
    
    _scrollZone.frame = CGRectMake(0, innerStart, width, MIN(curY2, self.scrollZoneMaxHeight));
    _scrollZone.contentSize = CGSizeMake(width, curY2);
}

#pragma mark - 属性调整

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

-(void)setShowSeparateLine:(BOOL)showSeparateLine{
    _showSeparateLine = showSeparateLine;
    
    if (!_scrollBottomLine) { //没生成过
        [self setNeedsLayout];
    }else{
        self.scrollBottomLine.hidden = !_showSeparateLine;
        
        for (FCPopItemBox *box in _itemBoxs) {
            box.separateLine.hidden = !_showSeparateLine;
        }
    }
}

-(void)setSeparateInsets:(UIEdgeInsets)separateInsets{
    _separateInsets = separateInsets;
    [self setNeedsLayout];
}

-(void)setSeparateColor:(UIColor *)separateColor{
    _separateColor = separateColor;
    
    _topViewLine.backgroundColor = separateColor;
    _contentViewLine.backgroundColor = separateColor;
    _scrollBottomLine.backgroundColor = separateColor;
    
    for (FCPopItemBox *box in _itemBoxs) {
        box.separateLine.backgroundColor = separateColor;
    }
}

#pragma mark - 工具方法和懒加载

-(UIView *)addBottomLineTo:(UIView *)view{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = _separateColor;
    [view addSubview:line];
    
    return line;
}

-(UIView *)topViewLine{
    if (!_topViewLine) {
        _topViewLine = [[UIView alloc] init];
        _topViewLine.backgroundColor = _separateColor;
        _topViewLine.hidden = YES;
        [self addSubview:_topViewLine];
    }
    return _topViewLine;
}

-(UIView *)scrollBottomLine{
    if (!_scrollBottomLine && _showSeparateLine) {
        _scrollBottomLine = [[UIView alloc] init];
        _scrollBottomLine.backgroundColor = _separateColor;
        [_contentView addSubview:_scrollBottomLine];
    }
    return _scrollBottomLine;
}

-(UIView *)contentViewLine{
    if (!_contentViewLine) {
        _contentViewLine = [[UIView alloc] init];
        _contentViewLine.backgroundColor = _separateColor;
        _contentViewLine.hidden = YES;
        [self addSubview:_contentViewLine];
    }
    return _contentViewLine;
}

@end
