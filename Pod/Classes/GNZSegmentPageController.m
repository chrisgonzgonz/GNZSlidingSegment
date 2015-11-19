//
//  GNZSegmentedController.m
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import "GNZSegmentPageController.h"

@interface GNZSegmentPageController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, readwrite) UIPageViewController *pageViewController;
@property (nonatomic) NSArray *controllerPages;
@property (nonatomic, readonly) GNZSegmentedControl *feedSelectorControl;
@property (nonatomic) NSUInteger currentIndex;
@end
@implementation GNZSegmentPageController

- (instancetype)init {
    NSAssert(NO, @"use initWithSegmentedControl:andPageViewController:");
    return nil;
}

- (instancetype)initWithSegmentedControl:(GNZSegmentedControl *)segmentedControl andChildViewControllers:(NSArray *)children {
    if (self = [super init]) {
        _controllerPages = children;
        _feedSelectorControl = segmentedControl;
        [_feedSelectorControl addTarget:self action:@selector(feedSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup {
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    pageViewController.view.backgroundColor = [UIColor colorWithRed:224 green:224 blue:224 alpha:1.0];
    [pageViewController setViewControllers:@[self.controllerPages.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController = pageViewController;
    _view = self.pageViewController.view;
}

#pragma mark - Actions
-(void)feedSelectionDidChange:(id)sender
{
    NSUInteger newIndex = self.feedSelectorControl.selectedSegmentIndex;
    if (newIndex == self.currentIndex) return;

    [self.pageViewController setViewControllers:@[self.controllerPages[newIndex]] direction:self.currentIndex < newIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    self.currentIndex = newIndex;
}


#pragma mark - UIPageViewController Datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger idx = [self.controllerPages indexOfObject:viewController];
    UIViewController *afterVC;
    if (idx < self.controllerPages.count-1) {
        afterVC = self.controllerPages[idx+1];
    }
    return afterVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger idx = [self.controllerPages indexOfObject:viewController];
    UIViewController *beforeVC;
    if (idx > 0) {
        beforeVC = self.controllerPages[idx-1];
    }
    return beforeVC;
}

#pragma mark - UIPageViewController Delegate 
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
//    NSUInteger idx = [self.controllerPages indexOfObject:pendingViewControllers.lastObject];
//    [self.feedSelectorControl setSelectedSegmentIndex:idx];
    NSLog(@"--- will transition");
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (finished) {
        NSLog(@"--- did finish");
    } else {
        NSLog(@"--- not finish");
    }
    
    if (completed) {
        NSLog(@"--- complete");
        NSUInteger idx = [self.controllerPages indexOfObject:pageViewController.viewControllers.lastObject];
        [self.feedSelectorControl setSelectedSegmentIndex:idx];
        self.currentIndex = idx;
    } else {
        NSLog(@"--- incomplete");
        [self.feedSelectorControl setSelectedSegmentIndex:[self.controllerPages indexOfObject: previousViewControllers.lastObject]];
    }
}

@end
