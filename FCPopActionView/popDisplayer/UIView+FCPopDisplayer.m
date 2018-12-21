//
//  UIView+FCPopDisplayer.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/21.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "UIView+FCPopDisplayer.h"
#import "FCPopDisplayer.h"
#import <objc/runtime.h>

static NSString *FCPopDisplayerKey = @"FCPopDisplayer";

@implementation UIView (FCPopDisplayer)

-(FCPopDisplayer *)displayer{
    return objc_getAssociatedObject(self, &FCPopDisplayerKey);
}

-(void)setDisplayer:(FCPopDisplayer *)displayer{
    return objc_setAssociatedObject(self, &FCPopDisplayerKey, displayer, OBJC_ASSOCIATION_RETAIN);
}

-(void)hide{
    [self.displayer hide];
}

-(void)show{
    [self.displayer show];
}

@end
