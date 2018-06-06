//
//  CustomSegmentedView.h
//  iTouzi
//
//  Created by EDZ on 2018/5/24.
//  Copyright © 2018年 itouzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegmentedView : UIView

@property (copy, nonatomic) void(^indexSelectedCompletion)(NSInteger selectedIndex, BOOL isAnimal);

+ (CustomSegmentedView *)customSegmentedViewWithFrame:(CGRect)frame;
+ (CustomSegmentedView *)customSegmentedViewWithFrame:(CGRect)frame withDataArr:(NSArray *)arr;

- (void)setSubViewWithArray:(NSArray *)arr;

- (void)setSelectedIndex:(NSUInteger)selectedIndex withAnimal:(BOOL)isAnimal;

@end
