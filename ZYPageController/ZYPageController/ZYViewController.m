//
//  ZYViewController.m
//  ZYPageController
//
//  Created by 朝阳 on 2018/3/1.
//  Copyright © 2018年 sunny. All rights reserved.
//

#import "ZYViewController.h"
#import "MonkeyViewController.h"
#import "DogViewController.h"
#import "CatViewController.h"
#import "CowViewController.h"
#import "ElephantViewController.h"
#import "RabbitViewController.h"
#import "AntViewController.h"

@interface ZYViewController ()

@end

@implementation ZYViewController

- (void)viewDidLoad {
    // 调用父类的viewDidLoad
    [super viewDidLoad];
    // 添加所有子控制器
    [self createAllChildViewController];
    // 当调用玩viewDidLoad后,就会调用viewWillAppear:方法,此类没有该方法,就会去父类找
}

- (void)createAllChildViewController
{
    MonkeyViewController *monkeyVC = [[MonkeyViewController alloc] init];
    //    在这里设置背景颜色不好,因为当程序运行后,所有的控制器中的内容都加载了出来.应该点击对应的标题按钮后再去加载,因此把颜色设置在对应控制器的viewDidload里
    //    monkeyVC.view.backgroundColor = [UIColor redColor];
    monkeyVC.title = @"猴子";
    [self addChildViewController:monkeyVC];
    
    DogViewController *dogVC = [[DogViewController alloc] init];
    dogVC.title = @"狗狗";
    [self addChildViewController:dogVC];
    
    CatViewController *catVC = [[CatViewController alloc] init];
    catVC.title = @"猫咪";
    [self addChildViewController:catVC];
    
    CowViewController *cowVC = [[CowViewController alloc] init];
    cowVC.title = @"奶牛";
    [self addChildViewController:cowVC];
    
    ElephantViewController *elephantVC = [[ElephantViewController alloc] init];
    elephantVC.title = @"大象";
    [self addChildViewController:elephantVC];
    
    RabbitViewController *rabbitVC = [[RabbitViewController alloc] init];
    rabbitVC.title = @"兔子";
    [self addChildViewController:rabbitVC];
    
    AntViewController *antVC = [[AntViewController alloc] init];
    antVC.title = @"蚂蚁";
    [self addChildViewController:antVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
