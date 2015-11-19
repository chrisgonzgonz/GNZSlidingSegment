//
//  GNZViewController.m
//  GNZSlidingSegment
//
//  Created by Chris Gonzales on 11/17/2015.
//  Copyright (c) 2015 Chris Gonzales. All rights reserved.
//

#import "GNZViewController.h"
#import <GNZSlidingSegment/GNZSegmentedControl.h>
#import <GNZSlidingSegment/GNZSegmentPageController.h>
#import "GNZPageViewController.h"

@interface GNZViewController ()
@property (weak, nonatomic) GNZSegmentedControl *segmentedControl;
@property (nonatomic) GNZSegmentPageController *segmentPageController;
@property (nonatomic) NSArray *pageControllers;
@end

@implementation GNZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentPageController = [[GNZSegmentPageController alloc] initWithSegmentedControl:self.segmentedControl andChildViewControllers:self.pageControllers];
    
    [self.segmentPageController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.segmentPageController.view];
    
    
    NSDictionary *views = @{@"topLayoutGuide": self.topLayoutGuide, @"segmentedControl": self.segmentedControl, @"pageView": self.segmentPageController.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segmentedControl]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][segmentedControl(40)][pageView]|" options:0 metrics:nil views:views]];
    
}

- (NSArray *)pageControllers {
    if (!_pageControllers) {
        GNZPageViewController *page1 = [[GNZPageViewController alloc] initWithNibName:NSStringFromClass([GNZPageViewController class]) bundle:nil];
        page1.view.backgroundColor = [UIColor greenColor];
        page1.pageNumber = 1;
        
        GNZPageViewController *page2 =[[GNZPageViewController alloc] initWithNibName:NSStringFromClass([GNZPageViewController class]) bundle:nil];
        page2.view.backgroundColor = [UIColor purpleColor];
        page2.pageNumber = 2;
        _pageControllers = @[page1, page2];
    }
    return _pageControllers;
}

- (GNZSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        GNZSegmentedControl *segmentControl = [[GNZSegmentedControl alloc] initWithSegmentCount:2 options:@{GNZSegmentOptionControlBackgroundColor: [UIColor colorWithRed:244/255.0 green:245/255.0 blue:245/255.0 alpha:1.0], GNZSegmentOptionDefaultSegmentTintColor: [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1.0], GNZSegmentOptionSelectedSegmentTintColor: [UIColor colorWithRed: 44/255.0 green: 54/255.0 blue: 67/255.0 alpha:1.0]}];
        segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
        [segmentControl setTitle:@"Segment 1" forSegmentAtIndex:0];
        [segmentControl setTitle:@"Segment 2" forSegmentAtIndex:1];
        [self.view addSubview:segmentControl];
        _segmentedControl = segmentControl;
    }
    return _segmentedControl;
}

@end
