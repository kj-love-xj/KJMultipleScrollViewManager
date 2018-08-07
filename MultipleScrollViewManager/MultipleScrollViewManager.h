//
//  MultipleScrollViewManager.h
//  Join
//
//  Created by JOIN iOS on 2018/5/14.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MultipleScrollViewManager : NSObject

/**设置主控制器关联的UIScrollView滑动到多少时，子控制器才允许滑动，
 如果不设置或者<=0，则默认主控制器关联的UIScrollView滑动到底部时子控制器开始滑动*/
@property (assign, nonatomic) CGFloat mainOffsetY;

/**销毁 移除观察者*/
- (void)kjMultipleManagerDealloc;

/**
 告知子控制器关联的UIScrollView
 
 @param sView UIScrollView
 */
- (void)addChildView:(UIScrollView *)sView ;


/**
 告知主控制器关联的UIScrollView
 
 @param sView UIScrollView
 */
- (void)addMainView:(UIScrollView *)sView;

/**
 告知主控制器中的分页控制器，解决分页控制器和主控制器的UIScrollView同时滑动的问题
 
 @param sView 分页控制器的UIScrollView
 */
- (void)addMainRelevancyPageView:(UIScrollView *)sView;

// 判断是否显示滚动条，只需要在主控制器设置即可，子控制器不用设置 yes-不显示 NO-显示
@property (assign, nonatomic) BOOL scrollIndicator;

@end

