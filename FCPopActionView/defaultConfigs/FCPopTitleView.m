//
//  FCPopTitleView.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopTitleView.h"

#define FCPopLabelSpace 4

@interface FCPopTitleView ()

@end

@implementation FCPopTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:_subtitleLabel];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat clipedHeight = self.frame.size.height - _margins.top - _margins.bottom;
    CGFloat clipedWidth = self.frame.size.width - _margins.left - _margins.right;
    
    _titleLabel.frame = CGRectMake(0, 0, clipedWidth, 10);
    _subtitleLabel.frame = CGRectMake(0, 0, clipedWidth, 10);
    [_titleLabel sizeToFit];
    [_subtitleLabel sizeToFit];
    
    CGFloat totalHeight = _titleLabel.frame.size.height+_subtitleLabel.frame.size.height+FCPopLabelSpace;
    if (clipedHeight < totalHeight) {
        clipedHeight = totalHeight;
    }
    
    CGFloat startY = _margins.top+(clipedHeight-totalHeight)/2.0f;
    
    CGRect frame = _titleLabel.frame;
    frame.origin.y = startY;
    frame.origin.x = _margins.left;
    frame.size.width = clipedWidth;
    _titleLabel.frame = frame;
    
    frame = _subtitleLabel.frame;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame)+FCPopLabelSpace;
    frame.origin.x = _margins.left;
    frame.size.width = clipedWidth;
    _subtitleLabel.frame = frame;
}

@end
