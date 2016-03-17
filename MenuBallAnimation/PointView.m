//
//  PointView.m
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PointView.h"

@interface PointView ()
@property (strong, nonatomic) UILabel   *titleLabel;

@end

@implementation PointView

- (instancetype)initWithPoint:(CGPoint)point
{
    CGFloat pointView_width = 4;
    self = [super initWithFrame:CGRectMake(point.x - pointView_width/2, point.y - pointView_width/2, pointView_width, pointView_width)];
    if (!self) {
        self = nil;
    }
    
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = pointView_width/2;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_titleLabel];
    
    return self;
}

@synthesize titleStr = _titleStr;
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    
    _titleLabel.text = titleStr;
    [_titleLabel sizeToFit];
    [_titleLabel BearSetRelativeLayoutWithDirection:kDIR_UP destinationView:nil parentRelation:YES distance:5 center:YES];
}

@end
