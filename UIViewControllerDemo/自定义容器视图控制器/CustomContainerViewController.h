//
//  CustomContainerViewController.h
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/1/18.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomContainerViewController : UIViewController

- (instancetype)initWithTitleArray:(NSArray<NSString *> *)titleArray viewControllers:(NSArray <UIViewController *>*)viewControllers;

@end
