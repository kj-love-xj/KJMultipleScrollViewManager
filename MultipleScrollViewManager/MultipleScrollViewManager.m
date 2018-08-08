//
//  MultipleScrollViewManager.m
//  Join
//
//  Created by JOIN iOS on 2018/5/14.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import "MultipleScrollViewManager.h"

@interface MultipleScrollViewManager ()

/**主view*/
@property (strong, nonatomic) UIScrollView *mainView;
/**主view 滑动状态记录 初始状态是YES，即表示可以滑动*/
@property (assign, nonatomic) BOOL if_mainV_scroll;
/**子view*/
@property (strong, nonatomic) NSMutableArray *childArray;
/**主控制器中的分页控制器*/
@property (strong, nonatomic) UIScrollView *pageView;


@end

@implementation MultipleScrollViewManager

/**销毁 移除观察者*/
- (void)kjMultipleManagerDealloc {
    @try {
        for (UIScrollView *sView in self.childArray) {
            [sView removeObserver:self forKeyPath:@"contentOffset"];
        }
        
        if (self.mainView) {
            [self.mainView removeObserver:self forKeyPath:@"contentOffset"];
            [self.mainView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
        }
        
        if (self.pageView) {
            [self.pageView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
        }
    } @catch (NSException *exception) {
    } @finally {
    }
}

/**
 告知子控制器关联的UIScrollView

 @param sView UIScrollView
 */
- (void)addChildView:(UIScrollView *)sView {
    if (!self.childArray) {
        self.childArray = [NSMutableArray arrayWithCapacity:0];
    }
    NSUInteger index = [self.childArray indexOfObject:sView];
    if (index != NSNotFound) {
        //移除
        @try {
            [sView removeObserver:self forKeyPath:@"contentOffset"];
        } @catch (NSException *exception) {
        } @finally {
            [self.childArray removeObject:sView];
        }
    }
    
    [self.childArray addObject:sView];
    //监听偏移量的变化
    [sView addObserver:self
            forKeyPath:@"contentOffset"
               options:NSKeyValueObservingOptionNew
               context:nil];
}


/**
 告知关联主控制器的UIScrollView

 @param sView UIScrollView
 */
- (void)addMainView:(UIScrollView *)sView  {
    
    if (self.mainView) {
        //移除观察者
        @try {
            [sView removeObserver:self forKeyPath:@"contentOffset"];
            [sView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
        } @catch (NSException *exception) {
        } @finally {
        }
    }
    
    self.mainView = sView;
    self.if_mainV_scroll = YES;

    //监听偏移量的变化
    [sView addObserver:self
            forKeyPath:@"contentOffset"
               options:NSKeyValueObservingOptionNew
               context:nil];
    //监听手势状态变化
    [sView addObserver:self
            forKeyPath:@"panGestureRecognizer.state"
               options:NSKeyValueObservingOptionNew
               context:nil];
}


/**
 告知主控制器中的分页控制器，解决分页控制器和主控制器的UIScrollView同时滑动的问题

 @param sView 分页控制器的UIScrollView
 */
- (void)addMainRelevancyPageView:(UIScrollView *)sView {
    if (sView) {
        if (self.pageView) {
            //防止重复传入，重复监听，当有时，则删除监察者
            @try {
                [self.pageView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
            } @catch (NSException *exception) {
            } @finally {
            }
        }
        
        self.pageView = sView;
        //监听手势状态变化
        [sView addObserver:self
                forKeyPath:@"panGestureRecognizer.state"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    }
}

/**观察者事件*/
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if (object == self.pageView) {//主控制器中关联的分页管理器
        if (self.pageView.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            self.mainView.scrollEnabled = NO;
        } else {
            self.mainView.scrollEnabled = YES;
        }
    } else if (object == self.mainView) {//主控制器中的UIScrollView
        if ([keyPath isEqualToString:@"panGestureRecognizer.state"]) {
            if (self.pageView) {
                if ([change[NSKeyValueChangeNewKey] integerValue] == UIGestureRecognizerStateChanged) {
                    self.pageView.scrollEnabled = NO;
                } else {
                    self.pageView.scrollEnabled = YES;
                }
            }
        }
        else if ([keyPath isEqualToString:@"contentOffset"] && self.mainView.scrollEnabled) {
            CGFloat vHeight = self.mainView.frame.size.height;
            if (self.if_mainV_scroll) {
                //获取主控制器中sView的偏移量
                CGPoint point = [change[NSKeyValueChangeNewKey] CGPointValue];
                //判断是否滑动到允许子控制器滑动的位置
                BOOL isBottom = self.mainView.contentSize.height - point.y <= vHeight;
                if (self.mainOffsetY > 0) {//为了支持由外部设置偏移量决定子控制器何时允许滑动
                    isBottom = point.y >= self.mainOffsetY;
                }
                if (isBottom) {
                    self.if_mainV_scroll = NO;
                    self.mainView.showsVerticalScrollIndicator = NO;
                    //滑动到指定的位置，让自己不能滑动，并让子控制器可以滑动
                    CGFloat offsetY = self.mainOffsetY > 0 ? self.mainOffsetY : self.mainView.contentSize.height - vHeight;
                    [self.mainView setContentOffset:CGPointMake(0, offsetY)];
                    for (UIScrollView *tmpView in self.childArray) {
                        tmpView.showsVerticalScrollIndicator = !self.scrollIndicator;
                    }
                }
            } else {
                //主控制器不允许滑动
                CGFloat offsetY = self.mainOffsetY > 0 ? self.mainOffsetY : self.mainView.contentSize.height - vHeight;
                if (self.mainView.contentOffset.y != offsetY) {
                    [self.mainView setContentOffset:CGPointMake(0, offsetY) animated:NO];
                }
            }
        }
    } else {//子控制器中的UIScrollView
        UIScrollView *sView = object;
        if ([keyPath isEqualToString:@"contentOffset"]) {
            if (self.if_mainV_scroll) {
                //当主控制器可以滑动的时候，子控制器不允许滑动
                if (sView.contentOffset.y != 0) {
                    [sView setContentOffset:CGPointZero];
                }
            } else {
                //子控制器的sView偏移量有变化
                CGPoint point = [change[NSKeyValueChangeNewKey] CGPointValue];
                //decelerating用于判断手指是否离开屏幕，YES表示手指已离开屏幕，这里当手指离开屏幕时if_mainV_scroll状态不变化
                if (point.y < 0 && !sView.decelerating) {
                    //当子控制器滑动到顶部后 ，让主控制器可以滑动
                    self.if_mainV_scroll = YES;
                    self.mainView.showsVerticalScrollIndicator = !self.scrollIndicator;
                    for (UIScrollView *tmpView in self.childArray) {
                        //当主控制器可以滑动时，子控制器自动回到顶部
                        if (tmpView.contentOffset.y != 0) {
                            [tmpView setContentOffset:CGPointZero];
                        }
                        tmpView.showsVerticalScrollIndicator =  NO;
                    }
                }
            }
        }
    }
}


@end


