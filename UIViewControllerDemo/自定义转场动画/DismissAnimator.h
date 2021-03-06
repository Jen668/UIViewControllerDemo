//
//  DismissAnimator.h
//  UIViewControllerDemo
//
//  Created by 讯心科技 on 2018/3/12.
//  Copyright © 2018年 讯心科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIImage *transitionImage;

@property (nonatomic, assign) CGRect endFrame;

@end
