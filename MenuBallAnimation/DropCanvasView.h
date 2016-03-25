//
//  DropCanvasView.h
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddButton.h"

static CGFloat normalThreshold = 170 / 80.0 * 50;
static CGFloat reduceThreshold = 140 / 80.0 * 50;

typedef enum {
    animationOpen,
    animationClose,
}AnimationStatus;

@interface DropCanvasView : UIView

@property (assign, nonatomic) int kkk;
@property (assign, nonatomic) AnimationStatus   animationStatus;
@property (strong, nonatomic) NSMutableArray    *assisArray;

@property (strong, nonatomic) AddButton *bottom_Btn;
@property (strong, nonatomic) UIButton  *menu1_Btn;
@property (strong, nonatomic) UIButton  *menu2_Btn;
@property (strong, nonatomic) UIButton  *menu3_Btn;
@property (strong, nonatomic) UIButton  *menu4_Btn;
@property (strong, nonatomic) UIButton  *menuCenter_Btn;

@end
