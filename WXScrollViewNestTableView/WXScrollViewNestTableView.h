//
//  WXScrollViewNestTableView.h
//  WXScrollViewNestTableView
//
//  Created by EDZ on 2018/6/5.
//  Copyright © 2018年 wangxiaoxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXScrollViewNestTableView : UIView

/**
 * 滑动 scrollView 停在第几个列表 回调
 */
@property (nonatomic, copy) void (^scrollIndex)(NSInteger index);

/**
 @param frame scrollView的大小
 @param tableViewArr tableview 数组
 @param headerView 头部可滑出屏幕部分
 @param sectionHeaderView 不可滑出屏幕部分 segmentedView
 */
+ (WXScrollViewNestTableView *)scrollViewNestTableViewWithFrame:(CGRect)frame tableViewArray:(NSArray *)tableViewArr headerView:(UIView *)headerView sectionHeaderView:(UIView *)sectionHeaderView;

/**
 * 切换第几个列表
 */
- (void)setIndex:(NSInteger)index;

@end
