//
//  ViewController.m
//  WXScrollViewNestTableView
//
//  Created by EDZ on 2018/5/23.
//  Copyright © 2018年 wangxiaoxuan. All rights reserved.
//

#import "ViewController.h"
#import "WXScrollViewNestTableView.h"
#import "CustomSegmentedView.h"

#define MainTableViewCell @"MainTableViewCell"
#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupView];
}

- (void)p_setupView {
    // tableView 数组
    NSMutableArray *tableViewArr = @[].mutableCopy;
    for (int i = 0; i < 4; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MainTableViewCell];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableViewArr addObject:tableView];
    }
    
    // 头部 可完全滑出屏幕部分
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    headerView.backgroundColor = [UIColor yellowColor];
    
    // 头部 segment 定位到导航栏下方部分
    NSArray *listArray = @[@"1", @"2", @"3", @"4"];
    CustomSegmentedView *customSegmentedView = [CustomSegmentedView customSegmentedViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40) withDataArr:listArray];
    customSegmentedView.backgroundColor = [UIColor grayColor];
    
    // 底部 scrollView 包含的 n 个 tableview 列表 view
    WXScrollViewNestTableView *scrollViewNestTableView = [WXScrollViewNestTableView scrollViewNestTableViewWithFrame:CGRectMake(0, StatusBarHeight + 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - StatusBarHeight - 44) tableViewArray:tableViewArr headerView:headerView sectionHeaderView:customSegmentedView];
    [self.view addSubview:scrollViewNestTableView];
    
    // 滑动 scrollView 切换
    scrollViewNestTableView.scrollIndex = ^(NSInteger index) {
        [customSegmentedView setSelectedIndex:index withAnimal:NO];
    };
    
    // 点击 segmentedView 切换
    customSegmentedView.indexSelectedCompletion = ^(NSInteger selectedIndex, BOOL isAnimal) {
        NSLog(@"%ld", selectedIndex);
        CGFloat time = 0;
        if (isAnimal) {
            time = 0.25;
        }
        [UIView animateWithDuration:time animations:^{
            [scrollViewNestTableView setIndex:selectedIndex];
        } completion:nil];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainTableViewCell];
    cell.textLabel.text = @"标题";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
