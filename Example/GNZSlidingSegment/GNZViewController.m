//
//  GNZViewController.m
//  GNZSlidingSegment
//
//  Created by Chris Gonzales on 11/17/2015.
//  Copyright (c) 2015 Chris Gonzales. All rights reserved.
//

#import "GNZViewController.h"
#import <GNZSlidingSegment/GNZSegmentedControl.h>
#import <GNZSlidingSegment/GNZSegmentPageViewController.h>
#import "GNZPageViewController.h"
#import <GNZSlidingSegment/UISegmentedControl+GNZCompatibility.h>

@interface GNZViewController () <GNZSegmentPageViewControllerDatasource>
@property (weak, nonatomic) GNZSegmentedControl *segmentedControl;
@property (nonatomic) GNZSegmentPageViewController *segmentPageViewController;
@property (nonatomic) UISegmentedControl *lameSegmentedControl;
@property (nonatomic) NSArray *pageControllers;
@end

@implementation GNZViewController

#pragma mark - Datasource
- (id<GNZSegment>)segmentedControlForSegmentPageController:(GNZSegmentPageViewController *)segmentPageController {
    return self.segmentedControl;
}

- (UIViewController *)viewControllerForSegmentPageController:(GNZSegmentPageViewController *)segmentPageController atIndex:(NSUInteger)index {
    UIViewController *vc;
    if (index < self.pageControllers.count) {
        vc = self.pageControllers[index];
    }
    return vc;
}

- (NSUInteger)numberOfPagesForSegmentPageView:(GNZSegmentPageViewController *)segmentPageController {
    return self.pageControllers.count;
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentPageViewController = [GNZSegmentPageViewController new];
    self.segmentPageViewController.dataSource = self;
    
    [self.segmentPageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.segmentPageViewController.view];
    
    
    NSDictionary *views = @{@"topLayoutGuide": self.topLayoutGuide, @"segmentedControl": self.segmentedControl, @"pageView": self.segmentPageViewController.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segmentedControl]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][segmentedControl(50)][pageView]|" options:0 metrics:nil views:views]];
    
}

- (NSArray *)pageControllers {
    if (!_pageControllers) {
        GNZPageViewController *page1 = [[GNZPageViewController alloc] initWithNibName:NSStringFromClass([GNZPageViewController class]) bundle:nil];
        page1.view.backgroundColor = [UIColor greenColor];
        page1.pageNumber = 1;
        
        GNZPageViewController *page2 =[[GNZPageViewController alloc] initWithNibName:NSStringFromClass([GNZPageViewController class]) bundle:nil];
        page2.view.backgroundColor = [UIColor purpleColor];
        page2.pageNumber = 2;
        
        GNZPageViewController *page3 =[[GNZPageViewController alloc] initWithNibName:NSStringFromClass([GNZPageViewController class]) bundle:nil];
        page3.view.backgroundColor = [UIColor redColor];
        page3.pageNumber = 3;
        _pageControllers = @[page1, page2, page3];
    }
    return _pageControllers;
}

- (GNZSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        GNZSegmentedControl *segmentControl = [[GNZSegmentedControl alloc] initWithSegmentCount:3 indicatorStyle:GNZIndicatorStyleElevator options:@{GNZSegmentOptionControlBackgroundColor: [UIColor colorWithRed:244/255.0 green:245/255.0 blue:245/255.0 alpha:1.0], GNZSegmentOptionDefaultSegmentTintColor: [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0], GNZSegmentOptionSelectedSegmentTintColor: [UIColor colorWithRed: 44/255.0 green: 54/255.0 blue: 67/255.0 alpha:1.0]}];
        segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
        [segmentControl setTitle:@"Segment 1" forSegmentAtIndex:0];
        [segmentControl setTitle:@"Segment 2" forSegmentAtIndex:1];
        [segmentControl setTitle:@"Segment 3" forSegmentAtIndex:2];
        [self.view addSubview:segmentControl];
        _segmentedControl = segmentControl;
    }
    return _segmentedControl;
}

- (UISegmentedControl *)lameSegmentedControl {
    if (!_lameSegmentedControl) {
        _lameSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3", @"4"]];
        [self.view addSubview:_lameSegmentedControl];
        _lameSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _lameSegmentedControl;
}

@end
