//
//  GNZSegmentedController.m
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import "GNZSlidingSegmentView.h"

@interface GNZSlidingSegmentView ()
@property (weak, nonatomic) UIScrollView *scrollView;
@property (nonatomic) id<GNZSegment> feedSelectorControl;
@end
@implementation GNZSlidingSegmentView

#pragma mark - Setup

- (void)connectSegmentedControl {
    if (_feedSelectorControl != [self.dataSource segmentedControlForSlidingSegmentView:self]) {
        _feedSelectorControl = [self.dataSource segmentedControlForSlidingSegmentView:self];
        [(id)_feedSelectorControl addTarget:self action:@selector(segmentSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
        self.scrollView.delegate = self.feedSelectorControl;
    }
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

- (void)reload {
    [self connectSegmentedControl];
    [self layoutSegmentViewControllers];
}

#pragma mark - Overrides 

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *strongScrollView = [[UIScrollView alloc] init];
        _scrollView = strongScrollView;
        _scrollView.backgroundColor = [UIColor colorWithRed:224 green:224 blue:224 alpha:1.0];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_scrollView);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:views]];
        
    }
    return _scrollView;
}

- (void)setDataSource:(id<GNZSlidingSegmentViewDatasource>)dataSource {
    _dataSource = dataSource;
    if (_dataSource) {
        [self reload];
    }
}

#pragma mark - Datasource Convenience
- (NSUInteger)segmentViewControllerCount {
    return [self.feedSelectorControl numberOfSegments];
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index {
    return [self.dataSource slidingSegmentView:self viewControllerForSegmentAtIndex:index];
}

#pragma mark - Actions
-(void)segmentSelectionDidChange:(id)sender
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * [(id)self.feedSelectorControl selectedSegmentIndex];
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

@end
