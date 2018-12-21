//
//  FCPopCheckBoxController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopCheckBoxController.h"

@interface FCPopCheckBoxController ()

@property (nonatomic) UIImageView *checkIconView;

@end

@implementation FCPopCheckBoxController{
    BOOL _selected;
}

-(FCPopSelectType)selectType{
    return FCPopSelectTypeSelectable;
}

-(void)setNormalIcon:(UIImage *)normalIcon{
    _normalIcon = normalIcon;
    [self refreshContent];
}

-(void)setcheckIcon:(UIImage *)checkIcon{
    _checkIcon = checkIcon;
    [self refreshContent];
}

-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    [self refreshContent];
}

-(void)setcheckColor:(UIColor *)checkColor{
    _checkColor = checkColor;
    [self refreshContent];
}

-(void)selectStateChanged:(BOOL)selected{
    _selected = selected;
    [self refreshContent];
}

-(void)refreshContent{
    if (_selected) {
        self.checkIconView.image = _checkIcon;
        if (_checkColor) self.titleLabel.textColor = _checkColor;
    }else{
        self.checkIconView.image = _normalIcon;
        if (_normalColor) self.titleLabel.textColor = _normalColor;
    }
}

-(void)layoutDisplayView{
    [super layoutDisplayView];
    
    if (_checkIconRight) {
        CGFloat checkIconWidth = self.checkIconView.image.size.width;
        self.checkIconView.frame = CGRectMake(self.contentView.frame.size.width-checkIconWidth-_rightSpace, 0, checkIconWidth, self.contentView.frame.size.height);
        
        CGRect frame = self.titleLabel.frame;
        frame.origin.x = CGRectGetMaxX(self.iconView.frame);
        frame.size.width = CGRectGetMinX(self.checkIconView.frame)-frame.origin.x;
        self.titleLabel.frame = frame;
    }
}

-(void)setCheckIconRight:(BOOL)checkIconRight{
    _checkIconRight = checkIconRight;
    
    _checkIconView.hidden = !checkIconRight;
}

-(UIImageView *)checkIconView{
    if (!_checkIconRight) { //左侧时就和图标重叠，归为一个；右侧是分为两个
        return self.iconView;
    }
    
    if (!_checkIconView) {
        _checkIconView = [[UIImageView alloc] init];
        _checkIconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_checkIconView];
    }
    return _checkIconView;
}

@end
