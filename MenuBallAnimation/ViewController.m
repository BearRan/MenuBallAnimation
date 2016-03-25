//
//  ViewController.m
//  MenuBallAnimation
//
//  Created by Bear on 16/3/17.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import "ViewController.h"
#import "DropCanvasView.h"

@interface ViewController (){
    DropCanvasView *dropCanvasView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bgImageView.image = [UIImage imageNamed:@"BackGroundImg"];
    [self.view addSubview:bgImageView];
    
    dropCanvasView = [[DropCanvasView alloc] initWithFrame:self.view.bounds];
    [dropCanvasView.bottom_Btn addTarget:self action:@selector(bottomBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [dropCanvasView.menuCenter_Btn addTarget:self action:@selector(menuCenterBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dropCanvasView];
    
    
}

- (void)bottomBtnEvent
{
    if (dropCanvasView.animationStatus == animationOpen) {
        dropCanvasView.animationStatus = animationClose;
    }else{
        dropCanvasView.animationStatus = animationOpen;
    }
}

- (void)menuCenterBtnEvent
{
    if (dropCanvasView.animationStatus == animationOpen) {
        dropCanvasView.animationStatus = animationClose;
    }else{
        dropCanvasView.animationStatus = animationOpen;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
