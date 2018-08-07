# KJMultipleScrollViewManager
微博主页样式解决方案之一、UITableView头部下拉放大、多个UIScrollView在同一页面的管理器

# 使用方法
```
//初始化多视图管理器
self.kjManager = [MultipleScrollViewManager new];
```
使用
```object-c
//把滚动视图交给管理器-主控制器
[self.kjManager addMainView:self.tView];
//把滚动视图交给管理器-子控制器
if (self.sManager) {
   [self.sManager addChildView:self.tView];
}
//如果主控制器有可以左右滑动分页管理器，也可以交给管理器来进行统一管理
[self.kjManager addMainRelevancyPageView:[self.kjPageView valueForKey:@"_scrollView"]];
```
# 具体的介绍
[KJMultipleScrollViewManager详细介绍](https://www.jianshu.com/p/8e6dfb547061)

# 支持pod导入
pod 'KJMultipleScrollViewManager'

# 效果展示
![效果展示](https://github.com/hkjin/KJMultipleScrollViewManager/blob/master/KjMultipleScrollViewDemoEffect180807.gif)
