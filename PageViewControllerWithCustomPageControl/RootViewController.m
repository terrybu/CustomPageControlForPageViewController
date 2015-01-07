//
//  RootViewController.m
//  PageViewControllerWithCustomPageControl
//
//  Created by Aditya Narayan on 12/18/14.
//  Copyright (c) 2014 TerryBuOrganization. All rights reserved.
//

#import "RootViewController.h"

//%%% customizeable button attributes
#define Y_BUFFER 14 //%%% number of pixels on top of the segment
#define HEIGHT 30 //%%% height of the segment
#define ANIMATION_SPEED 0.2 //%%% the number of seconds it takes to complete the animation
#define SELECTOR_HEIGHT 4 //%%% thickness of the selector bar
#define X_OFFSET 12
#define Y_OFFSET_BELOW_NAVBAR 21.7

typedef void (^moveSelectorBarLeftBlockType)(void);
typedef void (^moveSelectorBarRightBlockType)(void);

@interface RootViewController () {
    
    NSArray *viewControllers;
    UIView *selectionBar;
    int SELECTOR_WIDTH;
    int SELECTOR_Y;
    UIButton *leftButton;
    UIButton *rightButton;
    
    moveSelectorBarLeftBlockType moveSelectorBarLeft;
    moveSelectorBarRightBlockType moveSelectorBarRight;
    
    UIViewController *firstVC;
    UIViewController *secondVC;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    moveSelectorBarLeft = ^{
        [UIView animateWithDuration: ANIMATION_SPEED
                              delay: 0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             leftButton.backgroundColor = [UIColor orangeColor];
                             rightButton.backgroundColor = nil;
                             selectionBar.frame = CGRectMake(0, HEIGHT, SELECTOR_WIDTH, SELECTOR_HEIGHT);
                         }
                         completion:^(BOOL finished){
                         }];
    };
    
    moveSelectorBarRight =  ^{
        [UIView animateWithDuration: ANIMATION_SPEED
                              delay: 0
                            options: UIViewAnimationOptionTransitionNone
                         animations:^{
                             rightButton.backgroundColor = [UIColor orangeColor];
                             leftButton.backgroundColor = nil;
                             selectionBar.frame = CGRectMake(SELECTOR_WIDTH, HEIGHT, SELECTOR_WIDTH + X_OFFSET, SELECTOR_HEIGHT);
                         }
                         completion:^(BOOL finished){
                         }];
    };

    
    
    SELECTOR_WIDTH = self.view.frame.size.width/2;
    SELECTOR_Y = self.navigationController.navigationBar.frame.size.height + Y_OFFSET_BELOW_NAVBAR + HEIGHT;
        
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.backgroundColor = [UIColor clearColor];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"firstViewController"];
    secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"];
    
    viewControllers = @[firstVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self setUpCustomPageControlIndicatorButtons];
}

- (void) setUpCustomPageControlIndicatorButtons {
    
    self.pageControlCustomView = [[UIView alloc] initWithFrame:(CGRectMake(0, self.navigationController.navigationBar.frame.size.height + Y_OFFSET_BELOW_NAVBAR, self.view.frame.size.width, HEIGHT + SELECTOR_HEIGHT))];
    
    leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.pageControlCustomView.frame.size.width/2, HEIGHT)];
    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.pageControlCustomView.frame.size.width/2, 0, self.view.frame.size.width/2+X_OFFSET, HEIGHT)];
    
    selectionBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + HEIGHT, SELECTOR_WIDTH, SELECTOR_HEIGHT)];
    selectionBar.backgroundColor = [UIColor lightGrayColor];
    selectionBar.alpha = 0.8;
    
    leftButton.backgroundColor = [UIColor whiteColor];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.layer.borderWidth = 0.8;
    leftButton.layer.borderColor = [UIColor blackColor].CGColor;
    [leftButton addTarget:self action:@selector(tappedLeft:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"First Baby" forState:UIControlStateNormal];
    
    rightButton.backgroundColor = [UIColor whiteColor];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.layer.borderWidth = 0.8;
    rightButton.layer.borderColor = [UIColor blackColor].CGColor;
    [rightButton addTarget:self action:@selector(tappedRight:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"Second Baby" forState:UIControlStateNormal];
    
    [self.pageControlCustomView addSubview:leftButton];
    [self.pageControlCustomView addSubview:rightButton];
    [self.pageControlCustomView addSubview:selectionBar];
    [self.pageViewController.view addSubview: self.pageControlCustomView];
}

- (IBAction) tappedLeft:(id)sender {
    [self.pageViewController setViewControllers:@[firstVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    leftButton.backgroundColor = [UIColor orangeColor];
    rightButton.backgroundColor = nil;
    moveSelectorBarLeft();
    
}
- (IBAction) tappedRight:(id)sender {
    [self.pageViewController setViewControllers:@[secondVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    leftButton.backgroundColor = nil;
    rightButton.backgroundColor = [UIColor orangeColor];
    moveSelectorBarRight();
}






#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.pageViewController.viewControllers[0] == secondVC)
        return firstVC;
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.pageViewController.viewControllers[0] == firstVC)
        return secondVC;
    return nil;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        if (previousViewControllers[0] == secondVC) {
            moveSelectorBarLeft();
        }
        else {
            moveSelectorBarRight();
        }
    }
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
