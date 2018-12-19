//
//  UIColor+RandomColor.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/19.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+(instancetype)randomColor{
    float r = arc4random()%255;
    float g = arc4random()%255;
    float b = arc4random()%255;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
}

@end
