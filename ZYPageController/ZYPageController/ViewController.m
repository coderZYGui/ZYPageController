//
//  ViewController.m
//  ZYPageController
//
//  Created by 朝阳 on 2018/3/1.
//  Copyright © 2018年 sunny. All rights reserved.
//

#import "ViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UIScrollViewDelegate>

/** titleScrollView */
@property(nonatomic, weak) UIScrollView * titleScrollView;
/** contentScrollView */
@property(nonatomic, weak) UIScrollView * contentScrollView;
/** 记录当前点击的button */
@property(nonatomic, weak) UIButton * selectBtn;
/** 保存标题按钮 */
@property(nonatomic, strong) NSMutableArray * btnArray;

@property (nonatomic, assign) BOOL isInitialize;

@end

@implementation ViewController

- (NSMutableArray *)btnArray
{
    if (_btnArray == nil) {
        NSMutableArray *btnArray = [NSMutableArray array];
        _btnArray = btnArray;
    }
    return _btnArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置标题. 判断只设置一次
    if (_isInitialize == NO) {
        
        [self createAllTitle];
        _isInitialize = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Zoo";
    //1. 创建标题scrollView
    [self createTitleScrollView];
    //2. 创建内容scrollView
    [self createContentScrollView];
    //3. 添加控制器到内容scrollView
//    [self createAllChildViewController];
    //4. 设置所有标题
    //    [self createAllTitle];
    //5. 标题点击
    //6. 处理内容滚动,视图滚动(监听scrollView的滚动)
    //7. 选中标题居中
    //8. 标题缩放及颜色渐变
    
}

#pragma -mark UIScrollViewDelegate
// 正在滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //① 字体缩放 1.缩放比例 2.缩放哪两个按钮
    //根据偏移量来获取按钮的角标
    NSInteger leftI = scrollView.contentOffset.x / ScreenW;
    NSInteger rightI = leftI + 1;
    //获取左边的按钮
    UIButton *leftBtn = self.btnArray[leftI];
    //获取右边的按钮
    //防止越界
    UIButton *rightBtn;
    if (rightI < self.btnArray.count) {
        rightBtn = self.btnArray[rightI];
    }
    //    NSLog(@"%@",self.btnArray);
    
    // 缩放比例 0 ~ 1 => 1 ~ 1.3 (最大为1.3)
    CGFloat scaleR = scrollView.contentOffset.x / ScreenW;
    // 始终保持缩放比例为0 ~ 1
    scaleR -= leftI;
    //NSLog(@"%f",scaleR * 0.3 + 1);
    CGFloat scaleL = 1 - scaleR;
    //NSLog(@"%f",scaleL);
    
    //缩放按钮
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * 0.3 + 1, scaleL * 0.3 + 1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * 0.3 + 1, scaleR * 0.3 + 1);
    
    //② 颜色渐变
    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    
    /*
     白色 1 1 1
     黑色 0 0 0
     红色 1 0 0
     */
}

// 滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //根据偏移量获取角标
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    UIButton *button = self.btnArray[index];
    [self switchColor:button];
    [self addOneViewController:index];
}

#pragma -mark 设置标题居中
- (void)setTitleCenter:(UIButton *)button
{
    //本质是设置标题的偏移量
    CGFloat offsetX = button.center.x - ScreenW * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 按钮最大偏移量
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - ScreenW;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma -mark 切换颜色
- (void)switchColor:(UIButton *)button
{
    self.selectBtn.transform = CGAffineTransformIdentity;
    [self.selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    // 设置标题居中
    [self setTitleCenter:button];
    // 设置标题文字缩放
    button.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.selectBtn = button;
}

#pragma -mark 添加一个控制器view
static CGFloat x;
- (void)addOneViewController:(NSInteger)i
{
    UIViewController *vc = self.childViewControllers[i];
    // 如果此时view的控制器已经添加到contentScrollView上,不再重复添加
    //if (vc.viewIfLoaded) {
    if(vc.view.superview){
        return;
    }
    x = i * ScreenW;
    vc.view.frame = CGRectMake(x, 0, ScreenW, self.contentScrollView.bounds.size.height);
    
    [self.contentScrollView addSubview:vc.view];
}

#pragma -mark 标题点击方法
- (void)titleBtnClick:(UIButton *)button
{
    
    //1. 点击标题让标题变成红色
    [self switchColor:button];
    //2. 点击某个标题将对应的控制器view添加到contentScroll上
    [self addOneViewController:button.tag];
    //3. 点击哪个标题btn,显示对应控制器的view
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

#pragma -mark 创建所有标题
- (void)createAllTitle
{
    NSInteger count = self.childViewControllers.count;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = 100;
    CGFloat btnH = self.titleScrollView.bounds.size.height;
    
    for (NSInteger i = 0; i < count; ++i) {
        
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        [titleBtn setTitle:vc.title forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnX = i * btnW;
        titleBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [self titleBtnClick:titleBtn];
        }
        
        [self.btnArray addObject:titleBtn];
        [self.titleScrollView addSubview:titleBtn];
        //        NSLog(@"%@",self.btnArray);
    }
    
    // 设置titleScrollView滚动范围
    self.titleScrollView.contentSize = CGSizeMake(count * btnW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    // 设置内容的滚动范围
    self.contentScrollView.contentSize = CGSizeMake(count * ScreenW, 0);
}

#pragma -mark 添加所有的子控制器
//- (void)createAllChildViewController
//{
//    MonkeyViewController *monkeyVC = [[MonkeyViewController alloc] init];
//    //    在这里设置背景颜色不好,因为当程序运行后,所有的控制器中的内容都加载了出来.应该点击对应的标题按钮后再去加载,因此把颜色设置在对应控制器的viewDidload里
//    //    monkeyVC.view.backgroundColor = [UIColor redColor];
//    monkeyVC.title = @"猴子";
//    [self addChildViewController:monkeyVC];
//
//    DogViewController *dogVC = [[DogViewController alloc] init];
//    dogVC.title = @"狗狗";
//    [self addChildViewController:dogVC];
//
//    CatViewController *catVC = [[CatViewController alloc] init];
//    catVC.title = @"猫咪";
//    [self addChildViewController:catVC];
//
//    CowViewController *cowVC = [[CowViewController alloc] init];
//    cowVC.title = @"奶牛";
//    [self addChildViewController:cowVC];
//
//    ElephantViewController *elephantVC = [[ElephantViewController alloc] init];
//    elephantVC.title = @"大象";
//    [self addChildViewController:elephantVC];
//
//    RabbitViewController *rabbitVC = [[RabbitViewController alloc] init];
//    rabbitVC.title = @"兔子";
//    [self addChildViewController:rabbitVC];
//
//}

#pragma -mark 标题scrollView
- (void)createTitleScrollView
{
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    
    CGFloat y = self.navigationController.navigationBarHidden ? 20 : 64;
    titleScrollView.frame = CGRectMake(0, y, ScreenW, 44);
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
    
}

#pragma -mark 内容scrollView
- (void)createContentScrollView
{
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    contentScrollView.frame = CGRectMake(0, y, ScreenW, self.view.bounds.size.height - y);
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}

@end
