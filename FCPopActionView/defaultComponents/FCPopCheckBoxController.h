//
//  FCPopCheckBoxController.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopIconTextController.h"
#import "FCPopActionViewDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCPopCheckBoxController : FCPopIconTextController<FCPopItemSelectable>

@property (nonatomic) UIImage *normalIcon;
@property (nonatomic) UIImage *checkIcon;

@property (nonatomic) UIColor *normalColor;
@property (nonatomic) UIColor *checkColor;

@property (nonatomic) BOOL checkIconRight;
@property (nonatomic) CGFloat rightSpace;

@end

NS_ASSUME_NONNULL_END
