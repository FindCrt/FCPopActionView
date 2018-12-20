//
//  FCPopTextController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/19.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopTextController.h"

@interface FCPopTextController (){
    UIView *_contentView;
}

@end

@implementation FCPopTextController

-(instancetype)initWithItem:(id)item{
    if (self = [super initWithItem:item]) {
        _height = 44;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, _height)];
        
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor darkTextColor];
        [_contentView addSubview:_titleLabel];
        
        self.item = item;
    }
    return self;
}

-(void)setHeight:(CGFloat)height{
    _height = height;
    
    [self layoutDisplayView];
}

-(void)layoutDisplayView{
    CGRect frame = _contentView.frame;
    frame.size.height = _height;
    _contentView.frame = frame;
    
    _titleLabel.frame = CGRectMake(_margin, 0, frame.size.width-_margin*2, _height);
}

-(void)setItem:(id)item{
    [super setItem:item];
    
    if ([item isKindOfClass:[NSString class]]) {
        _titleLabel.text = item;
    }else{
        _titleLabel.text = [NSString stringWithFormat:@"%@",item];
    }
}

-(UIView *)displayView{
    return _contentView;
}

@end
