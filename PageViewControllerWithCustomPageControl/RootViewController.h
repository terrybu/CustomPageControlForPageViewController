//
//  RootViewController.h
//  PageViewControllerWithCustomPageControl
//
//  Created by Aditya Narayan on 12/18/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController  <UIPageViewControllerDataSource, UIPageViewControllerDelegate>


@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIView *pageControlCustomView;

@end
