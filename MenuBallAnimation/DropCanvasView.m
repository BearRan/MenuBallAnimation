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
    UIView          *_mainDropBgView;
    UIView          *_ringBgView;
    CAShapeLayer    *_ringStrokeLayer;
    CAShapeLayer    *_ringFillingLayer;
    UIColor         *_ringColor;
    UIColor         *_centerBtnColor;
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
    _centerBtnColor = RGB(116, 196, 203);
}

- (void)createMainDrop
{
    _mainDrop = [[DropView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth) createSmallDrop:YES];
    _mainDrop.dropSuperView = self;
    _mainDrop.fillColor = _centerBtnColor;
    [self addSubview:_mainDrop];
    [_mainDrop BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
    
    [self createRingUI];
    
    _mainDropBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _mainDropBgView.backgroundColor = [UIColor clearColor];
    _mainDropBgView.hidden = YES;
    [_mainDropBgView.layer addSublayer:_mainDrop.dropShapLayer];
    [self addSubview:_mainDropBgView];
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
    UIColor *btnBackgroundColor_white = [UIColor whiteColor];
    UIColor *btnBackgroundColor_clear = [UIColor clearColor];
    
    //  TextField
    _textField = [[UITextField alloc] init];
    _textField.text = @"iOS动效特工队";
    _textField.font = [UIFont systemFontOfSize:20];
    _textField.textColor = [UIColor whiteColor];
    _textField.alpha = 0;
    [_textField sizeToFit];
    [self addSubview:_textField];
    [_textField BearSetRelativeLayoutWithDirection:kDIR_DOWN destinationView:nil parentRelation:YES distance:_textImg_offY center:YES];
    
    //  _bottomText_Img
//    _bottomText_Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vidaHouse_Text"]];
    _bottomText_Img.alpha = 0;
    [self addSubview:_bottomText_Img];
    [_bottomText_Img BearSetRelativeLayoutWithDirection:kDIR_DOWN destinationView:nil parentRelation:YES distance:_textImg_offY center:YES];
    
    //  _bottom_Btn
    _bottom_Btn = [[AddButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _bottom_Btn.backgroundColor = btnBackgroundColor_white;
    _bottom_Btn.layer.cornerRadius = _btnWidth/2.0f;
    _bottom_Btn.layer.masksToBounds = YES;
    [self addSubview:_bottom_Btn];
    [_bottom_Btn BearSetRelativeLayoutWithDirection:kDIR_DOWN destinationView:nil parentRelation:YES distance:_btnOffY_start center:YES];
    
    
    //  _menuCenter_Btn
    _menuCenter_Btn = [[MenuCenterBtn alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menuCenter_Btn.backgroundColor = _centerBtnColor;
    _menuCenter_Btn.layer.cornerRadius = _btnWidth/2.0f;
    _menuCenter_Btn.hidden = YES;
    [self addSubview:_menuCenter_Btn];
    [_menuCenter_Btn BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
    
    _menuCenter_Btn.btnImage.alpha = 0;
    _menuCenter_Btn.btnImage.image = [UIImage imageNamed:@"BtnIcon_Note"];
    [_menuCenter_Btn.btnImage sizeToFit];
    [_menuCenter_Btn.btnImage BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
    
    
    //  _menu1_btn
    _menu1_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menu1_Btn.backgroundColor = btnBackgroundColor_clear;
    _menu1_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menu1_Btn setImage:[UIImage imageNamed:@"BtnIcon_Users"] forState:UIControlStateNormal];
    [self addSubview:_menu1_Btn];
    [_menu1_Btn setCenter:CGPointMake(_menuCenter_Btn.centerX - deltaGap, _menuCenter_Btn.centerY - deltaGap)];
    
    //  _menu2_btn
    _menu2_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menu2_Btn.backgroundColor = btnBackgroundColor_clear;
    _menu2_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menu2_Btn setImage:[UIImage imageNamed:@"BtnIcon_ShoppingBag"] forState:UIControlStateNormal];
    [self addSubview:_menu2_Btn];
    [_menu2_Btn setCenter:CGPointMake(_menuCenter_Btn.centerX + deltaGap, _menuCenter_Btn.centerY - deltaGap)];
    
    //  _menu3_btn
    _menu3_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menu3_Btn.backgroundColor = btnBackgroundColor_clear;
    _menu3_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menu3_Btn setImage:[UIImage imageNamed:@"BtnIcon_Write"] forState:UIControlStateNormal];
    [self addSubview:_menu3_Btn];
    [_menu3_Btn setCenter:CGPointMake(_menuCenter_Btn.centerX - deltaGap, _menuCenter_Btn.centerY + deltaGap)];
    
    //  _menu4_btn
    _menu4_Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
    _menu4_Btn.backgroundColor = btnBackgroundColor_clear;
    _menu4_Btn.layer.cornerRadius = _btnWidth/2.0f;
    [_menu4_Btn setImage:[UIImage imageNamed:@"BtnIcon_UserSingle"] forState:UIControlStateNormal];
    [self addSubview:_menu4_Btn];
    [_menu4_Btn setCenter:CGPointMake(_menuCenter_Btn.centerX + deltaGap, _menuCenter_Btn.centerY + deltaGap)];
    
    [self menuFourBtnAlpha0];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self drawDropView:_mainDrop];
//    [self drawAssistantLine];
}


- (void)drawDropView:(DropView *)dropView
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
                    
                    CGFloat deltaValue  = normalThreshold - reduceThreshold;
                    CGFloat deltaNow    = centerDistace - reduceThreshold;
                    CGFloat ratio       = deltaNow / deltaValue;
                    
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
                    
                    
                    //  同一个Drop左右两侧assisRatio
                    CGFloat assisPointStruct_ratio = [LineMath calucateValueBetweenMin:-0.3 Max:0.6 Ratio:1 - ratio];

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
                    [dropView.bezierPath addCurveToPoint:assisDropNow_LeftAssisPoint controlPoint1:assisPointStruct_Left.point2 controlPoint2:assisPointStruct_Left.point1];
                    
                    
                    //  绘制小圆半圆弧
                    [dropView.bezierPath addArcWithCenter:assisDropNow_center radius:assisDrop_now.circleMath.radius startAngle:radius_start endAngle:radius_end clockwise:YES];
                    
                    //  小圆到大圆贝塞尔曲线
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
            NSArray *smallDropViewArray = [[NSArray alloc] initWithObjects:dropView.assisDrop1, dropView.assisDrop2, dropView.assisDrop3, dropView.assisDrop4, nil];
            for (int i = 0; i < [smallDropViewArray count]; i++) {
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
                

                //  绘制半圆弧
                [dropView.bezierPath addArcWithCenter:assisDropNow_center radius:assisDrop_now.circleMath.radius startAngle:radius_start endAngle:radius_end clockwise:YES];
                
//                CGFloat dis_dropNowCenterToDropLaterLeft = [LineMath calucateDistanceBetweenPoint1:assisDropNow_center withPoint2:assisDropLater_LeftAssisPointS];
//                CGFloat dis_dropNowCenterToDropNowRight = [LineMath calucateDistanceBetweenPoint1:assisDropNow_center withPoint2:assisDropNow_RightAssisPointS];
                CGFloat dis_dropNowCenterToMainCenterThreshold_Min = sqrt(assisDrop_now.circleMath.radius * assisDrop_now.circleMath.radius * 2);
                CGFloat dis_dropNowCenterToMainCenterThreshold_Max = dropView.circleMath.radius + assisDrop_now.circleMath.radius;
                CGFloat dis_dropNowCenterToMainCenterThreshold_Now = [LineMath calucateDistanceBetweenPoint1:assisDropNow_center withPoint2:mainDrop_center];
                
                //  小圆和小圆没有相交部分
                
                if (true) {
                    CGFloat ratio = [LineMath calucateRatioBetweenMin:dis_dropNowCenterToMainCenterThreshold_Min Max:dis_dropNowCenterToMainCenterThreshold_Max Now:dis_dropNowCenterToMainCenterThreshold_Now];
                    ratio = 1 - ratio;
                    
                    CGPoint centerPoint1 = [LineMath calucateCenterPointBetweenPoint1:assisDropNow_RightAssisPoint withPoint2:assisDropLater_LeftAssisPoint];
                    CGPoint centerPoint2 = [LineMath calucateCenterPointBetweenPoint1:assisDropNow_RightAssisPointS withPoint2:assisDropLater_LeftAssisPointS];
                    
                    TwoPointStruct assisControlPointStruct = [DropView PointBetweenPoint1:centerPoint1 point2:centerPoint2 ToPointRatio:ratio];
                    
                    TwoPointStruct assisControlPointStructLeft = [DropView PointBetweenPoint1:assisControlPointStruct.point2 point2:assisDropNow_RightAssisPointMain ToPointRatio:0.5];//1-ratio
                    TwoPointStruct assisControlPointStructRight = [DropView PointBetweenPoint1:assisControlPointStruct.point2 point2:assisDropLater_LeftAssisPointMain ToPointRatio:0.5];//1-ratio
                    
                    [dropView.bezierPath addCurveToPoint:assisDropLater_LeftAssisPointS controlPoint1:assisControlPointStructLeft.point2 controlPoint2:assisControlPointStructRight.point2];
                    
                    
                    PointMath *pointMath1 = [[PointMath alloc] initWithPoint:centerPoint1 inView:self];
                    pointMath1.radius = [NSNumber numberWithFloat:2.0f];
                    [_assisArray addObject:pointMath1];
                    
                    PointMath *pointMath2 = [[PointMath alloc] initWithPoint:centerPoint2 inView:self];
                    pointMath2.radius = [NSNumber numberWithFloat:4.0f];
                    [_assisArray addObject:pointMath2];
                    
                    PointMath *pointMath4 = [[PointMath alloc] initWithPoint:assisDropNow_RightAssisPointS inView:self];
                    pointMath4.radius = [NSNumber numberWithFloat:6.0f];
                    [_assisArray addObject:pointMath4];
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


- (void)delayBlockTime:(CGFloat)delay event:(void (^) ())event
{
    //  中间按钮
    CGFloat delayTime = delay;   //延时时间
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime *NSEC_PER_SEC));
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        
        if (event) {
            event();
        }
    });
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
                                _textField.alpha = 1;
                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  中间按钮
        [self delayBlockTime:0.9 event:^{
            
            _menuCenter_Btn.hidden = NO;
            _menuCenter_Btn.alpha = 1;
            
            CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
            bounceAnimation.keyPath = @"transform.scale";
            bounceAnimation.duration = 0.6f;
            bounceAnimation.values = @[@0.0, @0.6, @0.8, @1.0, @1.1, @1.2, @1.1, @1.0, @0.9, @1.0];
            [_menuCenter_Btn.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
        }];
        
        //  中间按钮的icon
        [UIView animateWithDuration:0.5
                              delay:1.3
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                _menuCenter_Btn.btnImage.alpha = 1;
                            }completion:^(BOOL finished) {
                             
                            }];
        

        //  圆环
        [UIView animateWithDuration:0.4
                              delay:1.8
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                _ringBgView.alpha = 1;
                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  AssisDrop
        [self delayBlockTime:1.8 event:^{
            
            _mainDropBgView.hidden = NO;
            [self assisDropShow_1];
        }];
        
        //  显示四周MenuBtn
        [UIView animateWithDuration:0.4
                              delay:1.8 + 0.6 + 0.2
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                [self menuFourBtnAlpha1];
                            } completion:^(BOOL finished) {
                                
                            }];

    }
    
    //  结束动画
    else if (_animationStatus == animationClose){
        
        //  Menu四周按钮
        [UIView animateWithDuration:1.6
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                [self menuFourBtnAlpha0];

                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  AssisDrop
        [self delayBlockTime:0 event:^{
            
            [self assisDropHide_1];
        }];

        [self delayBlockTime:0.7 event:^{
            
            _mainDropBgView.hidden = YES;
        }];

        
        //  圆环
        [UIView animateWithDuration:0.4
                              delay:0.7
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                _ringBgView.alpha = 0;
                            } completion:^(BOOL finished) {
                                
                            }];
        
        //  中间按钮的icon
        [UIView animateWithDuration:0.4
                              delay:0.85
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                _menuCenter_Btn.alpha = 0;
                            }completion:^(BOOL finished) {
                                _menuCenter_Btn.hidden = YES;
                                _menuCenter_Btn.btnImage.alpha = 0;
                            }];
        
        //  底部按钮
        [UIView animateWithDuration:0.7
                              delay:0.7
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                [_bottom_Btn setCenterY:self.height - _btnOffY_start - _btnWidth/2];
                                _bottom_Btn.transform = CGAffineTransformMakeRotation(0);
                                _bottomText_Img.alpha = 0;
                                _textField.alpha = 0;
                            } completion:^(BOOL finished) {

                            }];
        
    }
}

- (void)assisDropShow_1
{
    CGFloat centerX = _mainDrop.width/2.0;
    CGFloat centerY = _mainDrop.height/2.0;
    CGFloat during = 0.6f;
    
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
    CGFloat during = 0.6f;
    
    __block int i = 0;
    CGFloat duration = 0.001f;   //间隔时间
    int     times = during/duration;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, duration * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        
        i++;
        if (i > times) {
            
            dispatch_source_cancel(timer);  //执行times次后停止
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



