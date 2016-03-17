//
//  PointMath.m
//  MenuBallAnimation
//
//  Created by Bear on 16/3/17.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import "PointMath.h"

@implementation PointMath

- (instancetype)initWithPoint:(CGPoint)point inView:(UIView *)inView
{
    self = [super init];
    
    if (!self) {
        self = nil;
    }
    
    _point      = point;
    _InView     = inView;
    
    return self;
}

@end
