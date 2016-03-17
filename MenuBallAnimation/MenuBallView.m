//
//  MenuBallView.m
//  MenuBallAnimation
//
//  Created by Bear on 16/3/17.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import "MenuBallView.h"

@interface MenuBallView ()
{
    UIButton *_mainBtn;
    UIButton *_subBtn1;
    UIButton *_subBtn2;
    UIButton *_subBtn3;
    UIButton *_subBtn4;
}

@end

@implementation MenuBallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = nil;
    }
    
    [self createUI];
    
    return self;
}

- (void)createUI
{
    self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    
    CGFloat mainBtn_width = 100;
    CGFloat subBtn_width = 70;
    
    _mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainBtn_width, mainBtn_width)];
    _mainBtn.backgroundColor = [UIColor orangeColor];
    _mainBtn.layer.cornerRadius = mainBtn_width/2;
    [self addSubview:_mainBtn];
    [_mainBtn BearSetCenterToParentViewWithAxis:kAXIS_X_Y];
    
    _subBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(_mainBtn.x - 70, _mainBtn.y - 70, subBtn_width, subBtn_width)];
    _subBtn1.backgroundColor = [UIColor redColor];
    _subBtn1.layer.cornerRadius = subBtn_width/2;
    [self addSubview:_subBtn1];
}

- (void)testBtn
{

}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
