//
//  DropCanvasView.h
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat normalThreshold = 170 / 80.0 * 50;
static CGFloat reduceThreshold = 140 / 80.0 * 50;

@interface DropCanvasView : UIView

@property (strong, nonatomic) NSMutableArray    *assisArray;

@end
