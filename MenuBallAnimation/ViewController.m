//
//  ViewController.m
//  MenuBallAnimation
//
//  Created by Bear on 16/3/17.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import "ViewController.h"
#import "DropCanvasView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bgImageView.image = [UIImage imageNamed:@"BackGroundImg"];
    [self.view addSubview:bgImageView];
    
    DropCanvasView *dropCanvasView = [[DropCanvasView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:dropCanvasView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
