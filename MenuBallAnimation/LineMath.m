//
//  LineMath.m
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LineMath.h"

@implementation LineMath

- (instancetype)initWithPoint1:(CGPoint)point1 point2:(CGPoint)point2 inView:(UIView *)inView
{
    self = [super init];
    if (!self) {
        self = nil;
    }
    
    _point1 = point1;
    _point2 = point2;
    _InView = inView;
    
    //  斜率不存在
    if (point2.x == point1.x) {
        _k = -1;
        _b = 0;
        _lineStatus = kLineVertical;
    }else if (point2.y == point1.y){
        _k = -2;
        _b = 0;
        _lineStatus = kLineHorizontal;
    }
    //  斜率存在
    else{
        _k = (point2.y - point1.y) / (point2.x - point1.x);
        _b = point1.y - _k * point1.x;
        _lineStatus = kLineNormal;
    }
    
    return self;
}

/***********************
 角度说明
 第二象限   第一象限
 第三象限   第四象限
 
             90度
             |
             |
             |
             |
 0度  ----------------  180度
             |
 －30或者330  |
             |
             |
             270 度
 
 **************************/
- (void)calucateDegrees
{
    CGFloat tempAngle = atan(_k);
    CGFloat degrees = radiansToDegrees(tempAngle);
    NSLog(@"tempAngle:%f", tempAngle);
    NSLog(@"degrees:%f", degrees);
}

//  计算两点间的距离
+ (CGFloat)calucateDistanceBetweenPoint1:(CGPoint)point1 withPoint2:(CGPoint)point2
{
    CGFloat x_dx    = (point2.x - point1.x);
    CGFloat X_DX2   = x_dx * x_dx;
    CGFloat y_dy    = (point2.y - point1.y);
    CGFloat Y_DY2   = y_dy * y_dy;
    CGFloat distance = sqrt(X_DX2 + Y_DY2);
    
    return distance;
}

//  计算任意两点和某一点距离更近的点
+ (CGPoint)calucateNearPointWithOriginPoint:(CGPoint)originPoint point1:(CGPoint)point1 point2:(CGPoint)point2
{
    
    CGFloat pointDis1 = [LineMath calucateDistanceBetweenPoint1:originPoint withPoint2:point1];
    CGFloat pointDis2 = [LineMath calucateDistanceBetweenPoint1:originPoint withPoint2:point2];
    
    if (pointDis1 < pointDis2) {
        
        return point1;
    }else if(pointDis2 < pointDis1){
        
        return point2;
    }else{
        
        NSLog(@"计算任意两点和某一点距离更近的点 方法发生错误");
        return CGPointMake(0, 0);
    }
}

//  计算两条线的交点
+ (CGPoint)calucateAcrossPointBetweenLine1:(LineMath *)line1 withLine2:(LineMath *)line2
{
    CGFloat b1 = line1.b;
    CGFloat k1 = line1.k;
    CGFloat b2 = line2.b;
    CGFloat k2 = line2.k;
    CGFloat acrossY = (k2 * b1 - k1 * b2) / (k2 - k1);
    CGFloat acrossX = (acrossY - b1) / k1;
    CGPoint acrossPoint = CGPointMake(acrossX, acrossY);
    
    return acrossPoint;
}

//  计算两点的中点
+ (CGPoint)calucateCenterPointBetweenPoint1:(CGPoint)point1 withPoint2:(CGPoint)point2
{
    CGPoint centerPoint = CGPointMake((point1.x + point2.x)/2, (point1.y + point2.y)/2);
    
    return centerPoint;
}



@end
