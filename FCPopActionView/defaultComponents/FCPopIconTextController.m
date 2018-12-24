//
//  FCPopIconTextController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/19.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopIconTextController.h"

@interface FCPopIconTextController ()

@end

@implementation FCPopIconTextController

- (instancetype)initWithItem:(id)item
{
    self = [super initWithItem:item];
    if (self) {
        _height = 44;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, _height)];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        [_contentView addSubview:_titleLabel];
        
        [self layoutDisplayView];
    }
    return self;
}

-(void)setHeight:(CGFloat)height{
    _height = height;
    
    [self layoutDisplayView];
}

-(void)setItem:(id)item{
    [super setItem:item];
    
    if ([self.item isKindOfClass:[NSString class]]) {
        _titleLabel.text = item;
    }else if ([self.item isKindOfClass:[UIImage class]]){
        _iconView.image = item;
    }
    
    [self layoutDisplayView];
}

-(void)layoutDisplayView{
    CGRect frame = _contentView.frame;
    frame.size.height = _height;
    _contentView.frame = frame;
    
    CGFloat iconW = _iconWidth;
    if (iconW == 0) {
        iconW = MAX(_iconView.image.size.width, _iconView.image.size.height);
    }
    _iconView.frame = CGRectMake(10, _height/2.0-iconW/2.0, iconW, iconW);
    CGFloat left = iconW == 0?10:iconW+10;
    _titleLabel.frame = CGRectMake(left, 0, frame.size.width-left-10, _height);
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    _contentView.backgroundColor = backgroundColor;
}

-(UIView *)displayView{
    return _contentView;
}

@end
