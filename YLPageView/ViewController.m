//
//  ViewController.m
//  YLPageView
//
//  Created by eviloo7 on 16/3/4.
//  Copyright © 2016年 eviloo7. All rights reserved.
//

#import "ViewController.h"
#import "YLPageView.h"
@interface ViewController ()<YLPageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLPageView *pageView = [[YLPageView alloc] init];
    pageView.frame = CGRectMake(0, 100, 414, 120);
    pageView.pageNumber = 4;
    pageView.iconRowNumber = 5;
    pageView.pageViewStyle = YLPageViewStyleImage;
    pageView.dataImages = @[@"liqin_0",@"liqin_1",@"liqin_2",@"liqin_3"];
    pageView.dataText = @[@"liqin_0",@"liqin_2",@"liqin_2",@"liqin_2"];
//    pageView.autoRepeat = YES;
    [self.view addSubview:pageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
