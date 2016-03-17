//
//  ViewController.m
//  MenuBallAnimation
//
//  Created by Bear on 16/3/17.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import "ViewController.h"
#import "MenuBallView.h"
#import "DropCanvasView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    MenuBallView *menuBalllView = [[MenuBallView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//    [self.view addSubview:menuBalllView];
    
    DropCanvasView *dropCanvasView = [[DropCanvasView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:dropCanvasView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
