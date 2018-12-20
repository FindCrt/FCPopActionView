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
@property (nonatomic) UIImage *selectedIcon;

@property (nonatomic) UIColor *normalColor;
@property (nonatomic) UIColor *selectedColor;

@end

NS_ASSUME_NONNULL_END
