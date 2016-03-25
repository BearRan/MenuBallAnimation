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

@interface DropCanvasView()
{
    CGFloat     _btnWidth;
    CGFloat     _btnOffY_start;
    CGFloat     _btnOffY_end;
    CGFloat     _textImg_offY;
    CGFloat     _btnGapDistance;
    CGFloat     _btnGapDistance_Origin;
    
    DropView        *_mainDrop;
    UIView          *_ringBgView;
    CAShapeLayer    *_ringStrokeLayer;
    CAShapeLayer    *_ringFillingLayer;
    UIColor         *_ringColor;
}

@end


@implementation DropCanvasView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }

    self.backgroundColor = [UIColor clearColor];
    
    [self setParameter];
    
    [self createMainDrop];
    [self createAllWidget];
    
    return self;
}

- (void)setParameter
{
    _assisArray         = [[NSMutableArray alloc] init];
    _animationStatus    = animationClose;
    
    _btnWidth       = 0.13 * WIDTH;
    _btnOffY_start  = 42 / 1337.0 * HEIGHT;
    _btnOffY_end    = 183 / 1337.0 * HEIGHT;
    _textImg_offY   = 91 / 1337.0 * HEIGHT;
    _btnGapDistance_Origin = 252/752.0 * WIDTH;
    _btnGapDistance = sqrt(_btnGapDistance_Origin * _btnGapDistance_Origin / 2.0);
    _ringColor      = RGB(88, 91, 104);
}

- (void)createMainDrop
{
    _mainDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth) createSmallDrop:YES];
    _mainDrop.dropSuperView = self;
    _mainDrop.fillColor = [UIColor whiteColor];
    [self addSubview:_mainDrop];
    [_mainDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
    
    [self createRingUI];
    
    //  _mainDrop.dropShapLayer
    [self.layer addSublayer:_mainDrop.dropShapLayer];
}

- (void)createRingUI
{
    CGFloat bigRingRadius       = 252/752.0 * WIDTH;
    CGFloat smallRingRadius     = 100/752.0 * WIDTH;
    CGFloat centerRingRadius    = 76/752.0 * WIDTH;
    
    _ringBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _ringBgView.alpha = 0;
    [self addSubview:_ringBgView];
    
    
    //  _ringStrokeLayer
    _ringStrokeLayer = [CAShapeLayer layer];
    _ringStrokeLayer.lineWidth = 1.5f;
    _ringStrokeLayer.strokeColor = _ringColor.CGColor;
    _ringStrokeLayer.fillColor = [UIColor clearColor].CGColor;
    [_ringBgView.layer addSublayer:_ringStrokeLayer];
    
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(_mainDrop.centerX + bigRingRadius, _mainDrop.centerY)];
    [bezierPath1 addArcWithCenter:_mainDrop.center radius:bigRingRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [bezierPath1 moveToPoint:CGPointMake(_mainDrop.centerX + smallRingRadius, _mainDrop.centerY)];
    [bezierPath1 addArcWithCenter:_mainDrop.center radius:smallRingRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    _ringStrokeLayer.path = bezierPath1.CGPath;
    
    
    //  _ringStrokeLayer
    _ringFillingLayer = [CAShapeLayer layer];
    _ringFillingLayer.fillColor = _ringColor.CGColor;
    [_ringBgView.layer addSublayer:_ringFillingLayer];
    
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
    [bezierPath2 addArcWithCenter:_mainDrop.center radius:centerRingRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    _ringFillingLayer.path = bezierPath2.CGPath;
    
}

- (void)createAllWidget
{
    CGFloat deltaGap = _btnGapDistance;
    UIColor *btnBackgroundColor = [UIColor whiteColor];
    
    //  _bottomText_Img
    _bottomText_Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vidaHouse_Text"]];
    _bottomText_Img.alpha = 0;
    [self addSubview:_bottomText_Img];
    [_bottomText_Img BearSetRelativeLayoutWithDirection:kDIR_DOWN destinationView:nil parentRelation:YES distance:_textImg_offY center:YES];
    
    //  _bottom_Btn
    _bottom_Btn = [[AddButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _bottom_Btn.backgroundColor = btnBackgroundColor;
    _bottom_Btn.layer.cornerRadius = _btnWidth/2.0f;
    _bottom_Btn.layer.masksToBounds = YES;
    [self addSubview:_bottom_Btn];
    [_bottom_Btn BearSetRelativeLayoutWithDirection:kDIR_DOWN destinationView:nil parentRelation:YES distance:_btnOffY_start center:YES];
    
    
    //  _menuCenter_Btn
    _menuCenter_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menuCenter_Btn.backgroundColor = btnBackgroundColor;
    _menuCenter_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menuCenter_Btn setImage:[UIImage imageNamed:@"BtnIcon_Note"] forState:UIControlStateNormal];
    [self addSubview:_menuCenter_Btn];
    [_menuCenter_Btn BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
    
    //  _menu1_btn
    _menu1_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menu1_Btn.backgroundColor = btnBackgroundColor;
    _menu1_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menu1_Btn setImage:[UIImage imageNamed:@"BtnIcon_Users"] forState:UIControlStateNormal];
    [self addSubview:_menu1_Btn];
    [_menu1_Btn setCenter:CGPointMake(_menuCenter_Btn.centerX - deltaGap, _menuCenter_Btn.centerY - deltaGap)];
    
    //  _menu2_btn
    _menu2_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menu2_Btn.backgroundColor = btnBackgroundColor;
    _menu2_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menu2_Btn setImage:[UIImage imageNamed:@"BtnIcon_ShoppingBag"] forState:UIControlStateNormal];
    [self addSubview:_menu2_Btn];
    [_menu2_Btn setCenter:CGPointMake(_menuCenter_Btn.centerX + deltaGap, _menuCenter_Btn.centerY - deltaGap)];
    
    //  _menu3_btn
    _menu3_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menu3_Btn.backgroundColor = btnBackgroundColor;
    _menu3_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menu3_Btn setImage:[UIImage imageNamed:@"BtnIcon_Write"] forState:UIControlStateNormal];
    [self addSubview:_menu3_Btn];
    [_menu3_Btn setCenter:CGPointMake(_menuCenter_Btn.centerX - deltaGap, _menuCenter_Btn.centerY + deltaGap)];
    
    //  _menu4_btn
    _menu4_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menu4_Btn.backgroundColor = btnBackgroundColor;
    _menu4_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menu4_Btn setImage:[UIImage imageNamed:@"BtnIcon_UserSingle"] forState:UIControlStateNormal];
    [self addSubview:_menu4_Btn];
    [_menu4_Btn setCenter:CGPointMake(_menuCenter_Btn.centerX + deltaGap, _menuCenter_Btn.centerY + deltaGap)];
    
    [self menuFourBtnAlpha0];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    [self drawDropView2:_mainDrop];
//    [self drawDrop1View:_mainDrop];
//    [self drawDropView:_mainDrop];
//    [self drawAssistantLine];
}


- (void)drawDropView2:(DropView *)dropView
{
    [dropView.bezierPath removeAllPoints];
    dropView.bezierPath.lineCapStyle = kCGLineCapRound;
    dropView.bezierPath.lineJoinStyle = kCGLineJoinRound;
    
    switch (dropView.relation) {
            
        case kInitional:{
            CGPoint mainDrop_center = [dropView convertPoint:dropView.circleMath.centerPoint toView:self];
            
            [dropView.bezierPath moveToPoint:CGPointMake(mainDrop_center.x + dropView.circleMath.radius, mainDrop_center.y)];
            [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        }
            break;
            
        case kSeparated_SmallToMain:
        {
//            NSArray *smallDropViewArray = [[NSArray alloc] initWithObjects:dropView.assisDrop1, dropView.assisDrop2, nil];
            NSArray *smallDropViewArray = [[NSArray alloc] initWithObjects:dropView.assisDrop1, dropView.assisDrop2, dropView.assisDrop3, dropView.assisDrop4, nil];
            for (int i = 0; i < [smallDropViewArray count]; i++) {
                
                DropView *assisDrop_now = (DropView *)smallDropViewArray[i];
                DropView *assisDrop_later = (i+1) >= [smallDropViewArray count] ? (DropView *)smallDropViewArray[0] : (DropView *)smallDropViewArray[i+1];
                
                CALayer *assisDrop_PreLayer = assisDrop_now.layer.presentationLayer;
                CGPoint assisDropNow_center = [dropView convertPoint:assisDrop_PreLayer.position toView:self];
                CGPoint mainDrop_center = [dropView convertPoint:dropView.circleMath.centerPoint toView:self];
                
                CGPoint assisDropNow_CenterAssisPoint = [dropView convertPoint:assisDrop_now.crossToCenterAssis_Point toView:self];
                CGPoint assisDropMain_CenterAssisPoint = [dropView convertPoint:assisDrop_now.crossToCenterAssis_PointMain toView:self];
                
                CGPoint assisDropNow_LeftAssisPoint = [dropView convertPoint:assisDrop_now.crossToLeftAssis_Point toView:self];
                CGPoint assisDropNow_RightAssisPoint = [dropView convertPoint:assisDrop_now.crossToRightAssis_Point toView:self];
                CGPoint assisDropNow_LeftAssisPointMain = [dropView convertPoint:assisDrop_now.crossToLeftAssis_PointMain toView:self];
                CGPoint assisDropNow_RightAssisPointMain = [dropView convertPoint:assisDrop_now.crossToRightAssis_PointMain toView:self];
                
                CGPoint assisDropLater_LeftAssisPointMain = [dropView convertPoint:assisDrop_later.crossToLeftAssis_PointMain toView:self];
                
                CGFloat radius_start = [DropView ConvertPointToRadiusInDropView:assisDrop_now point:assisDrop_now.crossToLeftAssis_Point canvansView:self];
                CGFloat radius_end = [DropView ConvertPointToRadiusInDropView:assisDrop_now point:assisDrop_now.crossToRightAssis_Point canvansView:self];
                
                CGFloat centerDistace = [LineMath calucateDistanceBetweenPoint1:mainDrop_center withPoint2:assisDropNow_center];
                
                
                //  开始减小
                if (centerDistace > reduceThreshold && centerDistace < normalThreshold) {
//                    NSLog(@"centerDistace:%f", centerDistace);
                    
                    CGFloat deltaValue  = normalThreshold - reduceThreshold;
                    CGFloat deltaNow    = centerDistace - reduceThreshold;
                    CGFloat ratio       = deltaNow / deltaValue;
                    NSLog(@"ratio444:%f", ratio);
                    
                    //  计算贝赛尔曲线的终点
                    TwoPointStruct assisDropFinal_PointStruct = [DropView PointBetweenPoint1:assisDropNow_CenterAssisPoint point2:assisDropMain_CenterAssisPoint ToPointRatio:ratio];
                    
                    PointMath *pointMath1 = [[PointMath alloc] initWithPoint:assisDropFinal_PointStruct.point1 inView:self];
                    [_assisArray addObject:pointMath1];
                    
                    PointMath *pointMath2 = [[PointMath alloc] initWithPoint:assisDropFinal_PointStruct.point2 inView:self];
                    [_assisArray addObject:pointMath2];
                    
                    
                    /***  在小圆上绘制贝塞尔曲线  ***/
                    
                    //  计算贝塞尔曲线控制点(小圆上)
                    CGPoint dropNowAssisCenterPoint = [LineMath calucateCenterPointBetweenPoint1:assisDropNow_LeftAssisPoint withPoint2:assisDropNow_RightAssisPoint];
                    TwoPointStruct assisControl_PointStructDropNow = [DropView PointBetweenPoint1:dropNowAssisCenterPoint point2:assisDropFinal_PointStruct.point1 ToPointRatio:0.3];
                    
                    [dropView.bezierPath moveToPoint:assisDropNow_LeftAssisPoint];
                    [dropView.bezierPath addArcWithCenter:assisDropNow_center radius:assisDrop_now.circleMath.radius startAngle:radius_start endAngle:radius_end clockwise:YES];
                    [dropView.bezierPath addQuadCurveToPoint:assisDropFinal_PointStruct.point1 controlPoint:assisControl_PointStructDropNow.point1];
                    [dropView.bezierPath addQuadCurveToPoint:assisDropNow_LeftAssisPoint controlPoint:assisControl_PointStructDropNow.point1];
                    [dropView.bezierPath closePath];
                    
                    
                    
                    PointMath *pointMath3 = [[PointMath alloc] initWithPoint:assisControl_PointStructDropNow.point1 inView:self];
                    pointMath3.radius = [NSNumber numberWithFloat:3.0f];
                    [_assisArray addObject:pointMath3];

                    PointMath *pointMath4 = [[PointMath alloc] initWithPoint:assisControl_PointStructDropNow.point2 inView:self];
                    pointMath4.radius = [NSNumber numberWithFloat:3.0f];
                    [_assisArray addObject:pointMath4];
                    
                    
                    
                    /***  在大圆上绘制贝塞尔曲线  ***/
                    
                    CGFloat radius_startMain = [DropView ConvertPointToRadiusInDropView:dropView point:assisDropNow_RightAssisPointMain canvansView:self];
                    CGFloat radius_endMain = [DropView ConvertPointToRadiusInDropView:dropView point:assisDropLater_LeftAssisPointMain canvansView:self];
                    
                    //  计算贝塞尔曲线控制点(d大圆上)
                    CGPoint dropMainAssisCenterPoint = [LineMath calucateCenterPointBetweenPoint1:assisDropNow_LeftAssisPointMain withPoint2:assisDropNow_RightAssisPointMain];
                    TwoPointStruct assisControl_PointStructDropMain = [DropView PointBetweenPoint1:dropMainAssisCenterPoint point2:assisDropFinal_PointStruct.point2 ToPointRatio:0.3];
                    
                    [dropView.bezierPath moveToPoint:assisDropNow_LeftAssisPointMain];
                    [dropView.bezierPath addQuadCurveToPoint:assisDropFinal_PointStruct.point2 controlPoint:assisControl_PointStructDropMain.point1];
                    [dropView.bezierPath addQuadCurveToPoint:assisDropNow_RightAssisPointMain controlPoint:assisControl_PointStructDropMain.point1];
                    [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:radius_startMain endAngle:radius_endMain clockwise:YES];
                }
                
                //  粘滞状态
                else if (centerDistace < reduceThreshold) {
                    if ([assisDrop_now isEqual:[smallDropViewArray firstObject]]) {
                        [dropView.bezierPath moveToPoint:assisDropNow_LeftAssisPointMain];
                    }
                    
                    CGFloat radius_SmallAddMain = assisDrop_now.circleMath.radius + dropView.circleMath.radius;
                    CGFloat ratio = [LineMath calucateRatioBetweenMin:radius_SmallAddMain Max:reduceThreshold Now:centerDistace];
//                    NSLog(@"ratio3333:%f", ratio);
//                    TwoPointStruct centerAssisPointStruct = [DropView PointBetweenPoint1:assisDropNow_CenterAssisPoint point2:assisDropMain_CenterAssisPoint ToPointRatio:ratio];
                    
//                    PointMath *pointMath5 = [[PointMath alloc] initWithPoint:centerAssisPointStruct.point1 inView:self];
//                    [_assisArray addObject:pointMath5];
//                    
//                    PointMath *pointMath6 = [[PointMath alloc] initWithPoint:centerAssisPointStruct.point2 inView:self];
//                    pointMath6.radius = [NSNumber numberWithFloat:3.0f];
//                    [_assisArray addObject:pointMath6];
                    
                    
                    
                    
//                    CGPoint assisDropNow_LeftAssisPoint = [dropView convertPoint:assisDrop_now.crossToLeftAssis_Point toView:self];
//                    CGPoint assisDropNow_RightAssisPoint = [dropView convertPoint:assisDrop_now.crossToRightAssis_Point toView:self];
//                    CGPoint assisDropNow_LeftAssisPointMain = [dropView convertPoint:assisDrop_now.crossToLeftAssis_PointMain toView:self];
//                    CGPoint assisDropNow_RightAssisPointMain = [dropView convertPoint:assisDrop_now.crossToRightAssis_PointMain toView:self];
                    
                    
                    //  同一个Drop左右两侧assisRatio
                    CGFloat assisPointStruct_ratio = [LineMath calucateValueBetweenMin:-0.3 Max:0.6 Ratio:1 - ratio];
//                    NSLog(@"ratioOrigin:%f assisPointStruct_ratio:%f", 1-ratio, assisPointStruct_ratio);
                    TwoPointStruct smallAssisPointStruct = [DropView PointBetweenPoint1:assisDropNow_LeftAssisPoint point2:assisDropNow_RightAssisPoint ToPointRatio:assisPointStruct_ratio];
                    
                    
                    TwoPointStruct mainAssisPointStruct = [DropView PointBetweenPoint1:assisDropNow_LeftAssisPointMain point2:assisDropNow_RightAssisPointMain ToPointRatio: assisPointStruct_ratio];
                    
                    
                    PointMath *pointMath7 = [[PointMath alloc] initWithPoint:smallAssisPointStruct.point1 inView:self];
                    [_assisArray addObject:pointMath7];

                    PointMath *pointMath8 = [[PointMath alloc] initWithPoint:smallAssisPointStruct.point2 inView:self];
                    pointMath8.radius = [NSNumber numberWithFloat:3.0f];
                    [_assisArray addObject:pointMath8];
                    
                    
                    PointMath *pointMath9 = [[PointMath alloc] initWithPoint:mainAssisPointStruct.point1 inView:self];
                    [_assisArray addObject:pointMath9];
                    
                    PointMath *pointMath10 = [[PointMath alloc] initWithPoint:mainAssisPointStruct.point2 inView:self];
                    pointMath10.radius = [NSNumber numberWithFloat:3.0f];
                    [_assisArray addObject:pointMath10];

                    
                    
                    //  同DropNow和MianDrop之间的assisRatio
                    CGFloat assisPointStructSmallToMain_ratio = [LineMath calucateValueBetweenMin:0.3 Max:0.7 Ratio:ratio];
                    NSLog(@"ratioOrigin:%f assisPointStructSmallToMain_ratio:%f", ratio, assisPointStructSmallToMain_ratio);
                    TwoPointStruct assisPointStruct_Left = [DropView PointBetweenPoint1:smallAssisPointStruct.point1 point2:mainAssisPointStruct.point1 ToPointRatio:assisPointStructSmallToMain_ratio];
                    
                    TwoPointStruct assisPointStruct_Right = [DropView PointBetweenPoint1:smallAssisPointStruct.point2 point2:mainAssisPointStruct.point2 ToPointRatio:assisPointStructSmallToMain_ratio];
                    
                    
                    PointMath *pointMath11 = [[PointMath alloc] initWithPoint:assisPointStruct_Left.point1 inView:self];
                    [_assisArray addObject:pointMath11];
                    
                    PointMath *pointMath12 = [[PointMath alloc] initWithPoint:assisPointStruct_Left.point2 inView:self];
                    pointMath12.radius = [NSNumber numberWithFloat:3.0f];
                    [_assisArray addObject:pointMath12];
                    
                    
                    PointMath *pointMath13 = [[PointMath alloc] initWithPoint:assisPointStruct_Right.point1 inView:self];
                    [_assisArray addObject:pointMath13];
                    
                    PointMath *pointMath14 = [[PointMath alloc] initWithPoint:assisPointStruct_Right.point2 inView:self];
                    pointMath14.radius = [NSNumber numberWithFloat:3.0f];
                    [_assisArray addObject:pointMath14];
                    
                    
                    
                    
                    
                    //  大圆到小圆
                    CGPoint centerPoint = [LineMath calucateCenterPointBetweenPoint1:assisDropNow_CenterAssisPoint withPoint2:assisDropMain_CenterAssisPoint];
//                    [dropView.bezierPath addQuadCurveToPoint:assisDropNow_LeftAssisPoint controlPoint:centerPoint];
                    [dropView.bezierPath addCurveToPoint:assisDropNow_LeftAssisPoint controlPoint1:assisPointStruct_Left.point2 controlPoint2:assisPointStruct_Left.point1];
                    
                    
                    //  绘制小圆半圆弧
                    [dropView.bezierPath addArcWithCenter:assisDropNow_center radius:assisDrop_now.circleMath.radius startAngle:radius_start endAngle:radius_end clockwise:YES];
                    
                    //  小圆到大圆贝塞尔曲线
//                    [dropView.bezierPath addQuadCurveToPoint:assisDropNow_RightAssisPointMain controlPoint:centerPoint];
                    [dropView.bezierPath addCurveToPoint:assisDropNow_RightAssisPointMain controlPoint1:assisPointStruct_Right.point1 controlPoint2:assisPointStruct_Right.point2];
                    
                    //  大圆半圆弧
                    CGFloat radius_startMain = [DropView ConvertPointToRadiusInDropView:dropView point:assisDropNow_RightAssisPointMain canvansView:self];
                    CGFloat radius_endMain = [DropView ConvertPointToRadiusInDropView:dropView point:assisDropLater_LeftAssisPointMain canvansView:self];
                    
                    PointMath *pointMath1 = [[PointMath alloc] initWithPoint:assisDropNow_RightAssisPointMain inView:self];
                    [_assisArray addObject:pointMath1];
                    
                    PointMath *pointMath2 = [[PointMath alloc] initWithPoint:assisDropLater_LeftAssisPointMain inView:self];
                    pointMath2.radius = [NSNumber numberWithFloat:3.0f];
                    [_assisArray addObject:pointMath2];
                    
                    PointMath *pointMath3 = [[PointMath alloc] initWithPoint:assisDropNow_RightAssisPoint inView:self];
                    [_assisArray addObject:pointMath3];
                    
                    PointMath *pointMath4 = [[PointMath alloc] initWithPoint:assisDropNow_LeftAssisPoint inView:self];
                    pointMath2.radius = [NSNumber numberWithFloat:3.0f];
                    [_assisArray addObject:pointMath4];
                    
                    //  绘制大圆半圆弧
                    [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:radius_startMain endAngle:radius_endMain clockwise:YES];
                }
                
                //  完全分开，正常状态
                else if (centerDistace > normalThreshold) {
                
                    [dropView.bezierPath moveToPoint:CGPointMake(assisDropNow_center.x + assisDrop_now.circleMath.radius, assisDropNow_center.y)];
                    [dropView.bezierPath addArcWithCenter:assisDropNow_center radius:assisDrop_now.circleMath.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                    
                    if ([assisDrop_now isEqual:[smallDropViewArray lastObject]]) {
                        [dropView.bezierPath moveToPoint:CGPointMake(mainDrop_center.x + dropView.circleMath.radius, mainDrop_center.y)];
                        [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                    }
                }
            }
        }
            break;
            
        case kCross_SmallToMain:
        {
//            NSLog(@"kCross_SmallToMain-0");
//            NSArray *smallDropViewArray = [[NSArray alloc] initWithObjects:dropView.assisDrop1, dropView.assisDrop2, nil];
            NSArray *smallDropViewArray = [[NSArray alloc] initWithObjects:dropView.assisDrop1, dropView.assisDrop2, dropView.assisDrop3, dropView.assisDrop4, nil];
            for (int i = 0; i < [smallDropViewArray count]; i++) {
//                NSLog(@"kCross_SmallToMain-1");
                DropView *assisDrop_now = (DropView *)smallDropViewArray[i];
                DropView *assisDrop_later = (i+1) >= [smallDropViewArray count] ? (DropView *)smallDropViewArray[0] : (DropView *)smallDropViewArray[i+1];
                
                CALayer *assisDrop_PreLayer = assisDrop_now.layer.presentationLayer;
                CGPoint assisDropNow_center = [dropView convertPoint:assisDrop_PreLayer.position toView:self];
                CGPoint mainDrop_center = [dropView convertPoint:dropView.mainCenter toView:self];
                
                CGPoint assisDropNow_RightAssisPoint = [dropView convertPoint:assisDrop_now.crossToRightAssis_Point toView:self];
                CGPoint assisDropNow_RightAssisPointS = [dropView convertPoint:assisDrop_now.crossToRightAssis_PointS toView:self];
                CGPoint assisDropNow_RightAssisPointMain = [dropView convertPoint:assisDrop_now.crossToRightAssis_PointMain toView:self];
                
                CGPoint assisDropLater_LeftAssisPoint = [dropView convertPoint:assisDrop_later.crossToLeftAssis_Point toView:self];
                CGPoint assisDropLater_LeftAssisPointS = [dropView convertPoint:assisDrop_later.crossToLeftAssis_PointS toView:self];
                CGPoint assisDropLater_LeftAssisPointMain = [dropView convertPoint:assisDrop_later.crossToLeftAssis_PointMain toView:self];
                
                CGFloat radius_start = [DropView ConvertPointToRadiusInDropView:assisDrop_now point:assisDrop_now.crossToLeftAssis_PointS canvansView:self];
                CGFloat radius_end = [DropView ConvertPointToRadiusInDropView:assisDrop_now point:assisDrop_now.crossToRightAssis_PointS canvansView:self];
                
                
//                PointMath *pointMath1 = [[PointMath alloc] initWithPoint:assisDrop_now.crossToLeftAssis_PointS inView:dropView];
//                pointMath1.radius = [NSNumber numberWithInt:3];
//                [_assisArray addObject:pointMath1];
//                
//                PointMath *pointMath2 = [[PointMath alloc] initWithPoint:assisDrop_now.crossToLeftAssis_Point inView:dropView];
//                [_assisArray addObject:pointMath2];
//                
//                PointMath *pointMath3 = [[PointMath alloc] initWithPoint:assisDrop_now.crossToRightAssis_PointS inView:dropView];
//                pointMath3.radius = [NSNumber numberWithInt:3];
//                [_assisArray addObject:pointMath3];
                
//                PointMath *pointMath4 = [[PointMath alloc] initWithPoint:assisDrop_now.crossToRightAssis_Point inView:dropView];
//                [_assisArray addObject:pointMath4];

                //  绘制半圆弧
                [dropView.bezierPath addArcWithCenter:assisDropNow_center radius:assisDrop_now.circleMath.radius startAngle:radius_start endAngle:radius_end clockwise:YES];
                
                CGFloat dis_dropNowCenterToDropLaterLeft = [LineMath calucateDistanceBetweenPoint1:assisDropNow_center withPoint2:assisDropLater_LeftAssisPointS];
                CGFloat dis_dropNowCenterToDropNowRight = [LineMath calucateDistanceBetweenPoint1:assisDropNow_center withPoint2:assisDropNow_RightAssisPointS];
                CGFloat dis_dropNowCenterToMainCenterThreshold_Min = sqrt(assisDrop_now.circleMath.radius * assisDrop_now.circleMath.radius * 2);
                CGFloat dis_dropNowCenterToMainCenterThreshold_Max = dropView.circleMath.radius + assisDrop_now.circleMath.radius;
                CGFloat dis_dropNowCenterToMainCenterThreshold_Now = [LineMath calucateDistanceBetweenPoint1:assisDropNow_center withPoint2:mainDrop_center];
                
//                NSLog(@"dis_dropNowCenterToMainCenterThreshold_Min:%f", dis_dropNowCenterToMainCenterThreshold_Min);
//                NSLog(@"dis_dropNowCenterToMainCenterThreshold_Max:%f", dis_dropNowCenterToMainCenterThreshold_Max);
//                NSLog(@"dis_dropNowCenterToMainCenterThreshold_Now:%f", dis_dropNowCenterToMainCenterThreshold_Now);
                
                //  小圆和小圆仍有相交部分
//                if (dis_dropNowCenterToDropLaterLeft < dis_dropNowCenterToDropNowRight)
                if (true) {
                    CGFloat ratio = [LineMath calucateRatioBetweenMin:dis_dropNowCenterToMainCenterThreshold_Min Max:dis_dropNowCenterToMainCenterThreshold_Max Now:dis_dropNowCenterToMainCenterThreshold_Now];
                    ratio = 1 - ratio;
//                    NSLog(@"ratio111:%f", ratio);
                    
                    CGPoint centerPoint1 = [LineMath calucateCenterPointBetweenPoint1:assisDropNow_RightAssisPoint withPoint2:assisDropLater_LeftAssisPoint];
                    CGPoint centerPoint2 = [LineMath calucateCenterPointBetweenPoint1:assisDropNow_RightAssisPointS withPoint2:assisDropLater_LeftAssisPointS];
                    
                    TwoPointStruct assisControlPointStruct = [DropView PointBetweenPoint1:centerPoint1 point2:centerPoint2 ToPointRatio:ratio];
                    
                    TwoPointStruct assisControlPointStructLeft = [DropView PointBetweenPoint1:assisControlPointStruct.point2 point2:assisDropNow_RightAssisPointMain ToPointRatio:0.5];//1-ratio
                    TwoPointStruct assisControlPointStructRight = [DropView PointBetweenPoint1:assisControlPointStruct.point2 point2:assisDropLater_LeftAssisPointMain ToPointRatio:0.5];//1-ratio
                    
//                    [dropView.bezierPath addQuadCurveToPoint:assisDropLater_LeftAssisPointS controlPoint:assisControlPointStruct.point2];
                    [dropView.bezierPath addCurveToPoint:assisDropLater_LeftAssisPointS controlPoint1:assisControlPointStructLeft.point2 controlPoint2:assisControlPointStructRight.point2];
                    
                    
                    PointMath *pointMath1 = [[PointMath alloc] initWithPoint:centerPoint1 inView:self];
                    pointMath1.radius = [NSNumber numberWithFloat:2.0f];
                    [_assisArray addObject:pointMath1];
                    
                    PointMath *pointMath2 = [[PointMath alloc] initWithPoint:centerPoint2 inView:self];
                    pointMath2.radius = [NSNumber numberWithFloat:4.0f];
                    [_assisArray addObject:pointMath2];
                    
//                    PointMath *pointMath3 = [[PointMath alloc] initWithPoint:assisControlPointStruct.point2 inView:self];
//                    pointMath3.radius = [NSNumber numberWithFloat:6.0f];
//                    [_assisArray addObject:pointMath3];
                    
                    
                    
                    PointMath *pointMath4 = [[PointMath alloc] initWithPoint:assisDropNow_RightAssisPointS inView:self];
                    pointMath4.radius = [NSNumber numberWithFloat:6.0f];
                    [_assisArray addObject:pointMath4];
                }
                
                //  小圆和小圆没有相交部分
                else{
                    CGPoint centerPoint1 = [LineMath calucateCenterPointBetweenPoint1:assisDropNow_RightAssisPointS withPoint2:assisDropNow_RightAssisPointMain];
                    CGPoint centerPoint2 = [LineMath calucateCenterPointBetweenPoint1:assisDropLater_LeftAssisPointS withPoint2:assisDropLater_LeftAssisPointMain];
                    [dropView.bezierPath addCurveToPoint:assisDropLater_LeftAssisPointS controlPoint1:centerPoint1 controlPoint2:centerPoint2];
//                    [dropView.bezierPath addCurveToPoint:assisDropLater_LeftAssisPointS controlPoint1:assisDropNow_RightAssisPointMain controlPoint2:assisDropLater_LeftAssisPointMain];
                }
                
            }
        }
            break;
            
        case kCross_SmallToSmall:
        {
            NSArray *smallDropViewArray = [[NSArray alloc] initWithObjects:dropView.assisDrop1, dropView.assisDrop2, dropView.assisDrop3, dropView.assisDrop4, nil];
            for (int i = 0; i < [smallDropViewArray count]; i++) {
                
                DropView *assisDrop_now = (DropView *)smallDropViewArray[i];
                DropView *assisDrop_later = (i+1) >= [smallDropViewArray count] ? (DropView *)smallDropViewArray[0] : (DropView *)smallDropViewArray[i+1];
                
                CALayer *assisDrop_PreLayer = assisDrop_now.layer.presentationLayer;
                CGPoint assisDropNow_center = [dropView convertPoint:assisDrop_PreLayer.position toView:self];
                CGPoint assisDropLater_LeftAssisPoint = [dropView convertPoint:assisDrop_later.crossToLeftAssis_Point toView:self];
                CGPoint assisDropLater_LeftAssisPointS = [dropView convertPoint:assisDrop_later.crossToLeftAssis_PointS toView:self];
                
                CGFloat radius_start = [DropView ConvertPointToRadiusInDropView:assisDrop_now point:assisDrop_now.crossToLeftAssis_PointS canvansView:self];
                CGFloat radius_end = [DropView ConvertPointToRadiusInDropView:assisDrop_now point:assisDrop_now.crossToRightAssis_PointS canvansView:self];
                
                
                PointMath *centerPointMath = [[PointMath alloc] initWithPoint:assisDropNow_center inView:self];
                [_assisArray addObject:centerPointMath];
                
                //  绘制半圆弧
                [dropView.bezierPath addArcWithCenter:assisDropNow_center radius:assisDrop_now.circleMath.radius startAngle:radius_start endAngle:radius_end clockwise:YES];
                
                //  和下一个相连
                [dropView.bezierPath addQuadCurveToPoint:assisDropLater_LeftAssisPointS controlPoint:assisDropLater_LeftAssisPoint];
            }
        }
            break;
            
        default:
            break;
    }
    
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
    
    CGPoint MbezierControlPoint1_1 = [dropView convertPoint:dropView.bezierControlPoint1_1 toView:self];
    CGPoint MbezierControlPoint1_1C = [dropView convertPoint:dropView.bezierControlPoint1_1C toView:self];
    CGPoint MbezierControlPoint2_1 = [dropView convertPoint:dropView.bezierControlPoint2_1 toView:self];
    CGPoint MbezierControlPoint2_1C = [dropView convertPoint:dropView.bezierControlPoint2_1C toView:self];
    
    CGPoint SbezierControlPoint1_1 = [dropView convertPoint:dropView.smallDrop.bezierControlPoint1_1 toView:self];
    CGPoint SbezierControlPoint1_1C = [dropView convertPoint:dropView.smallDrop.bezierControlPoint1_1C toView:self];
    CGPoint SbezierControlPoint2_1 = [dropView convertPoint:dropView.smallDrop.bezierControlPoint2_1 toView:self];
    CGPoint SbezierControlPoint2_1C = [dropView convertPoint:dropView.smallDrop.bezierControlPoint2_1C toView:self];
    
    
    
    PointMath *point1 = [[PointMath alloc] initWithPoint:bezierControlPoint1 inView:self];
    point1.radius = [NSNumber numberWithFloat:6.0];
    [_assisArray addObject:point1];
    
    PointMath *point2 = [[PointMath alloc] initWithPoint:bezierControlPoint2 inView:self];
    point2.radius = [NSNumber numberWithFloat:6.0];
    [_assisArray addObject:point2];
    
    
    
    /******    MainDrop和SmallDrop 相交   ******/
    
    
        
    [dropView.bezierPath removeAllPoints];
    dropView.bezierPath.lineCapStyle = kCGLineCapRound;
    
    
    switch (dropView.circleRelation) {
            
            //两圆完全相离
        case kCircleSeparateEntire:
        {
            [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            [dropView.bezierPath addArcWithCenter:smallDrop_center radius:dropView.smallDrop.circleMath.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        }
            break;
            
            //两圆相离但变形
        case kCircleSeparateDeformation:
        {
            
        }
            break;
            
            //两圆相离，但相连
        case kCircleSeparateAndConnect:
        {
            //  MainDrop半圆
            LineMath *lineP1_MainCenter = [[LineMath alloc] initWithPoint1:MbezierControlPoint1_1C point2:mainDrop_center inView:self];
            LineMath *lineP2_MainCenter = [[LineMath alloc] initWithPoint1:MbezierControlPoint2_1C point2:mainDrop_center inView:self];
            
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
            //    [dropView.bezierPath addQuadCurveToPoint:bezierControlPoint1 controlPoint:MbezierControlPoint2_1];
            //    [dropView.bezierPath addCurveToPoint:SbezierControlPoint2_1 controlPoint1:MbezierControlPoint2_1 controlPoint2:bezierControlPoint1];
            
            //  MainDrop右侧到SmallDrop右侧的贝塞尔曲线
            //    LineMath *tempLine = [[LineMath alloc] initWithPoint1:mainEdgePoint2 point2:smallEdgePoint2 inView:self];
            //    [_assisArray addObject:tempLine];
            //    [dropView.bezierPath moveToPoint:MbezierControlPoint2_1];
            [dropView.bezierPath addQuadCurveToPoint:SbezierControlPoint2_1C controlPoint:bezierControlPoint1];
            //    [dropView.bezierPath addCurveToPoint:SbezierControlPoint2_1C controlPoint1:MbezierControlPoint2_1 controlPoint2:bezierControlPoint1];
            
            PointMath *pointMath1 = [[PointMath alloc] initWithPoint:MbezierControlPoint2_1 inView:self];
            [_assisArray addObject:pointMath1];
            
            //  SmallDrop右侧被塞尔圆滑过渡曲线
            //    [dropView.bezierPath addCurveToPoint:SbezierControlPoint2_1C controlPoint1:bezierControlPoint1 controlPoint2:SbezierControlPoint2_1];
            ////    [dropView.bezierPath moveToPoint:bezierControlPoint1];
            ////    [dropView.bezierPath addQuadCurveToPoint:SbezierControlPoint2_1C controlPoint:SbezierControlPoint2_1];
            //    PointMath *tempPointMath = [[PointMath alloc] initWithPoint:bezierControlPoint1 inView:self];
            //    [_assisArray addObject:tempPointMath];
            //
            //    PointMath *tempPointMath1 = [[PointMath alloc] initWithPoint:SbezierControlPoint2_1C inView:self];
            //    [_assisArray addObject:tempPointMath1];
            
            //  SmallDrop半圆
            LineMath *lineP1_SmallCenter = [[LineMath alloc] initWithPoint1:SbezierControlPoint1_1C point2:smallDrop_center inView:self];
            LineMath *lineP2_SmallCenter = [[LineMath alloc] initWithPoint1:SbezierControlPoint2_1C point2:smallDrop_center inView:self];
            
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
            //    LineMath *tempLine3 = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:smallEdgePoint1 inView:self];
            //    [_assisArray addObject:tempLine3];
            //
            //    [dropView.bezierPath addQuadCurveToPoint:smallEdgePoint1 controlPoint:smallEdgePoint1];
            
            //  SmallDrop左侧到MainDrop左侧的被塞尔曲线
            LineMath *tempLine4 = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:mainEdgePoint1 inView:self];
            [_assisArray addObject:tempLine4];
            
            [dropView.bezierPath addQuadCurveToPoint:MbezierControlPoint1_1C controlPoint:bezierControlPoint2];
        }
            break;
            
            //两圆相交
        case kCircleCross:
        {
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
            
            //  MainDrop Main
            [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:angleLine_MainP1 endAngle:angleLine_MainP2 clockwise:YES];
            
            //  MainDrop右侧到断开接点的贝塞尔曲线
            //    LineMath *tempLine = [[LineMath alloc] initWithPoint1:mainEdgePoint2 point2:smallEdgePoint2 inView:self];
            //    [_assisArray addObject:tempLine];
            //    [dropView.bezierPath moveToPoint:MbezierControlPoint2_1];
            [dropView.bezierPath addQuadCurveToPoint:smallEdgePoint2 controlPoint:bezierControlPoint1];
            //    [dropView.bezierPath addCurveToPoint:SbezierControlPoint2_1C controlPoint1:MbezierControlPoint2_1 controlPoint2:bezierControlPoint1];
            
            
            //  SmallDrop右侧被塞尔圆滑过渡曲线
            //    [dropView.bezierPath addCurveToPoint:SbezierControlPoint2_1C controlPoint1:bezierControlPoint1 controlPoint2:SbezierControlPoint2_1];
            ////    [dropView.bezierPath moveToPoint:bezierControlPoint1];
            ////    [dropView.bezierPath addQuadCurveToPoint:SbezierControlPoint2_1C controlPoint:SbezierControlPoint2_1];
            //    PointMath *tempPointMath = [[PointMath alloc] initWithPoint:bezierControlPoint1 inView:self];
            //    [_assisArray addObject:tempPointMath];
            //
            //    PointMath *tempPointMath1 = [[PointMath alloc] initWithPoint:SbezierControlPoint2_1C inView:self];
            //    [_assisArray addObject:tempPointMath1];
            
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
            
            
            //  SmallDrop左侧贝塞尔圆滑过渡曲线
            //    LineMath *tempLine3 = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:smallEdgePoint1 inView:self];
            //    [_assisArray addObject:tempLine3];
            //
            //    [dropView.bezierPath addQuadCurveToPoint:smallEdgePoint1 controlPoint:smallEdgePoint1];
            
            //  SmallDrop左侧到MainDrop左侧的被塞尔曲线
            LineMath *tempLine4 = [[LineMath alloc] initWithPoint1:smallEdgePoint1 point2:mainEdgePoint1 inView:self];
            [_assisArray addObject:tempLine4];
            
            [dropView.bezierPath addQuadCurveToPoint:mainEdgePoint1 controlPoint:bezierControlPoint2];
        }
            break;
            
            //两圆内含
        case kCircleContain:{
            [dropView.bezierPath addArcWithCenter:mainDrop_center radius:dropView.circleMath.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        }
            
            break;
            
        default:
            break;
    }
    
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
            [self drawPoint:pointMath];
        }
    }
}

//  画点
- (void)drawPoint:(PointMath *)pointMath
{
    CGPoint point = [pointMath.InView convertPoint:pointMath.point toView:self];
    CGFloat point_width = 10;
    
    if (pointMath.radius) {
        point_width = [pointMath.radius floatValue];
    }
    
    if (pointMath.color) {
        [pointMath.color setFill];
    }else{
        [[UIColor blackColor] setFill];
    }
    
    //1.获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.绘制图形
    CGContextAddEllipseInRect(context, CGRectMake(point.x - point_width/2, point.y - point_width/2, point_width, point_width));
    CGContextSetLineWidth(context, 2);
    
    CGContextFillPath(context);
}

@synthesize animationStatus = _animationStatus;
- (void)setAnimationStatus:(AnimationStatus)animationStatus
{
    _animationStatus = animationStatus;
//    _mainDrop.displayLink.paused = NO;
    
    //  开始动画
    if (_animationStatus == animationOpen) {
        
        //  底部按钮
        [UIView animateWithDuration:0.7
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                [_bottom_Btn setCenterY:self.height - _btnOffY_end - _btnWidth/2];
                                _bottom_Btn.transform = CGAffineTransformMakeRotation(M_PI / 4);
                                _bottomText_Img.alpha = 1;
                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  圆环
        [UIView animateWithDuration:0.4
                              delay:0.8
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                _ringBgView.alpha = 1;
                                
                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  AssisDrop
        [UIView animateWithDuration:1.4
                              delay:0.8 + 0.4
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
//                                [self assisDropShow];
                                
                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  Menu四周按钮
        [UIView animateWithDuration:0.6
                              delay:0.8 + 0.4 + 0.4
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                [self menuFourBtnAlpha1];
        } completion:^(BOOL finished) {
            
//                                _mainDrop.displayLink.paused = YES;
        }];
        
        
//        [_mainDrop assisDropShow];
        [self assisDropShow_1];

    }
    
    //  结束动画
    else if (_animationStatus == animationClose){
        
        //  Menu四周按钮
        [UIView animateWithDuration:1.6
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                [self menuFourBtnAlpha0];
//                                [self assisDropHidden];

                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  圆环
        [UIView animateWithDuration:0.4
                              delay:0.8
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                _ringBgView.alpha = 0;
                                
                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  底部按钮
        [UIView animateWithDuration:0.7
                              delay:0.8 + 0.4
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                [_bottom_Btn setCenterY:self.height - _btnOffY_start - _btnWidth/2];
                                _bottom_Btn.transform = CGAffineTransformMakeRotation(0);
                                _bottomText_Img.alpha = 0;
                            } completion:^(BOOL finished) {
//                                _mainDrop.displayLink.paused = YES;
                            }];
        
        
        [self assisDropHide_1];
//        [_mainDrop assisDropHidden];
        
    }
    
    
    
}

- (void)assisDropShow_1
{
    CGFloat centerX = _mainDrop.width/2.0;
    CGFloat centerY = _mainDrop.height/2.0;
    CGFloat during = 1.0f;
    
    __block int i = 0;
    CGFloat duration = 0.001f;   //间隔时间
    CGFloat     times = during/duration;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, duration * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        
        i++;
        if (i > times) {
            
            dispatch_source_cancel(timer);  //执行5次后停止
        }else{

            CGFloat deltaDistance = (_btnGapDistance / ((float)times * 1.0)) * i;
            
            _mainDrop.assisDrop1.center = CGPointMake(centerX - deltaDistance, centerY - deltaDistance);
            _mainDrop.assisDrop2.center = CGPointMake(centerX + deltaDistance, centerY - deltaDistance);
            _mainDrop.assisDrop3.center = CGPointMake(centerX + deltaDistance, centerY + deltaDistance);
            _mainDrop.assisDrop4.center = CGPointMake(centerX - deltaDistance, centerY + deltaDistance);
        }
    });
    dispatch_resume(timer);
}

- (void)assisDropHide_1
{
    CGFloat centerX = _mainDrop.width/2.0;
    CGFloat centerY = _mainDrop.height/2.0;
    CGFloat during = 1.0f;
    
    __block int i = 0;
    CGFloat duration = 0.001f;   //间隔时间
    int     times = during/duration;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, duration * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        
        i++;
        if (i > times) {
            
            dispatch_source_cancel(timer);  //执行5次后停止
        }else{
            
            CGFloat deltaDistance = (_btnGapDistance / ((float)times * 1.0)) * i;
            deltaDistance = _btnGapDistance - deltaDistance;
            
            _mainDrop.assisDrop1.center = CGPointMake(centerX - deltaDistance, centerY - deltaDistance);
            _mainDrop.assisDrop2.center = CGPointMake(centerX + deltaDistance, centerY - deltaDistance);
            _mainDrop.assisDrop3.center = CGPointMake(centerX + deltaDistance, centerY + deltaDistance);
            _mainDrop.assisDrop4.center = CGPointMake(centerX - deltaDistance, centerY + deltaDistance);
        }
    });
    dispatch_resume(timer);
}

//  AssisDrop动画Detail
- (void)assisDropShow
{
    CGFloat centerX = _mainDrop.width/2.0;
    CGFloat centerY = _mainDrop.height/2.0;
    CGFloat deltaDistance = _btnGapDistance;
//    CGFloat deltaDistance = 50;
    
    _mainDrop.assisDrop1.center = CGPointMake(centerX - deltaDistance, centerY - deltaDistance);
    _mainDrop.assisDrop2.center = CGPointMake(centerX + deltaDistance, centerY - deltaDistance);
    _mainDrop.assisDrop3.center = CGPointMake(centerX + deltaDistance, centerY + deltaDistance);
    _mainDrop.assisDrop4.center = CGPointMake(centerX - deltaDistance, centerY + deltaDistance);
}

- (void)assisDropHidden
{
    CGFloat centerX = _mainDrop.width/2.0;
    CGFloat centerY = _mainDrop.height/2.0;
    CGFloat deltaDistance = 0;
    
    _mainDrop.assisDrop1.center = CGPointMake(centerX - deltaDistance, centerY - deltaDistance);
    _mainDrop.assisDrop2.center = CGPointMake(centerX + deltaDistance, centerY - deltaDistance);
    _mainDrop.assisDrop3.center = CGPointMake(centerX + deltaDistance, centerY + deltaDistance);
    _mainDrop.assisDrop4.center = CGPointMake(centerX - deltaDistance, centerY + deltaDistance);
}


//  MenuBtn动画Detail
- (void)menuFourBtnAlpha0
{
    _menu1_Btn.alpha = 0;
    _menu2_Btn.alpha = 0;
    _menu3_Btn.alpha = 0;
    _menu4_Btn.alpha = 0;
}

- (void)menuFourBtnAlpha1
{
    _menu1_Btn.alpha = 1;
    _menu2_Btn.alpha = 1;
    _menu3_Btn.alpha = 1;
    _menu4_Btn.alpha = 1;
}

@end



