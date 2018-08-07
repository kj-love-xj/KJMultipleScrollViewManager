//
//  MultipleGestureTableView.m
//  Join
//
//  Created by JOIN iOS on 2018/5/14.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import "MultipleGestureTableView.h"

@implementation MultipleGestureTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**允许多个手势共同识别*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
