//
//  PointMath.h
//  MenuBallAnimation
//
//  Created by Bear on 16/3/17.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointMath : NSObject

@property (assign, nonatomic) CGPoint   point;
@property (strong, nonatomic) UIView    *InView;

- (instancetype)initWithPoint:(CGPoint)point inView:(UIView *)inView;

@end
