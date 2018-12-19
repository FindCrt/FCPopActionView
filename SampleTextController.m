//
//  SampleTextController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/19.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "SampleTextController.h"
#import "UIColor+RandomColor.h"

@implementation SampleTextController{
    UILabel *_label;
}

-(UIView *)displayView{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _label.backgroundColor = [UIColor randomColor];
        _label.text = self.item;
    }
    return _label;
}



@end
