//
//  DropCanvasView.m
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DropCanvasView.h"
#import "DropView.h"
#import "LineMath.h"
#import "PointMath.h"

//  角度转弧度
#define degreesToRadian(x) (M_PI * x / 180.0)

//  弧度转角度
#define radiansToDegrees(x) (180.0 * x / M_PI)

@interface DropCanvasView()
@property (strong, nonatomic) DropView          *mainDrop;

@end


@implementation DropCanvasView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    _assisArray = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    [self createMainDrop];
    
    return self;
}

- (void)createMainDrop
{
    CGFloat mainDrop_width = 150;
    _mainDrop = [[DropView alloc] initWithFrame:CGRectMake(mainDrop_width, mainDrop_width, mainDrop_width, mainDrop_width) createSmallDrop:YES];
    _mainDrop.dropSuperView = self;
    [self.layer addSublayer:_mainDrop.dropShapLayer];
    [self addSubview:_mainDrop];
//    [_mainDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self drawDrop1View:_mainDrop];
//    [self drawDropView:_mainDrop];
    [self drawAssistantLine];
}




/***********************
 角度说明
 
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

/** 绘制DropView
 *
 *  mainDrop_center         mainDrop中心点
 *  smallDrop_presentLayer  smallDrop演示图层
 *  smallDrop_center        smallDrop中心点
 *  centerDistance          mainDrop和smallDrop中心的距离
 */
- (void)drawDrop1View:(DropView *)dropView
{
    CALayer *smallDrop_presentLayer = dropView.smallDrop.layer.presentationLayer;
    if (smallDrop_presentLayer == nil) {
        return;
    }
    
    CGPoint mainDrop_center = dropView.center;
    CGPoint smallDrop_center = [dropView convertPoint:smallDrop_presentLayer.position toView:self];
    CGFloat centerDistance = [LineMath calucateDistanceBetweenPoint1:mainDrop_center withPoint2:smallDrop_center];
    
    CGPoint mainEdgePoint1 = [dropView convertPoint:dropView.edge_point1 toView:self];
    CGPoint mainEdgePoint2 = [dropView convertPoint:dropView.edge_point2 toView:self];
    CGPoint smallEdgePoint1 = [dropView convertPoint:dropView.smallDrop.edge_point1 toView:self];
    CGPoint smallEdgePoint2 = [dropView convertPoint:dropView.smallDrop.edge_point2 toView:self];

    CGPoint bezierControlPoint1 = [dropView convertPoint:dropView.bezierControlPoint1 toView:self];
    CGPoint bezierControlPoint2 = [dropView convertPoint:dropView.bezierControlPoint2 toView:self];
    
    /******    MainDrop和SmallDrop 相交   ******/
    
    
        
    [dropView.bezierPath removeAllPoints];
    dropView.bezierPath.lineCapStyle = kCGLineCapRound;
    
    //  MainDrop半圆
    LineMath *lineP1_MainCenter = [[LineMath alloc] initWithPoint1:mainEdgePoint1 point2:mainDrop_center inView:self];
    LineMath *lineP2_MainCenter = [[LineMath alloc] initWithPoint1:mainEdgePoint2 point2:mainDrop_center inView:self];
    
    __block CGFloat angleLine_MainP1 = atan(lineP1_MainCenter.k);
    __block CGFloat angleLine_MainP2 = atan(lineP2_MainCenter.k);
    
    //  两圆焦点和圆心连线的line的 斜率矫正
    [DropView eventInDiffQuadrantWithCenterPoint:mainDrop_center withParaPoint:mainEdgePoint1 quadrantFirst:^{
        nil;
    } quadrantSecond:^{
        angleLine_MainP1 -= M_PI;
    } quadrantThird:^{
        angleLine_MainP1 -= M_PI;
    } quadrantFourth:^{
        nil;
    }];
    
    [DropView eventInDiffQuadrantWithCenterPoint:mainDrop_center withParaPoint:mainEdgePoint2 quadrantFirst:^{
        nil;
    } quadrantSecond:^{
        angleLine_MainP2 -= M_PI;
    } quadrantThird:^{
        angleLine_MainP2 -= M_PI;
    } quadrantFourth:^{
        nil;
    }];
    
    [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:angleLine_MainP1 endAngle:angleLine_MainP2 clockwise:YES];
    
    //  MainDrop右侧贝塞尔圆滑过渡曲线
    LineMath *tempLine1 = [[LineMath alloc] initWithPoint1:mainEdgePoint2 point2:mainEdgePoint2 inView:self];
    [_assisArray addObject:tempLine1];
    
    
    [dropView.bezierPath addQuadCurveToPoint:mainEdgePoint2 controlPoint:mainEdgePoint2];
    
    //  MainDrop右侧到SmallDrop右侧的贝塞尔曲线
    LineMath *tempLine = [[LineMath alloc] initWithPoint1:mainEdgePoint2 point2:smallEdgePoint2 inView:self];
    [_assisArray addObject:tempLine];
    [dropView.bezierPath addQuadCurveToPoint:smallEdgePoint2 controlPoint:bezierControlPoint1];
    
    
    //  SmallDrop半圆
    LineMath *lineP1_SmallCenter = [[LineMath alloc] initWithPoint1:smallEdgePoint2 point2:smallDrop_center inView:self];
    LineMath *lineP2_SmallCenter = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:smallDrop_center inView:self];
    
    __block CGFloat angleLine_SmallP1 = atan(lineP1_SmallCenter.k);
    __block CGFloat angleLine_SmallP2 = atan(lineP2_SmallCenter.k);
    
    //  两圆焦点和圆心连线的line的 斜率矫正
    [DropView eventInDiffQuadrantWithCenterPoint:smallDrop_center withParaPoint:smallEdgePoint1 quadrantFirst:^{
        nil;
    } quadrantSecond:^{
        angleLine_SmallP1 -= M_PI;
    } quadrantThird:^{
        angleLine_SmallP1 -= M_PI;
    } quadrantFourth:^{
        nil;
    }];
    
    [DropView eventInDiffQuadrantWithCenterPoint:smallDrop_center withParaPoint:smallEdgePoint2 quadrantFirst:^{
        nil;
    } quadrantSecond:^{
        angleLine_SmallP2-= M_PI;
    } quadrantThird:^{
        angleLine_SmallP2 -= M_PI;
    } quadrantFourth:^{
        nil;
    }];
    
    [dropView.bezierPath addArcWithCenter:smallDrop_center radius:dropView.smallDrop.circleMath.radius startAngle:angleLine_SmallP2 endAngle:angleLine_SmallP1 clockwise:YES];
    
    
    //  SmallDrop左侧贝塞尔圆滑过渡曲线
    LineMath *tempLine3 = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:smallEdgePoint1 inView:self];
    [_assisArray addObject:tempLine3];
    
    [dropView.bezierPath addQuadCurveToPoint:smallEdgePoint1 controlPoint:smallEdgePoint1];
    
    //  SmallDrop左侧到MainDrop左侧的被塞尔曲线
    LineMath *tempLine4 = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:mainEdgePoint1 inView:self];
    [_assisArray addObject:tempLine4];
    
    [dropView.bezierPath addQuadCurveToPoint:mainEdgePoint1 controlPoint:bezierControlPoint2];
    
    
    dropView.dropShapLayer.path = dropView.bezierPath.CGPath;
}


/***********************
 角度说明
 
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

/** 绘制DropView
 *
 *  mainDrop_center         mainDrop中心点
 *  smallDrop_presentLayer  smallDrop演示图层
 *  smallDrop_center        smallDrop中心点
 *  centerDistance          mainDrop和smallDrop中心的距离
 */
- (void)drawDropView:(DropView *)dropView
{
    CALayer *smallDrop_presentLayer = dropView.smallDrop.layer.presentationLayer;
    if (smallDrop_presentLayer == nil) {
        return;
    }
    
    CGPoint mainDrop_center = dropView.center;
    CGPoint smallDrop_center = [dropView convertPoint:smallDrop_presentLayer.position toView:self];
    CGFloat centerDistance = [LineMath calucateDistanceBetweenPoint1:mainDrop_center withPoint2:smallDrop_center];
    
    CGPoint mainEdgePoint1 = [dropView convertPoint:dropView.edge_point1 toView:self];
    CGPoint mainEdgePoint2 = [dropView convertPoint:dropView.edge_point2 toView:self];
    CGPoint smallEdgePoint1 = [dropView convertPoint:dropView.smallDrop.edge_point1 toView:self];
    CGPoint smallEdgePoint2 = [dropView convertPoint:dropView.smallDrop.edge_point2 toView:self];
    
    
    /******     MainDrop和SmallDrop 相离   ******/
    
    if (centerDistance > (dropView.circleMath.radius + dropView.smallDrop.circleMath.radius)) {
        CGFloat tempAngle = atan(dropView.lineCenter2Center.k);
        
        //  垂直平分线的斜率k矫正
        //  第一象限
        if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y > smallDrop_center.y) {
            tempAngle += M_PI/2;
        }
        //  第二象限
        else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y > smallDrop_center.y){
            tempAngle -= M_PI/2;
        }
        //  第三象限
        else if (mainDrop_center.x > smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
            tempAngle -= M_PI/2;
        }
        //  第四象限
        else if (mainDrop_center.x < smallDrop_center.x && mainDrop_center.y < smallDrop_center.y){
            tempAngle += M_PI/2;
        }
        
        [dropView.bezierPath removeAllPoints];
        
        //  MainDrop 半圆
        [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:tempAngle endAngle:tempAngle + M_PI clockwise:YES];
        
        //  MainDrop->SmallDrop贝赛尔曲线
        CGPoint controlPoint = CGPointMake((mainDrop_center.x + smallDrop_center.x)/2, (mainDrop_center.y + smallDrop_center.y)/2);
        
        [dropView.bezierPath addQuadCurveToPoint:smallEdgePoint2 controlPoint:controlPoint];
        
        //  SmallDrop 半圆
        [dropView.bezierPath addArcWithCenter:smallDrop_center radius:dropView.smallDrop.circleMath.radius startAngle:tempAngle + M_PI endAngle:tempAngle clockwise:YES];
        
        //  SmallDrop->MainDrop贝赛尔曲线
        [dropView.bezierPath addQuadCurveToPoint:mainEdgePoint1 controlPoint:controlPoint];
    }
    
    /******    MainDrop和SmallDrop 相交   ******/
    
    else if(centerDistance < (dropView.circleMath.radius + dropView.smallDrop.circleMath.radius) && centerDistance > (dropView.circleMath.radius - dropView.smallDrop.circleMath.radius)){
        
        [dropView.bezierPath removeAllPoints];
        
        //  MainDrop半圆
        LineMath *lineP1_MainCenter = [[LineMath alloc] initWithPoint1:mainEdgePoint1 point2:mainDrop_center inView:self];
        LineMath *lineP2_MainCenter = [[LineMath alloc] initWithPoint1:mainEdgePoint2 point2:mainDrop_center inView:self];
        
        __block CGFloat angleLine_MainP1 = atan(lineP1_MainCenter.k);
        __block CGFloat angleLine_MainP2 = atan(lineP2_MainCenter.k);
        
        //  两圆焦点和圆心连线的line的 斜率矫正
        [DropView eventInDiffQuadrantWithCenterPoint:mainDrop_center withParaPoint:mainEdgePoint1 quadrantFirst:^{
            nil;
        } quadrantSecond:^{
            angleLine_MainP1 -= M_PI;
        } quadrantThird:^{
            angleLine_MainP1 -= M_PI;
        } quadrantFourth:^{
            nil;
        }];
        
        [DropView eventInDiffQuadrantWithCenterPoint:mainDrop_center withParaPoint:mainEdgePoint2 quadrantFirst:^{
            nil;
        } quadrantSecond:^{
            angleLine_MainP2 -= M_PI;
        } quadrantThird:^{
            angleLine_MainP2 -= M_PI;
        } quadrantFourth:^{
            nil;
        }];
        
        [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:angleLine_MainP1 endAngle:angleLine_MainP2 clockwise:YES];
        
        
        //  SmallDrop半圆
        LineMath *lineP1_SmallCenter = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:smallDrop_center inView:self];
        LineMath *lineP2_SmallCenter = [[LineMath alloc] initWithPoint1:smallEdgePoint2 point2:smallDrop_center inView:self];
        
        __block CGFloat angleLine_SmallP1 = atan(lineP1_SmallCenter.k);
        __block CGFloat angleLine_SmallP2 = atan(lineP2_SmallCenter.k);
        
        //  两圆焦点和圆心连线的line的 斜率矫正
        [DropView eventInDiffQuadrantWithCenterPoint:smallDrop_center withParaPoint:smallEdgePoint1 quadrantFirst:^{
            nil;
        } quadrantSecond:^{
            angleLine_SmallP1 -= M_PI;
        } quadrantThird:^{
            angleLine_SmallP1 -= M_PI;
        } quadrantFourth:^{
            nil;
        }];
        
        [DropView eventInDiffQuadrantWithCenterPoint:smallDrop_center withParaPoint:smallEdgePoint2 quadrantFirst:^{
            nil;
        } quadrantSecond:^{
            angleLine_SmallP2-= M_PI;
        } quadrantThird:^{
            angleLine_SmallP2 -= M_PI;
        } quadrantFourth:^{
            nil;
        }];
        
        [dropView.bezierPath addArcWithCenter:smallDrop_center radius:dropView.smallDrop.circleMath.radius startAngle:angleLine_SmallP2 endAngle:angleLine_SmallP1 clockwise:YES];
    }
    
    /******     MainDrop和SmallDrop 包含    ******/
    
    else{
        
        [dropView.bezierPath removeAllPoints];
    }
    
    dropView.dropShapLayer.path = dropView.bezierPath.CGPath;
}

- (void)drawAssistantLine
{
    //  绘制辅助线
    for (id tempAssis in _assisArray) {

        if ([tempAssis isKindOfClass:[LineMath class]]) {
            LineMath *lineMath = (LineMath *)tempAssis;
            CGPoint point1 = [lineMath.InView convertPoint:lineMath.point1 toView:self];
            CGPoint point2 = [lineMath.InView convertPoint:lineMath.point2 toView:self];
            [self drawLineWithLayer:point1 endPoint:point2 lineWidth:1.0f lineColor:[UIColor blackColor]];
        }
        
        if ([tempAssis isKindOfClass:[PointMath class]]) {
            PointMath *pointMath = (PointMath *)tempAssis;
            CGPoint point = [pointMath.InView convertPoint:pointMath.point toView:self];
            [self drawPoint:point];
        }
    }
}

//  画点
- (void)drawPoint:(CGPoint)point
{
    CGFloat point_width = 10;
    
    //1.获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.绘制图形
    CGContextAddEllipseInRect(context, CGRectMake(point.x - point_width/2, point.y - point_width/2, point_width, point_width));
    CGContextSetLineWidth(context, 2);
    
    [[UIColor blackColor] setFill];
    CGContextFillPath(context);
}

@end



