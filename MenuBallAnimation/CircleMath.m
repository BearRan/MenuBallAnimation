//
//  CircleMath.m
//  DropAnimation
//
//  Created by Bear on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CircleMath.h"

@implementation CircleMath

- (instancetype)initWithCenterPoint:(CGPoint)centerPoint radius:(CGFloat)radius inView:(UIView *)inView
{
    self = [super init];
    if (!self) {
        self = nil;
    }
    
    _centerPoint    = centerPoint;
    _radius         = radius;
    _InView         = inView;
    
    return self;
}

@end
