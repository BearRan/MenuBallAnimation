//
//  DropView.h
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropCanvasView.h"
#import "CircleMath.h"
#import "LineMath.h"





@interface TwoLineClass : NSObject

@property (strong, nonatomic) LineMath *lineMath1;
@property (strong, nonatomic) LineMath *lineMath2;

@end






typedef struct {
    CGPoint point1;
    CGPoint point2;
}AcrossPointStruct;

typedef struct {
    CGPoint point1;
    CGPoint point2;
}TwoPointStruct;

typedef enum {
    kQuadrant_First,
    kQuadrant_Second,
    kQuadrant_Third,
    kQuadrant_Fourth,
}kQuadrantArea;

typedef enum {
    kCircleSeparateEntire,          //两圆完全相离
    kCircleSeparateAndConnect,      //两圆相离，但仍然相连
    kCircleSeparateDeformation,     //两圆相离但变形
    kCircleCross,                   //两圆相交
    kCircleContain,                 //两圆内含
}kCirlceRelation;

@interface DropView : UIView

@property (strong, nonatomic) LineMath      *lineCenter2Center; //圆心的连线
@property (strong, nonatomic) CircleMath    *circleMath;        //圆的方程

@property (assign, nonatomic) CGPoint       edge_point1;        //圆心连线的垂线与圆的交点1
@property (assign, nonatomic) CGPoint       edge_point1_left;   //圆心连线的垂线与圆的交点1,贝塞尔绘制点左侧
@property (assign, nonatomic) CGPoint       edge_point1_right;  //圆心连线的垂线与圆的交点1,贝塞尔绘制点右侧
@property (assign, nonatomic) CGPoint       edge_point2;        //圆心连线的垂线与圆的交点2
@property (assign, nonatomic) CGPoint       edge_point2_left;   //圆心连线的垂线与圆的交点2,贝塞尔绘制点左侧
@property (assign, nonatomic) CGPoint       edge_point2_right;  //圆心连线的垂线与圆的交点2,贝塞尔绘制点右侧

@property (assign, nonatomic) CGPoint       bezierControlPoint1;    //贝赛尔曲线控制点1（P3，P4中间）/相交时控制点
@property (assign, nonatomic) CGPoint       bezierControlPoint1_1;  //贝赛尔曲线控制点1（P3，P4中间）
@property (assign, nonatomic) CGPoint       bezierControlPoint1_1C; //贝赛尔曲线控制点1（P3，P4中间,平滑作用）
@property (assign, nonatomic) CGPoint       bezierControlPoint2;    //贝赛尔曲线控制点2（P1，P2中间）/相交时控制点
@property (assign, nonatomic) CGPoint       bezierControlPoint2_1;  //贝赛尔曲线控制点2（P1，P2中间）
@property (assign, nonatomic) CGPoint       bezierControlPoint2_1C; //贝赛尔曲线控制点2（P1，P2中间,平滑作用）

@property (strong, nonatomic) DropView          *smallDrop;
@property (assign, nonatomic) DropCanvasView    *dropSuperView;
@property (assign, nonatomic) kQuadrantArea     smallDropQuadrant;

@property (strong, nonatomic) CAShapeLayer      *dropShapLayer;
@property (strong, nonatomic) UIBezierPath      *bezierPath;
@property (assign, nonatomic) kCirlceRelation   circleRelation;

- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop;

/** 判断点所处象限
 *
 *  centerPoint 作为圆心的点
 *  paraPoint   以centerPoint为坐标原点，判断paraPoint所在的象限
 *
 *  quadrantFirst   第一象限
 *  quadrantSecond  第二象限
 *  quadrantThird   第三象限
 *  quadrantFourth  第四象限
 */
+ (void)eventInDiffQuadrantWithCenterPoint:(CGPoint)centerPoint
                             withParaPoint:(CGPoint)paraPoint
                             quadrantFirst:(void (^)())quadrantFirst
                            quadrantSecond:(void (^)())quadrantSecond
                             quadrantThird:(void (^)())quadrantThird
                            quadrantFourth:(void (^)())quadrantFourth;

+ (BOOL)JudgeEqualWithPoint1:(CGPoint)point1 point2:(CGPoint)point2;

@end
