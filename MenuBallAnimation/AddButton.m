//
//  AddButton.m
//  MenuBallAnimation
//
//  Created by apple on 16/3/24.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import "AddButton.h"

@implementation AddButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        self = nil;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat offStart    = (17 / 94.0) * self.width;
    CGFloat lineThick   = 1.5f;
    UIColor *lineColor  = [UIColor colorWithRed:53/255.0 green:57/255.0 blue:70/255.0 alpha:1];
    
    [self drawLineWithLayer:CGPointMake(offStart, self.height/2.0) endPoint:CGPointMake(self.width - offStart, self.height/2.0) lineWidth:lineThick lineColor:lineColor];
    [self drawLineWithLayer:CGPointMake(self.width/2.0, offStart) endPoint:CGPointMake(self.width/2.0, self.height - offStart) lineWidth:lineThick lineColor:lineColor];
}

@end
