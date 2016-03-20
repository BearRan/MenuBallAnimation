//
//  DropView.m
//  DropAnimation
//
//  Created by apple on 16/2/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropView.h"
#import "PointMath.h"



@implementation TwoLineClass

- (instancetype)initWithTwoLineMath_line1:(LineMath *)line1 line2:(LineMath *)line2
{
    self = [super init];
    if (!self) {
        self = nil;
    }
    
    _lineMath1 = line1;
    _lineMath2 = line2;
    
    return self;
}

@end










@interface DropView()

@property (strong, nonatomic) CADisplayLink *displayLink;

@end



@implementation DropView

- (instancetype)initWithFrame:(CGRect)frame createSmallDrop:(BOOL)createSmallDrop
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    [self createDropView];
    
    if (createSmallDrop == YES) {
        [self createSmallDropView];
        [self createPanGesture];
    }
    
    return self;
}

- (void)createDropView
{
    self.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
    self.layer.cornerRadius = self.width/2;
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    
    _circleMath = [[CircleMath alloc] initWithCenterPoint:CGPointMake(self.width/2, self.height/2) radius:self.width/2 inView:self];
    
    _bezierPath = [UIBezierPath bezierPath];
    
    _dropShapLayer = [CAShapeLayer layer];
    _dropShapLayer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.4].CGColor;
    _dropShapLayer.lineWidth = 2.0f;
    _dropShapLayer.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    _dropShapLayer.strokeStart = 0;
    _dropShapLayer.strokeEnd = 1;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calucateCoordinate)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink.paused = YES;
}

- (void)createSmallDropView
{
    CGFloat smallDrop_width = 80;
    _smallDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, smallDrop_width, smallDrop_width) createSmallDrop:NO];
    _smallDrop.layer.cornerRadius = smallDrop_width/2;
    _smallDrop.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    [self addSubview:_smallDrop];
    [_smallDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)createPanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture_Event:)];
    [self addGestureRecognizer:panGesture];
}

- (void)panGesture_Event:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint tempPoint = [panGesture locationInView:self];
        _smallDrop.center = tempPoint;
        [self calucateCoordinate];
    }
    else if(panGesture.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:0.3
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [_smallDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
                             _displayLink.paused = NO;
                         }
                         completion:^(BOOL finished) {
                             _displayLink.paused = YES;
                         }];
    }
}

//  计算坐标
- (void)calucateCoordinate
{
    [_dropSuperView.assisArray removeAllObjects];
    
    
    PointMath *mainCenterPoint = [[PointMath alloc] initWithPoint:CGPointMake(self.width/2, self.height/2) inView:self];
    [_dropSuperView.assisArray addObject:mainCenterPoint];
    
    PointMath *smallCenterPoint = [[PointMath alloc] initWithPoint:_smallDrop.center inView:self];
    [_dropSuperView.assisArray addObject:smallCenterPoint];
    
    
    //  两点间的连线
    CALayer *smallDrop_layer = _smallDrop.layer.presentationLayer;
    _lineCenter2Center = [[LineMath alloc] initWithPoint1:_circleMath.centerPoint point2:smallDrop_layer.position inView:self];
//    [_dropSuperView.assisArray addObject:_lineCenter2Center];
    
    
    CGPoint mainDrop_center = CGPointMake(self.width/2, self.height/2);
    CGPoint smallDrop_center = smallDrop_layer.position;
    //  第一象限
    if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y > smallDrop_center.y) {
        _smallDropQuadrant = kQuadrant_First;
    }
    //  第二象限
    else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y > smallDrop_center.y){
        _smallDropQuadrant = kQuadrant_Second;
    }
    //  第三象限
    else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
        _smallDropQuadrant = kQuadrant_Third;
    }
    //  第四象限
    else if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
        _smallDropQuadrant = kQuadrant_Fourth;
    }
    
    
    
    
    TwoLineClass *twoTangentLine = [self calucateTangentLine_mainDrop:self smallDrop:_smallDrop];
    LineMath *line_Tangent1 = twoTangentLine.lineMath1;
    LineMath *line_Tangent2 = twoTangentLine.lineMath2;
    
    
    //  经过大圆圆心的线，并与切线1垂直
    LineMath *line_Tangent1_PerBiseToMainDrop = [[LineMath alloc] init];
    CGFloat angle_Tangent1_PerBiseToMainDrop = atan(line_Tangent1.k);
    angle_Tangent1_PerBiseToMainDrop += M_PI/2;
    if (angle_Tangent1_PerBiseToMainDrop > M_PI) {
        angle_Tangent1_PerBiseToMainDrop -= M_PI;
    }else if (angle_Tangent1_PerBiseToMainDrop < - M_PI){
        angle_Tangent1_PerBiseToMainDrop += M_PI;
    }
    line_Tangent1_PerBiseToMainDrop.k = tan(angle_Tangent1_PerBiseToMainDrop);
    line_Tangent1_PerBiseToMainDrop.b = _circleMath.centerPoint.y - line_Tangent1_PerBiseToMainDrop.k * _circleMath.centerPoint.x;
    
    AcrossPointStruct acrossPointStruct_Tangent1_PerBiseToMainDrop = [self calucateCircleAndLineAcrossPoint_withCircle:_circleMath withLine:line_Tangent1_PerBiseToMainDrop];
    LineMath *tempLine1 = [[LineMath alloc] initWithPoint1:acrossPointStruct_Tangent1_PerBiseToMainDrop.point1 point2:_circleMath.centerPoint inView:self];
    [_dropSuperView.assisArray addObject:tempLine1];
    
    //  经过小圆圆心的线，并与切线1垂直
    LineMath *line_Tangent1_PerBiseToSmallDrop = [[LineMath alloc] init];
    CGFloat angle_Tangent1_PerBiseToSmallDrop = atan(line_Tangent1.k);
    angle_Tangent1_PerBiseToSmallDrop += M_PI/2;
    if (angle_Tangent1_PerBiseToSmallDrop > M_PI) {
        angle_Tangent1_PerBiseToSmallDrop -= M_PI;
    }else if (angle_Tangent1_PerBiseToSmallDrop < - M_PI){
        angle_Tangent1_PerBiseToSmallDrop += M_PI;
    }
    line_Tangent1_PerBiseToSmallDrop.k = tan(angle_Tangent1_PerBiseToSmallDrop);
    line_Tangent1_PerBiseToSmallDrop.b = smallDrop_layer.position.y - line_Tangent1_PerBiseToSmallDrop.k * smallDrop_layer.position.x;
    
    AcrossPointStruct acrossPointStruct_Tangent1_PerBiseToSmallDrop = [self calucateCircleAndLineAcrossPoint_withCircle:_smallDrop.circleMath withLine:line_Tangent1_PerBiseToSmallDrop];
    
    
    //  经过大圆圆心的线，并与切线2垂直
    LineMath *line_Tangent2_PerBiseToMainDrop = [[LineMath alloc] init];
    CGFloat angle_Tangent2_PerBiseToMainDrop = atan(line_Tangent2.k);
    angle_Tangent2_PerBiseToMainDrop += M_PI/2;
    if (angle_Tangent2_PerBiseToMainDrop > M_PI) {
        angle_Tangent2_PerBiseToMainDrop -= M_PI;
    }else if (angle_Tangent2_PerBiseToMainDrop < - M_PI){
        angle_Tangent2_PerBiseToMainDrop += M_PI;
    }
    line_Tangent2_PerBiseToMainDrop.k = tan(angle_Tangent2_PerBiseToMainDrop);
    line_Tangent2_PerBiseToMainDrop.b = _circleMath.centerPoint.y - line_Tangent2_PerBiseToMainDrop.k * _circleMath.centerPoint.x;
    
    AcrossPointStruct acrossPointStruct_Tangent2_PerBiseToMainDrop = [self calucateCircleAndLineAcrossPoint_withCircle:_circleMath withLine:line_Tangent2_PerBiseToMainDrop];
    LineMath *tempLine3 = [[LineMath alloc] initWithPoint1:acrossPointStruct_Tangent2_PerBiseToMainDrop.point2 point2:_circleMath.centerPoint inView:self];
    [_dropSuperView.assisArray addObject:tempLine3];
    
    //  经过小圆圆心的线，并与切线2垂直
    LineMath *line_Tangent2_PerBiseToSmallDrop = [[LineMath alloc] init];
    CGFloat angle_Tangent2_PerBiseToSmallDrop = atan(line_Tangent2.k);
    angle_Tangent2_PerBiseToSmallDrop += M_PI/2;
    if (angle_Tangent2_PerBiseToSmallDrop > M_PI) {
        angle_Tangent2_PerBiseToSmallDrop -= M_PI;
    }else if (angle_Tangent2_PerBiseToSmallDrop < - M_PI){
        angle_Tangent2_PerBiseToSmallDrop += M_PI;
    }
    line_Tangent2_PerBiseToSmallDrop.k = tan(angle_Tangent2_PerBiseToSmallDrop);
    line_Tangent2_PerBiseToSmallDrop.b = smallDrop_layer.position.y - line_Tangent2_PerBiseToSmallDrop.k * smallDrop_layer.position.x;
    
    AcrossPointStruct acrossPointStruct_Tangent2_PerBiseToSmallDrop = [self calucateCircleAndLineAcrossPoint_withCircle:_smallDrop.circleMath withLine:line_Tangent2_PerBiseToSmallDrop];
    
    
    
    //  两圆心的距离
    CGFloat centerPointDistance = [LineMath calucateDistanceBetweenPoint1:_circleMath.centerPoint withPoint2:smallDrop_layer.position];
    CGFloat mainRadius = _circleMath.radius;
    CGFloat smallRadius = _smallDrop.circleMath.radius;
    
    //  两圆相离
    if (centerPointDistance > _circleMath.radius + _smallDrop.circleMath.radius) {
        
        /******     计算贝赛尔需要的交点      ******/
        CGPoint point1 = acrossPointStruct_Tangent1_PerBiseToSmallDrop.point1;
        CGPoint point2 = acrossPointStruct_Tangent1_PerBiseToMainDrop.point1;
        CGPoint point3 = acrossPointStruct_Tangent2_PerBiseToSmallDrop.point2;
        CGPoint point4 = acrossPointStruct_Tangent2_PerBiseToMainDrop.point2;
        CGPoint point_2_4Center = [LineMath calucateCenterPointBetweenPoint1:point2 withPoint2:point4];
        CGPoint point_1_3Center = [LineMath calucateCenterPointBetweenPoint1:point1 withPoint2:point3];
        
        LineMath *line_P1_P4 = [[LineMath alloc] initWithPoint1:point1 point2:point4 inView:self];
        LineMath *line_P2_P3 = [[LineMath alloc] initWithPoint1:point2 point2:point3 inView:self];
        LineMath *line_P3_P2_4Center = [[LineMath alloc] initWithPoint1:point3 point2:point_2_4Center inView:self];
        LineMath *line_P1_P2_4Center = [[LineMath alloc] initWithPoint1:point1 point2:point_2_4Center inView:self];
        
        [_dropSuperView.assisArray addObject:line_P1_P4];
        [_dropSuperView.assisArray addObject:line_P2_P3];
        [_dropSuperView.assisArray addObject:line_P3_P2_4Center];
        [_dropSuperView.assisArray addObject:line_P1_P2_4Center];
        
        //  源计算出的控制点
        _bezierControlPoint1 = [LineMath calucateAcrossPointBetweenLine1:line_P1_P4 withLine2:line_P3_P2_4Center];
        _bezierControlPoint2 = [LineMath calucateAcrossPointBetweenLine1:line_P2_P3 withLine2:line_P1_P2_4Center];
        _edge_point1 = point2;
        _edge_point2 = point4;
        _smallDrop.edge_point1 = point1;
        _smallDrop.edge_point2 = point3;
        
        //  controlPointReduceRatio 控制点缩小比例
        //  radiusAll               大圆半径＋小圆半径
        //  twoControlPointDistance 两控制点距离
        //  startReduceDistance     开始减小控制点距离的阈值（该值为两圆心距离所用）
        //  deltaCenterDistance     两圆心距离和阈值距离测差值（为负值时开始减小距离）
        //  distanceRatio           间距比例
        CGFloat controlPointReduceRatio = 0.005;
        CGFloat radiusAll = _circleMath.radius + _smallDrop.circleMath.radius;
        CGFloat twoControlPointDistance = [LineMath calucateDistanceBetweenPoint1:_bezierControlPoint1 withPoint2:_bezierControlPoint2];
        CGFloat startReduceDistance = radiusAll * 0.8f;
        CGFloat deltaCenterDistance = startReduceDistance - centerPointDistance;
        CGFloat distanceRatio = deltaCenterDistance/startReduceDistance;
        
        BOOL res1 = deltaCenterDistance < 0;
        BOOL res2 = twoControlPointDistance > 5;
        NSLog(@"tempRatio:%f", distanceRatio);
        
        
        
        //  贝塞尔曲线变细
        if (res1 && res2) {
            
            NSLog(@"断开");
            _circleRelation = kCircleSeparateEntire;
            //  两圆开始分开，变形
            if (distanceRatio < -2.5) {
                distanceRatio = -2.5;
                _circleRelation = kCircleSeparateDeformation;
                
                
            }
            
            TwoPointStruct twoPointStruct = [DropView PointBetweenPoint1:_bezierControlPoint1 point2:_bezierControlPoint2 ToPointRatio:distanceRatio];
            _bezierControlPoint1 = twoPointStruct.point1;
            _bezierControlPoint2 = twoPointStruct.point2;
        }else{
            
            NSLog(@"相离但未断开");
            _circleRelation = kCircleSeparateDeformation;
        }
        
        //  DropView和贝塞尔曲线衔接平滑曲线 控制点
        [self SetBezierSmoothControlPointWithDropView:self withAssisLine:line_P1_P4 withStartPoint:point4];
        [self SetBezierSmoothControlPointWithDropView:self withAssisLine:line_P2_P3 withStartPoint:point2];
        [self SetBezierSmoothControlPointWithDropView:_smallDrop withAssisLine:line_P1_P4 withStartPoint:point1];
        [self SetBezierSmoothControlPointWithDropView:_smallDrop withAssisLine:line_P2_P3 withStartPoint:point3];
        
    }
    
    //  两圆内含
    else if (centerPointDistance < mainRadius - smallRadius)
    {
        NSLog(@"内含");
        _circleRelation = kCircleContain;
    }
    //  两圆相交
    else if (centerPointDistance > mainRadius - smallRadius && centerPointDistance < mainRadius + smallRadius)
    {
        NSLog(@"相交");
        _circleRelation = kCircleCross;
        [self calucateCircleWithCircleAcrossPoint];
    }
    
    [_dropSuperView setNeedsDisplay];
}



/** 计算两圆的切线
 *
 *  两圆中心连线和切线的交点
 *  r1  小圆半径
 *  r2  大圆半径
 *  d2  大圆和小圆中心的距离
 *  d1  小圆中心和切线交点的距离
 *
 *
 *
 *
 */
- (TwoLineClass *)calucateTangentLine_mainDrop:(DropView *)mainDrop smallDrop:(DropView *)smallDrop
{
    CGFloat r1 = smallDrop.circleMath.radius;
    CGFloat r2 = mainDrop.circleMath.radius;
    CALayer *smallDrop_layer = smallDrop.layer.presentationLayer;
    CGFloat d2 = [LineMath calucateDistanceBetweenPoint1:mainDrop.circleMath.centerPoint withPoint2:smallDrop_layer.position];
    CGFloat d1 = (r1 * d2) / (r2 - r1);
    
    
    /******     大圆圆心到_lineCenter2Center和切线交点的连线     ******/
    
    CircleMath *tempCircle = [[CircleMath alloc] initWithCenterPoint:_circleMath.centerPoint
                                                              radius:(d2 + d1)
                                                              inView:self];
    AcrossPointStruct acrossPointStruct = [self calucateCircleAndLineAcrossPoint_withCircle:tempCircle withLine:_lineCenter2Center];
    
    //  _lineCenter2Center和两圆切线的交点
    __block CGPoint acrossPoint;
    [DropView eventInDiffQuadrantWithCenterPoint:_circleMath.centerPoint
                                   withParaPoint:smallDrop_layer.position
                                   quadrantFirst:^{
                                       acrossPoint = acrossPointStruct.point1;
                                   } quadrantSecond:^{
                                       acrossPoint = acrossPointStruct.point2;
                                   } quadrantThird:^{
                                       acrossPoint = acrossPointStruct.point1;
                                   } quadrantFourth:^{
                                       acrossPoint = acrossPointStruct.point2;
                                   }];
    
    //  大圆圆心到_lineCenter2Center和切线交点的连线
    LineMath *line1  = [[LineMath alloc] initWithPoint1:_circleMath.centerPoint point2:acrossPoint inView:self];
    [_dropSuperView.assisArray addObject:line1];
    
    
    /******     两圆的切线       ******/
    
    CGFloat angle = atan(_lineCenter2Center.k);
    CGFloat angleDelta = atan(r1 / d1);
    
    
    /*** 切线1 ***/
    CGFloat angle_TangentLine1 = angle - angleDelta;
    LineMath *line_Tangent1 = [[LineMath alloc] init];
    line_Tangent1.k = tan(angle_TangentLine1);
    line_Tangent1.b = acrossPoint.y - line_Tangent1.k * acrossPoint.x;
    
    AcrossPointStruct acrossPointStruct_Tangent1 = [self calucateCircleAndLineAcrossPoint_withCircle:_circleMath withLine:line_Tangent1];
    line_Tangent1.point1 = acrossPoint;
    line_Tangent1.point2 = acrossPointStruct_Tangent1.point1;
    line_Tangent1.InView = self;
    
    
    /*** 切线2 ***/
    CGFloat angle_TangentLine2 = angle + angleDelta;
    LineMath *line_Tangent2 = [[LineMath alloc] init];
    line_Tangent2.k = tan(angle_TangentLine2);
    line_Tangent2.b = acrossPoint.y - line_Tangent2.k * acrossPoint.x;
    
    AcrossPointStruct acrossPointStruct_Tangent2 = [self calucateCircleAndLineAcrossPoint_withCircle:_circleMath withLine:line_Tangent2];
    line_Tangent2.point1 = acrossPoint;
    line_Tangent2.point2 = acrossPointStruct_Tangent2.point1;
    line_Tangent2.InView = self;
    
    
    [_dropSuperView.assisArray addObject:line_Tangent1];
    [_dropSuperView.assisArray addObject:line_Tangent2];
    
    TwoLineClass *twoLineClass = [[TwoLineClass alloc] initWithTwoLineMath_line1:line_Tangent1 line2:line_Tangent2];
    return twoLineClass;
}


//  绘制园与贝塞尔曲线交接的平滑控制点
- (void)SetBezierSmoothControlPointWithDropView:(DropView *)dropView
                                  withAssisLine:(LineMath *)assisLine
                                 withStartPoint:(CGPoint)startPoint
{
    //  两圆切点，对角的切点连线L1和圆的交点acrossPoint
    CGPoint acrossPoint;
    AcrossPointStruct acrossPointStruct = [self calucateCircleAndLineAcrossPoint_withCircle:dropView.circleMath withLine:assisLine];
    if ([DropView JudgeEqualWithPoint1:acrossPointStruct.point1 point2:startPoint]) {
        acrossPoint = acrossPointStruct.point2;
    }else{
        acrossPoint = acrossPointStruct.point1;
    }
    
//    PointMath *pointMath = [[PointMath alloc] initWithPoint:acrossPoint inView:self];
//    [_dropSuperView.assisArray addObject:pointMath];
    
    
    //  交点acrossPoint和L1的垂直平分线linePerBase
    LineMath *linePerBase = [self PerBaseLine_Point1:acrossPoint Point2:startPoint];
    AcrossPointStruct acrossPointStruct2 = [self calucateCircleAndLineAcrossPoint_withCircle:dropView.circleMath withLine:linePerBase];
    
    LineMath *tempLine = [[LineMath alloc] initWithPoint1:acrossPointStruct2.point1 point2:acrossPointStruct2.point2 inView:self];
    [_dropSuperView.assisArray addObject:tempLine];
    
    
    //  直线linePerBase和Circle的交点acrossPoint2
    CGPoint acrossPoint2;
    CGPoint centerPoint = [LineMath calucateCenterPointBetweenPoint1:acrossPoint withPoint2:startPoint];
    CGFloat distance1 = [LineMath calucateDistanceBetweenPoint1:acrossPointStruct2.point1 withPoint2:centerPoint];
    CGFloat distance2 = [LineMath calucateDistanceBetweenPoint1:acrossPointStruct2.point2 withPoint2:centerPoint];
    if (distance1 < distance2) {
        acrossPoint2 = acrossPointStruct2.point1;
    }else{
        acrossPoint2 = acrossPointStruct2.point2;
    }
    
//    PointMath *acrossPoint2_Math = [[PointMath alloc] initWithPoint:acrossPoint2 inView:self];
//    [_dropSuperView.assisArray addObject:acrossPoint2_Math];
    
    
    //  将计算出的控制贝塞尔点赋值给本类
    if ([DropView JudgeEqualWithPoint1:dropView.edge_point1 point2:startPoint])
    {
        dropView.bezierControlPoint1_1 = acrossPoint;
        dropView.bezierControlPoint1_1C = acrossPoint2;
    }
    else if ([DropView JudgeEqualWithPoint1:dropView.edge_point2 point2:startPoint])
    {
        dropView.bezierControlPoint2_1 = acrossPoint;
        dropView.bezierControlPoint2_1C = acrossPoint2;
    }
    else
    {
        return;
    }
}

//  计算圆心连线的垂线与圆的交点1,贝塞尔绘制点两侧（edge_point1_left，edge_point1_right）
- (AcrossPointStruct)calucateEdgePoint_LeftANDRight_WithCircleMath:(CircleMath *)circleMath withOriginLine:(LineMath *)line needPoint1:(BOOL)needPoint1
{
    //  设定一个指定半径的圆，并且求line和该圆的交点acrossPoint
    CGPoint centerPoint;
    centerPoint = [self convertPoint:circleMath.centerPoint fromView:circleMath.InView];
    
    CGFloat deltaRadiusRatio = 0.2;
    CircleMath *tempCircle = [[CircleMath alloc] initWithCenterPoint:centerPoint radius:circleMath.radius * (1 - deltaRadiusRatio) inView:self];
    AcrossPointStruct acrossPointStruct = [self calucateCircleAndLineAcrossPoint_withCircle:tempCircle withLine:line];
    
    CGPoint acrossPoint;
//    CGFloat x0 = ABS(line.point1.x);
//    CGFloat y0 = ABS(line.point1.y);
//    CGFloat x1 = ABS(line.point2.x);
//    CGFloat y1 = ABS(line.point2.y);
//    if (ABS(acrossPointStruct.point1.x) * 2 < (x0 + x1) && ABS(acrossPointStruct.point1.y) * 2 < (y0 + y1)) {
//        acrossPoint = acrossPointStruct.point1;
//    }
//    else if (ABS(acrossPointStruct.point2.x) * 2 < (x0 + x1) && ABS(acrossPointStruct.point2.y) * 2 < (y0 + y1)) {
//        acrossPoint = acrossPointStruct.point2;
//    }
    
    if (needPoint1 == YES) {
        acrossPoint = acrossPointStruct.point1;
    }else{
        acrossPoint = acrossPointStruct.point2;
    }
    
    //  计算经过点acrossPoint并且和line垂直的线perBiseLine
    LineMath *perBiseLine = [[LineMath alloc] init];
    CGFloat angle = atan(line.k);
    angle += M_PI/2;
    if (angle > M_PI/2) {
        angle -= M_PI;
    }else if (angle < - M_PI/2){
        angle += M_PI;
    }
    perBiseLine.k = tan(angle);
    perBiseLine.b = acrossPoint.y - perBiseLine.k * acrossPoint.x;
    
    //  计算perBiseLine和circle的两个交点
    CircleMath *tempCircle1 = [[CircleMath alloc] initWithCenterPoint:centerPoint radius:circleMath.radius inView:self];
    AcrossPointStruct acrossPointStruct1 = [self calucateCircleAndLineAcrossPoint_withCircle:tempCircle1 withLine:perBiseLine];
    
//    LineMath *tempLine11 = [[LineMath alloc] initWithPoint1:acrossPointStruct1.point1 point2:acrossPointStruct1.point2 inView:self];
//    [_dropSuperView.assisArray addObject:tempLine11];
    
    return acrossPointStruct1;
}

#pragma mark - 计算Center2Center过圆心的垂直平分线和DropView的交点
//  计算Center2Center过圆心的垂直平分线和DropView的交点
- (void)calucateCircleAndPerBiseLinePoint_withCircle:(CircleMath *)circle withDropView:(DropView *)dropView
{
    CGPoint tempCenter = [self convertPoint:circle.centerPoint fromView:circle.InView];
    CGFloat x0 = tempCenter.x;
    CGFloat y0 = tempCenter.y;
    
    //  Center2Center的的垂直平分线 perpendicularBisector
    LineMath *perBiseLine = [[LineMath alloc] init];
    CGFloat angle = atan(_lineCenter2Center.k);
    angle += M_PI/2;
    if (angle > M_PI/2) {
        angle -= M_PI;
    }else if (angle < - M_PI/2){
        angle += M_PI;
    }
    perBiseLine.k = tan(angle);
    perBiseLine.b = y0 - perBiseLine.k * x0;
    
    AcrossPointStruct acrossPointStruct = [self calucateCircleAndLineAcrossPoint_withCircle:circle withLine:perBiseLine];
    dropView.edge_point1 = acrossPointStruct.point1;
    dropView.edge_point2 = acrossPointStruct.point2;
    
    LineMath *perBiseLine_BigDrop_result = [[LineMath alloc] initWithPoint1:acrossPointStruct.point1 point2:acrossPointStruct.point2 inView:self];
    [_dropSuperView.assisArray addObject:perBiseLine_BigDrop_result];
}


#pragma mark - 计算两圆有重叠时的交点
/** 计算两圆有重叠时的交点
 *
 *  r1  小圆半径
 *  r2  大圆半径
 *  x   两圆心的距离
 *  x1  小圆圆心和两圆焦点连线的距离
 *  x2  大圆圆心和两圆焦点连线的距离
 *  x3  两圆连线的线长的一半长度
 *
 *  (x_o,y_o)   两圆圆心连线和两圆焦点连线的交点
 *  verLine     两圆心连线基于点(x_o,y_o)的垂线
 */
- (void)calucateCircleWithCircleAcrossPoint
{
    CGFloat r1 = _smallDrop.circleMath.radius;
    CGFloat r2 = _circleMath.radius;
    CALayer *smallDrop_layer = _smallDrop.layer.presentationLayer;
    CGFloat x  = [LineMath calucateDistanceBetweenPoint1:_circleMath.centerPoint withPoint2:smallDrop_layer.position];
    CGFloat x1;
    CGFloat x2;
    CGFloat x3;
    CGFloat x_o;
    CGFloat y_o;
    
    x1 = ( (r1*r1) - (r2*r2) + (x*x)) / (2 * x);
    x2 = x - x1;
    x3 = sqrt((r1*r1) - (x1*x1));
    
    CGFloat angle = atan(_lineCenter2Center.k);
    //  edgePoint矫正
    switch (_smallDropQuadrant) {
            //  第一象限
        case kQuadrant_First:
            x_o = self.width/2 + cos(angle) * x2;
            break;
            
            //  第二象限
        case kQuadrant_Second:
            x_o = self.width/2 - cos(angle) * x2;
            break;
            
            //  第三象限
        case kQuadrant_Third:
            x_o = self.width/2 - cos(angle) * x2;
            break;
            
            //  第四象限
        case kQuadrant_Fourth:
            x_o = self.width/2 + cos(angle) * x2;
            break;
            
        default:
            break;
    }
    
    y_o = _lineCenter2Center.k * x_o + _lineCenter2Center.b;

    LineMath *tempLine = [[LineMath alloc] initWithPoint1:CGPointMake(self.width/2, self.height/2) point2:CGPointMake(x_o, y_o) inView:self];
    [_dropSuperView.assisArray addObject:tempLine];
    
    //  Center2Centerde的垂线 VerticalLine
    LineMath *verLine = [[LineMath alloc] init];
    angle += M_PI/2;
    if (angle > M_PI/2) {
        angle -= M_PI;
    }else if (angle < - M_PI/2){
        angle += M_PI;
    }
    verLine.k = tan(angle);
    verLine.b = y_o - verLine.k * x_o;
    verLine.InView = self;
    
    AcrossPointStruct acrossPointStruct = [self calucateCircleAndLineAcrossPoint_withCircle:_circleMath withLine:verLine];
    verLine.point1 = acrossPointStruct.point1;
    verLine.point2 = acrossPointStruct.point2;
    
    _bezierControlPoint1 = verLine.point2;
    _bezierControlPoint2 = verLine.point1;
    
    _smallDrop.bezierControlPoint1 = verLine.point1;
    _smallDrop.bezierControlPoint2 = verLine.point2;
    
    [_dropSuperView.assisArray addObject:verLine];
}


#pragma mark - 已知过圆的直线方程，求圆与直线的两个交点
/** 已知过圆的直线方程，求圆与直线的两个交点
 *
 *  1，圆的方程
 *  dx方 = (x2 - x1)方 + (y2 - y1)方
 *  2，直线方程
 *  y = kx + b
 *
 *  联立1，2方程式，得出二次函数
 *  ax方 + bx + c = 0
 *  其中：
 *  a = ((kLine * kLine) + 1)
 *  b = - ((2 * x0) - (2 * kLine * bLine) + (2 * kLine * y0))
 *  c = (x0 * x0) + (bLine * bLine) - (2 * bLine * y0) + (y0 * y0) - (dx * dx)
 *  delta = b方 - 4ac
 *  解出该二次函数的两个根，就能得出圆与直线的两个交点的x值，从而得出圆与直线的两个交点的坐标
 *
 *  参数说明
 *  (x0, y0)    圆心坐标
 *  kLine       直线的斜率
 *  bLine       直线的b参数
 *  dx          圆的半径
 *  a,b,c,delta 上面都已说明，不再解释
 */
- (AcrossPointStruct)calucateCircleAndLineAcrossPoint_withCircle:(CircleMath *)circle withLine:(LineMath *)line
{
    CGPoint tempCenter = [self convertPoint:circle.centerPoint fromView:circle.InView];
    CGFloat x0 = tempCenter.x;
    CGFloat y0 = tempCenter.y;
    
    CGFloat kLine = line.k;
    CGFloat bLine = line.b;
    
    CGFloat r = circle.radius;
    CGFloat a = ((kLine * kLine) + 1);
    CGFloat b = - ((2 * x0) - (2 * kLine * bLine) + (2 * kLine * y0));
    CGFloat c = (x0 * x0) + (bLine * bLine) - (2 * bLine * y0) + (y0 * y0) - (r * r);
    AcrossPointStruct acrossPointStruct;
    
    float delta = (b * b) - (4 * a * c);
    if (delta > 0) {
        //        NSLog(@"两个根");
        
        CGFloat x1_result = ((-b) - sqrt(delta)) / (2 * a);
        CGFloat y1_result = (kLine * x1_result) + bLine;
        
        CGFloat x2_result = ((-b) + sqrt(delta)) / (2 * a);
        CGFloat y2_result = (kLine * x2_result) + bLine;
        
        acrossPointStruct.point1 = CGPointMake(x1_result, y1_result);
        acrossPointStruct.point2 = CGPointMake(x2_result, y2_result);
        
        //  edgePoint矫正
        switch (_smallDropQuadrant) {
                //  第一象限
            case kQuadrant_First:
                acrossPointStruct.point1 = CGPointMake(x2_result, y2_result);
                acrossPointStruct.point2 = CGPointMake(x1_result, y1_result);
                break;
                
                //  第二象限
            case kQuadrant_Second:
                acrossPointStruct.point1 = CGPointMake(x2_result, y2_result);
                acrossPointStruct.point2 = CGPointMake(x1_result, y1_result);
                break;
                
                //  第三象限
            case kQuadrant_Third:
                
                break;
                
                //  第四象限
            case kQuadrant_Fourth:
                
                break;
                
            default:
                break;
        }
        
    }else if (delta == 0){
//        NSLog(@"圆与直线 一个交点");
    }else{
//        NSLog(@"圆与直线 无交点");
    }
    
    return acrossPointStruct;
}

//  计算两点连线的垂直平分线
- (LineMath *)PerBaseLine_Point1:(CGPoint)point1 Point2:(CGPoint)point2
{
    LineMath *originMathLine = [[LineMath alloc] initWithPoint1:point1 point2:point2 inView:self];
    CGPoint centerPoint = [LineMath calucateCenterPointBetweenPoint1:point1 withPoint2:point2];
    
    LineMath *perBiseLine = [[LineMath alloc] init];
    CGFloat angle = atan(originMathLine.k);
    angle += M_PI/2;
    if (angle > M_PI/2) {
        angle -= M_PI;
    }else if (angle < - M_PI/2){
        angle += M_PI;
    }
    perBiseLine.k = tan(angle);
    perBiseLine.b = centerPoint.y - perBiseLine.k * centerPoint.x;
    
    return perBiseLine;
}

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
                            quadrantFourth:(void (^)())quadrantFourth
{
    //  第一象限
    if (centerPoint.x < paraPoint.x && centerPoint.y > paraPoint.y) {
        if (quadrantFirst) {
            quadrantFirst();
        }
    }
    //  第二象限
    else if (centerPoint.x > paraPoint.x && centerPoint.y > paraPoint.y){
        if (quadrantSecond) {
            quadrantSecond();
        }
    }
    //  第三象限
    else if (centerPoint.x > paraPoint.x && centerPoint.y < paraPoint.y){
        if (quadrantThird) {
            quadrantThird();
        }
    }
    //  第四象限
    else if (centerPoint.x < paraPoint.x && centerPoint.y < paraPoint.y){
        if (quadrantFourth) {
            quadrantFourth();
        }
    }
}

+ (BOOL)JudgeEqualWithPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    BOOL res1 = ((int)point1.x == (int)point2.x);
    BOOL res2 = ((int)point1.y == (int)point2.y);
    
    if (res1 && res2) {
        return YES;
    }
    
    return NO;
}

/** 根据两点和比例计算其他点
 *
 *  point1,point2   两源点
 *  ratio           距两个端点距离占线段总长度的比例
 *  twoPointStruct  最终返回的两点的结构体
 *  注：ratio小于0.5的情况下，
 *      twoPointStruct.point1靠近point1
 *      twoPointStruct.point2靠近point2
 *      反之亦然
 */
+ (TwoPointStruct)PointBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2 ToPointRatio:(CGFloat)ratio
{
    TwoPointStruct twoPointStruct;
    
    CGFloat xAll = point1.x + point2.x;
    CGFloat yAll = point1.y + point2.y;
    
    CGFloat xDis = point2.x - point1.x;
    CGFloat yDis = point2.y - point1.y;
    
    CGFloat xRes1 = (xAll - xDis * ratio)/2.0f;
    CGFloat yRes1 = (yAll - yDis * ratio)/2.0f;
    
    CGFloat xRes2 = (xAll + xDis * ratio)/2.0f;
    CGFloat yRes2 = (yAll + yDis * ratio)/2.0f;
    
    twoPointStruct.point1 = CGPointMake(xRes1, yRes1);
    twoPointStruct.point2 = CGPointMake(xRes2, yRes2);
    
    return twoPointStruct;
}

@end





