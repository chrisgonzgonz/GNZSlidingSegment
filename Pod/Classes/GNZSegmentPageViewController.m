//
//  GNZSegmentedController.m
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import "GNZSegmentPageViewController.h"

@interface GNZSegmentPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) id feedSelectorControl;
@property (nonatomic) NSUInteger currentIndex;
@end
@implementation GNZSegmentPageViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.dataSource, @"datasource should exist");
    [self setupFeedSelectorControl];
    [self setupPageViewController];
}

#pragma mark - Setup
- (void)setupPageViewController {
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    pageViewController.view.backgroundColor = [UIColor colorWithRed:224 green:224 blue:224 alpha:1.0];
    [pageViewController setViewControllers:@[[self pageForSegment:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController = pageViewController;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
    
    NSDictionary *views = @{@"pageView": _pageViewController.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView]|" options:0 metrics:nil views:views]];
}

//- (void)setScrollviewDelegate {
//    for (UIView *view in self.pageViewController.view.subviews){
//        if ([view isKindOfClass:[UIScrollView class]]){
//            [(UIScrollView *)view setDelegate:self.feedSelectorControl];
//        }
//    }
//}

- (void)setupFeedSelectorControl {
    _feedSelectorControl = [self.dataSource segmentedControlForSegmentPageController:self];
    [_feedSelectorControl addTarget:self action:@selector(feedSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Convenience

- (UIViewController *)pageForSegment:(NSUInteger)index {
    return [self.dataSource segmentPageController:self controllerForSegmentAtIndex:index];
}

#pragma mark - Actions
-(void)feedSelectionDidChange:(id)sender
{
    NSUInteger newIndex = [self.feedSelectorControl selectedSegmentIndex];
    if (newIndex == self.currentIndex) return;
    
    UIViewController *nextVC = [self pageForSegment:newIndex];

    if (nextVC) {
        [self.pageViewController setViewControllers:@[nextVC] direction:self.currentIndex < newIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        self.currentIndex = newIndex;
    } else {
        [self.feedSelectorControl setSelectedSegmentIndex:self.currentIndex];
    }
}

#pragma mark - UIPageViewController Datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *afterVC = [self pageForSegment:self.currentIndex+1];
    if (afterVC) self.currentIndex++;
    return afterVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *beforeVC = [self pageForSegment:self.currentIndex-1];
    if (beforeVC) self.currentIndex--;
    return beforeVC;
}

#pragma mark - UIPageViewController Delegate 
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
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
        self.currentIndex = [self.dataSource segmentPageController:self segmentIndexForController:pageViewController.viewControllers.lastObject];
        [self.feedSelectorControl setSelectedSegmentIndex:self.currentIndex];
    } else {
        NSLog(@"--- incomplete");
    }

}

@end
