//
//  GNZViewController.m
//  GNZSlidingSegment
//
//  Created by Chris Gonzales on 11/17/2015.
//  Copyright (c) 2015 Chris Gonzales. All rights reserved.
//

#import "GNZViewController.h"
#import <GNZSlidingSegment/GNZSegmentedControl.h>
#import <GNZSlidingSegment/GNZSlidingSegmentView.h>
#import "GNZSegmentViewController.h"
#import <GNZSlidingSegment/UISegmentedControl+GNZCompatibility.h>

@interface GNZViewController () <GNZSlidingSegmentViewDatasource>
@property (weak, nonatomic) GNZSegmentedControl *segmentedControl;
@property (nonatomic) GNZSlidingSegmentView *slidingSegmentView;
@property (nonatomic) UISegmentedControl *lameSegmentedControl;
@property (nonatomic) NSArray *segmentViewControllers;
@end

@implementation GNZViewController

#pragma mark - Datasource
- (id<GNZSegment>)segmentedControlForSlidingSegmentViewController:(GNZSlidingSegmentView *)segmentPageController {
    return self.segmentedControl;
}

- (UIViewController *)slidingSegmentViewController:(GNZSlidingSegmentView *)segmentPageController viewControllerForSegmentAtIndex:(NSUInteger)index {
    UIViewController *vc;
    if (index < self.segmentViewControllers.count) {
        vc = self.segmentViewControllers[index];
    }
    return vc;
}

- (NSUInteger)numberOfSegmentsForSlidingSegmentViewController:(GNZSlidingSegmentView *)segmentPageController {
    return self.segmentViewControllers.count;
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slidingSegmentView = [GNZSlidingSegmentView new];
    
    [self.slidingSegmentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.slidingSegmentView];
    
    
    NSDictionary *views = @{@"topLayoutGuide": self.topLayoutGuide, @"segmentedControl": self.segmentedControl, @"slidingSegmentView": self.slidingSegmentView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segmentedControl]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[slidingSegmentView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][segmentedControl(50)][slidingSegmentView]|" options:0 metrics:nil views:views]];
    
    self.slidingSegmentView.dataSource = self;
}

- (NSArray *)segmentViewControllers {
    if (!_segmentViewControllers) {
        GNZSegmentViewController *page1 = [[GNZSegmentViewController alloc] initWithNibName:NSStringFromClass([GNZSegmentViewController class]) bundle:nil];
        page1.view.backgroundColor = [UIColor grayColor];
        page1.pageNumber = 1;
        
        GNZSegmentViewController *page2 =[[GNZSegmentViewController alloc] initWithNibName:NSStringFromClass([GNZSegmentViewController class]) bundle:nil];
        page2.view.backgroundColor = [UIColor purpleColor];
        page2.pageNumber = 2;
        
        GNZSegmentViewController *page3 =[[GNZSegmentViewController alloc] initWithNibName:NSStringFromClass([GNZSegmentViewController class]) bundle:nil];
        page3.view.backgroundColor = [UIColor redColor];
        page3.pageNumber = 3;
        _segmentViewControllers = @[page1, page2, page3];
    }
    return _segmentViewControllers;
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
