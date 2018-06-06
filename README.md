# ScrollViewNestTableView
* scrollView 里添加 tableView

## 实现原理
最底层是一个 view
view 上方是一个 同 bounds 的 scrollView，contentsize 为 width: 列表数量 * width  height：height
上方依次排列 n 个 tableview
上方 头部视图 是放在 view 上的，随着 tableView 的滑动，改变 frame

## 文件
WXScrollViewNestTableView
CustomSegmentedView

## 方法
```
/**
@param frame scrollView的大小
@param tableViewArr tableview 数组
@param headerView 头部可滑出屏幕部分
@param sectionHeaderView 不可滑出屏幕部分 segmentedView
*/
+ (WXScrollViewNestTableView *)scrollViewNestTableViewWithFrame:(CGRect)frame tableViewArray:(NSArray *)tableViewArr headerView:(UIView *)headerView sectionHeaderView:(UIView *)sectionHeaderView;
```

