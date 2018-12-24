//
//  FCPopSimpleItem.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopSimpleItem.h"

@implementation FCPopSimpleItem

+(NSArray<FCPopSimpleItem *> *)activeItemWithIcons:(NSArray *)icons titles:(NSArray<NSString *> *)titles{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSInteger count = MAX(icons.count, titles.count);
    
    for (int i = 0; i<count; i++) {
        FCPopSimpleItem *item = [[FCPopSimpleItem alloc] init];
        
        if (i < icons.count) {
            if ([icons[i] isKindOfClass:[NSString class]]) {
                item.icon = [UIImage imageNamed:icons[i]];
            }else{
                item.icon = icons[i];
            }
        }
        
        if (i < titles.count) {
            item.title = titles[i];
        }
        
        [items addObject:item];
    }
    
    return items;
}

@end
