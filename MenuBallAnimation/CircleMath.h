//
//  CircleMath.h
//  DropAnimation
//
//  Created by Bear on 16/2/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleMath : NSObject

@property (assign, nonatomic) CGPoint   centerPoint;
@property (assign, nonatomic) CGFloat   radius;
@property (strong, nonatomic) UIView    *InView;

- (instancetype)initWithCenterPoint:(CGPoint)centerPoint radius:(CGFloat)radius inView:(UIView *)inView;

@end
