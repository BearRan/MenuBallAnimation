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

//  提前／延后交叉状态
static CGFloat faultTolerantValue_Inintional = 2.0f;
static CGFloat faultTolerantValue_SmallToSmall = 2.0f;
static CGFloat faultTolerantValue_SmallToMain = 5.0f;


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
    kInitional,                     //初始状态
    kSeparated_SmallToMain,         //小圆和大圆相离
    kCross_SmallToMain,             //小圆和大圆相交
    kCross_SmallToSmall,            //小圆和小圆相交
}kRelation;

typedef enum {
    kSetNull,
    kSetRightPoint,
    kSetLeftPoint,
}kSetCondition;                     //设置左侧／右侧点

@interface DropView : UIView


@property (strong, nonatomic) CircleMath        *circleMath;        //圆的方程
@property (strong, nonatomic) DropView          *smallDrop;
@property (assign, nonatomic) DropCanvasView    *dropSuperView;
@property (assign, nonatomic) kQuadrantArea     smallDropQuadrant;

@property (strong, nonatomic) CAShapeLayer      *dropShapLayer;
@property (strong, nonatomic) UIBezierPath      *bezierPath;
@property (strong, nonatomic) UIColor           *fillColor;
@property (strong, nonatomic) CADisplayLink     *displayLink;
@property (assign, nonatomic) kRelation         relation;
@property (assign, nonatomic) CGPoint           mainCenter;

@property (strong, nonatomic) NSMutableArray    *assisDropArray;
//@property (strong, nonatomic) DropView          *assisDrop1;
//@property (strong, nonatomic) DropView          *assisDrop2;
//@property (strong, nonatomic) DropView          *assisDrop3;
//@property (strong, nonatomic) DropView          *assisDrop4;

@property (assign, nonatomic) CGPoint           crossToMain_Point1;             //和MainDrop的交点1
@property (assign, nonatomic) CGPoint           crossToMain_Point2;             //和MainDrop的交点2
@property (assign, nonatomic) CGPoint           crossToRightAssis_Point;        //和右侧AssisDrop的交点1
@property (assign, nonatomic) CGPoint           crossToRightAssis_PointS;       //和右侧AssisDrop的交点2
@property (assign, nonatomic) CGPoint           crossToRightAssis_PointMain;    //右侧AssisDrop的交点(在Main上)
@property (assign, nonatomic) CGPoint           crossToLeftAssis_Point;         //和左侧AssisDrop的交点1
@property (assign, nonatomic) CGPoint           crossToLeftAssis_PointS;        //和左侧AssisDrop的交点2
@property (assign, nonatomic) CGPoint           crossToLeftAssis_PointMain;     //左侧AssisDrop的交点2(在Main上)

@property (assign, nonatomic) CGPoint           crossToCenterAssis_Point;       //中间AssisDrop的交点(在Small上,和大圆相离的状态专用)
@property (assign, nonatomic) CGPoint           crossToCenterAssis_PointMain;   //中间AssisDrop的交点(在Main上,和大圆相离的状态专用)





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

//  把某点转化成圆上对应的角度
+ (CGFloat)ConvertPointToRadiusInDropView:(DropView *)dropView point:(CGPoint)point canvansView:(UIView *)canvansView;

/** 根据两点和比例计算其他点
 *
 *  point1,point2   两源点
 *  ratio           距两个端点距离占线段总长度的比例
 *  twoPointStruct  最终返回的两点的结构体
 *  注：
 *      ratio小于0的情况下，twoPointStruct.point1在中点和point2之间
 *      ratio等于0的情况下，twoPointStruct.point1为中点
 *      ratio等于1的情况下，twoPointStruct.point1为point1
 *      ratio大于1的情况下，twoPointStruct.point1为超过point1的点
 *      反之亦然
 */
+ (TwoPointStruct)PointBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2 ToPointRatio:(CGFloat)ratio;

@end
