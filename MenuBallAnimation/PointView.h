//
//  PointView.h
//  DropAnimation
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointView : UIView

@property (strong, nonatomic) NSString *titleStr;

- (instancetype)initWithPoint:(CGPoint)point;

@end
