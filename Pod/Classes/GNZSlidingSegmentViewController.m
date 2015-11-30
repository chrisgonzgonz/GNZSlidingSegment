//
//  GNZSegmentedController.m
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import "GNZSlidingSegmentViewController.h"

@interface GNZSlidingSegmentViewController ()
@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) id<GNZSegment> feedSelectorControl;
@property (nonatomic) NSUInteger currentIndex;
@end
@implementation GNZSlidingSegmentViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.dataSource, @"datasource should exist");
    [self setupFeedSelectorControl];
    [self setupPageViewController];
}

#pragma mark - Setup
- (void)setupPageViewController {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor colorWithRed:224 green:224 blue:224 alpha:1.0];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self.feedSelectorControl;
    [self.view addSubview:self.scrollView];
    
    
    
    NSDictionary *views = @{@"scrollView": self.scrollView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    [self layoutSegmentViewControllers];
}

- (void)setupFeedSelectorControl {
    _feedSelectorControl = [self.dataSource segmentedControlForSlidingSegmentViewController:self];
    [(id)_feedSelectorControl addTarget:self action:@selector(feedSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)layoutSegmentViewControllers {
    NSMutableDictionary *views;
    for (int count = 0; count < [self segmentViewControllerCount]; count++) {
        UIViewController *previousVC = count ? [self viewControllerForIndex:count-1] : nil;
        UIViewController *currentVC = [self viewControllerForIndex:count];
        [currentVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:currentVC.view];
        
        views = [[NSMutableDictionary alloc] initWithDictionary:@{@"scrollView": self.scrollView}];
        views[@"currentVC"] = currentVC.view;
        if (previousVC) views[@"previousVC"] = previousVC.view;
        
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[currentVC(==scrollView)]" options:0 metrics:nil views:views]];
        if (count == 0) {
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[currentVC]" options:0 metrics:nil views:views]];
        } else {
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousVC][currentVC]" options:0 metrics:nil views:views]];
        }
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[currentVC(==scrollView)]|" options:0 metrics:nil views:views]];
    }
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[currentVC]|" options:0 metrics:nil views:views]];
}

#pragma mark - Datasource Convenience
- (NSUInteger)segmentViewControllerCount {
    return [self.dataSource numberOfSegmentsForSlidingSegmentViewController:self];
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index {
    return [self.dataSource slidingSegmentViewController:self viewControllerForSegmentAtIndex:index];
}

#pragma mark - Actions
-(void)feedSelectionDidChange:(id)sender
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * [(id)self.feedSelectorControl selectedSegmentIndex];
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

@end
