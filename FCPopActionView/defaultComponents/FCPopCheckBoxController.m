//
//  FCPopCheckBoxController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopCheckBoxController.h"

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

-(void)setSelectedIcon:(UIImage *)selectedIcon{
    _selectedIcon = selectedIcon;
    [self refreshContent];
}

-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    [self refreshContent];
}

-(void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    [self refreshContent];
}

-(void)selectStateChanged:(BOOL)selected{
    _selected = selected;
    [self refreshContent];
}

-(void)refreshContent{
    if (_selected) {
        self.iconView.image = _selectedIcon;
        if (_selectedColor) self.titleLabel.textColor = _selectedColor;
    }else{
        self.iconView.image = _normalIcon;
        if (_normalColor) self.titleLabel.textColor = _normalColor;
    }
}

@end
