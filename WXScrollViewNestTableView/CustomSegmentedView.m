//
//  CustomSegmentedView.m
//  iTouzi
//
//  Created by EDZ on 2018/5/24.
//  Copyright © 2018年 itouzi. All rights reserved.
//

#import "CustomSegmentedView.h"

@interface CustomSegmentedView()

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isAnimal;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

const static NSInteger tagBtn = 1000;
@implementation CustomSegmentedView

+ (CustomSegmentedView *)customSegmentedViewWithFrame:(CGRect)frame {
    CustomSegmentedView *customSegmentedView = [[CustomSegmentedView alloc] initWithFrame:frame];
    return customSegmentedView;
}

+ (CustomSegmentedView *)customSegmentedViewWithFrame:(CGRect)frame withDataArr:(NSArray *)arr {
    CustomSegmentedView *customSegmentedView = [self customSegmentedViewWithFrame:frame];
    [customSegmentedView setSubViewWithArray:arr];
    return customSegmentedView;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (void)setSubViewWithArray:(NSArray *)arr {
    for (NSInteger i = self.mainScrollView.subviews.count - 1; i >= 0; i--) {
        [self.mainScrollView.subviews[i] removeFromSuperview];
    }
    CGFloat widthEach = 0;
    for (NSString *titleStr in arr) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = titleStr;
        [label sizeToFit];
        CGFloat f = label.bounds.size.width + 10;
        widthEach = f > widthEach ? f : widthEach;
    }
    NSInteger count = 0;
    if (widthEach * arr.count > self.bounds.size.width) {
        for (int i = 1; i < 10; i++) {
            if ((i + 0.5) * widthEach > self.bounds.size.width) {
                count = i - 1;
                break;
            }
        }
        widthEach = self.bounds.size.width / (count + 0.5);
    } else {
        widthEach = self.bounds.size.width / arr.count;
    }
    self.mainScrollView.contentSize = CGSizeMake(widthEach * arr.count, self.bounds.size.height);
    CGFloat subWidth = widthEach;
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(i * subWidth, 0, subWidth, self.bounds.size.height);
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag = tagBtn + i;
        [self.mainScrollView addSubview:btn];
    }
    self.selectIndex = tagBtn + 1;
    [self setSelectedIndex:0 withAnimal:NO];
}

- (void)btnAction:(UIButton *)sender {
    if (sender.tag == self.selectIndex) return;
    UIButton *btn = [self.mainScrollView viewWithTag:self.selectIndex];
    btn.selected = NO;
    sender.selected = YES;
    CGFloat addScrollWidth = 0;
    if (sender.bounds.origin.x <= self.mainScrollView.contentOffset.x) {
        addScrollWidth = -sender.bounds.size.width / 2.0;
    } else {
        addScrollWidth = sender.bounds.size.width / 2.0;
    }
    [self.mainScrollView scrollRectToVisible:CGRectMake(sender.bounds.origin.x + addScrollWidth, sender.bounds.origin.y, sender.bounds.size.width, sender.bounds.size.height) animated:YES];
    self.selectIndex = sender.tag;
    if (_indexSelectedCompletion) {
        _indexSelectedCompletion(sender.tag - tagBtn, self.isAnimal);
    }
    self.isAnimal = YES;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex withAnimal:(BOOL)isAnimal{
    UIButton *btn = [self.mainScrollView viewWithTag:selectedIndex + tagBtn];
    if (btn) {
        self.isAnimal = isAnimal;
        [self performSelector:@selector(btnAction:) withObject:btn];
    }
}

@end
