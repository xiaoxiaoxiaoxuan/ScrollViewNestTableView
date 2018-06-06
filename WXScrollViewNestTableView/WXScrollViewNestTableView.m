//
//  WXScrollViewNestTableView.m
//  WXScrollViewNestTableView
//
//  Created by EDZ on 2018/6/5.
//  Copyright © 2018年 wangxiaoxuan. All rights reserved.
//

#import "WXScrollViewNestTableView.h"
#define WXStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

@interface WXScrollViewNestTableView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *tableViewArr;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat sectionHeaderViewHeight;
@property (nonatomic, strong) UIView *topView;
@end

const static int tagSubTableView = 1000;
@implementation WXScrollViewNestTableView

+ (WXScrollViewNestTableView *)scrollViewNestTableViewWithFrame:(CGRect)frame tableViewArray:(NSArray *)tableViewArr headerView:(UIView *)headerView sectionHeaderView:(UIView *)sectionHeaderView {
    WXScrollViewNestTableView *scrollViewNestTableView = [[WXScrollViewNestTableView alloc] initWithFrame:frame];
    [scrollViewNestTableView scrollViewNestTableViewWithTableViewArray:tableViewArr headerView:headerView sectionHeaderView:sectionHeaderView];
    return scrollViewNestTableView;
}

- (void)scrollViewNestTableViewWithTableViewArray:(NSArray *)tableViewArr headerView:(UIView *)headerView sectionHeaderView:(UIView *)sectionHeaderView {
    self.tableViewArr = tableViewArr;
    self.headerViewHeight = headerView.bounds.size.height + sectionHeaderView.bounds.size.height;
    self.sectionHeaderViewHeight = sectionHeaderView.bounds.size.height;
    
    // scrollView
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.mainScrollView.contentSize = CGSizeMake(self.bounds.size.width * tableViewArr.count, self.bounds.size.height);
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self addSubview:self.mainScrollView];
    
    for (int i = 0; i < tableViewArr.count; i++) {
        UITableView *tableView = tableViewArr[i];
        [tableView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
        tableView.frame = CGRectMake(i * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        tableView.tag = tagSubTableView + i;
        [self.mainScrollView addSubview:tableView];
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.headerViewHeight)];
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.headerViewHeight, 0, 0, 0);
    }
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.headerViewHeight)];
    [self addSubview:self.topView];
    [self.topView addSubview:headerView];
    sectionHeaderView.frame = CGRectMake(0, headerView.bounds.size.height, sectionHeaderView.bounds.size.width, sectionHeaderView.bounds.size.height);
    [self.topView addSubview:sectionHeaderView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"contentOffset"]) {
        CGPoint point= [((NSValue *)[object valueForKey:@"contentOffset"]) CGPointValue];
        CGFloat pianY = point.y;
        NSLog(@"%lf", pianY);
        if (pianY > self.headerViewHeight - self.sectionHeaderViewHeight) {
            self.topView.frame = CGRectMake(0, -(self.headerViewHeight - self.sectionHeaderViewHeight), self.topView.frame.size.width, self.topView.frame.size.height);
            for (int i = 0; i < self.tableViewArr.count; i++) {
                UITableView *tableView = [self.mainScrollView viewWithTag:tagSubTableView + i];
                if (tableView != object && tableView.contentOffset.y < self.headerViewHeight - self.sectionHeaderViewHeight) {
                    [tableView removeObserver:self forKeyPath:@"contentOffset"];
                    tableView.contentOffset = CGPointMake(0, self.headerViewHeight - self.sectionHeaderViewHeight);
                    [tableView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
                }
            }
        } else {
            self.topView.frame = CGRectMake(0, -pianY, self.topView.frame.size.width, self.topView.frame.size.height);
            for (int i = 0; i < self.tableViewArr.count; i++) {
                UITableView *tableView = [self.mainScrollView viewWithTag:tagSubTableView + i];
                if (tableView != object) {
                    [tableView removeObserver:self forKeyPath:@"contentOffset"];
                    tableView.contentOffset = CGPointMake(0, pianY);
                    [tableView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
                }
            }
        }
    }
}

- (void)setIndex:(NSInteger)index {
    self.mainScrollView.contentOffset = CGPointMake(index * self.bounds.size.width, self.mainScrollView.contentOffset.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        NSInteger index = scrollView.contentOffset.x / self.bounds.size.width;
        if (_scrollIndex) {
            _scrollIndex(index);
        }
    }
}

- (void)dealloc {
    for (int i = 0; i < self.tableViewArr.count; i++) {
        UITableView *tableView = [self.mainScrollView viewWithTag:tagSubTableView + i];
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end
