//
//  FCPopIconTextController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/19.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopIconTextController.h"

@interface FCPopIconTextController (){
    UIView *_contentView;
}

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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
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
    
    _iconView.center = CGPointMake(10+_iconView.frame.size.width/2.0, _height/2.0);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame)+10, 0, frame.size.width-CGRectGetMaxX(_iconView.frame)-20, _height);
}

-(UIView *)displayView{
    return _contentView;
}

@end
