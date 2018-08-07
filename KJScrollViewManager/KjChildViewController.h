//
//  KjChildViewController.h
//  KJScrollViewManager
//
//  Created by JOIN iOS on 2018/8/7.
//  Copyright © 2018年 Kegem. All rights reserved.
//

#import <UIKit/UIKit.h>
/**管理器*/
#import "MultipleScrollViewManager.h"

@interface KjChildViewController : UIViewController

/**子控制器该属性由主控制器传值过来*/
@property (strong, nonatomic) MultipleScrollViewManager *sManager;

@end
