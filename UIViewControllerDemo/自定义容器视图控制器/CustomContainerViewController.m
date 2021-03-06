//
//  CustomContainerViewController.m
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/1/18.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import "CustomContainerViewController.h"

@interface CustomContainerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIScrollView *contentView;

@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSArray<NSString *> *titleArray;

@property (strong, nonatomic) NSArray<UIViewController *> *viewControllers;

@end


@implementation CustomContainerViewController

- (void)dealloc
{
    NSLog(@"\n *** dealloc *** : %@", self);
}


- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray viewControllers:(NSArray <UIViewController *>*)viewControllers
{
    self = [super init];
    
    if (self)
    {
        self.titleArray = titleArray;
        
        self.viewControllers = viewControllers;
        
        self.currentIndex = 0;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *titleLabel = [cell.contentView viewWithTag:10086];
    
    if (titleLabel == nil)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 60.0)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = 10086;
        [cell.contentView addSubview:titleLabel];
    }
    
    titleLabel.text = self.titleArray[indexPath.row];
    
    titleLabel.textColor = self.currentIndex == indexPath.row ? [UIColor redColor] : [UIColor blackColor];
    
    return cell;
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger oldIndex = self.currentIndex;
    
    self.currentIndex = indexPath.row;
    
    [self.collectionView reloadData];
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self.contentView setContentOffset:CGPointMake(self.contentView.frame.size.width*self.currentIndex, 0) animated:NO];
    
    UIViewController *currentChildVC = self.viewControllers[oldIndex];
    
    UIViewController *childVC = self.viewControllers[self.currentIndex];
    
    [self hideChildViewController:currentChildVC];
    
    [self displayChildViewController:childVC atIndex:self.currentIndex];
}


#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentView)
    {
        int index = (int)(scrollView.contentOffset.x/scrollView.frame.size.width);
        
        NSInteger oldIndex = self.currentIndex;
        
        self.currentIndex = index;
        
        [self.collectionView reloadData];
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        UIViewController *currentChildVC = self.viewControllers[oldIndex];
        
        UIViewController *childVC = self.viewControllers[self.currentIndex];
        
        [self hideChildViewController:currentChildVC];
        
        [self displayChildViewController:childVC atIndex:self.currentIndex];
    }
}

#pragma mark- Methods
- (void)setUI
{
    self.title = @"自定义容器视图控制器";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(90.0, 50.0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height == self.view.frame.size.height ? self.navigationController.navigationBar.subviews.firstObject.frame.size.height : 0.0, self.view.frame.size.width, 50.0) collectionViewLayout:flowLayout];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator   = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.collectionView.frame.origin.y + self.collectionView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.collectionView.frame.origin.y - self.collectionView.frame.size.height)];
    self.contentView.delegate = self;
    self.contentView.showsHorizontalScrollIndicator = YES;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.contentSize = CGSizeMake(self.viewControllers.count*self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.contentView.pagingEnabled = YES;
    self.contentView.bounces = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    UIViewController *vc = self.viewControllers.firstObject;
    
    [self displayChildViewController:vc atIndex:self.currentIndex];
}

- (void)displayChildViewController:(UIViewController *)childViewController atIndex:(NSInteger)index
{
    [self addChildViewController:childViewController];
    
    childViewController.view.frame = CGRectMake(self.contentView.frame.size.width*index, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    [self.contentView addSubview:childViewController.view];
    
    [childViewController didMoveToParentViewController:self];
}

- (void)hideChildViewController:(UIViewController *)childViewController
{
    [childViewController willMoveToParentViewController:nil];
    
    [childViewController.view removeFromSuperview];
    
    [childViewController removeFromParentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
