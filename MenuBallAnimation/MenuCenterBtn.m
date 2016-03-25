//
//  MenuCenterBtn.m
//  MenuBallAnimation
//
//  Created by apple on 16/3/25.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import "MenuCenterBtn.h"

@implementation MenuCenterBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) {
        self = nil;
    }
    
    _btnImage = [[UIImageView alloc] init];
    [self addSubview:_btnImage];
    
    return self;
}

@end
