//
//  GNZSegmentedController.h
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import <Foundation/Foundation.h>
#import "GNZSegmentedControl.h"

@class GNZSegmentPageViewController;

@protocol GNZSegmentPageViewControllerDatasource <NSObject>
- (GNZSegmentedControl *)segmentedControlForSegmentPageController:(GNZSegmentPageViewController *)segmentPageController;
- (UIViewController *)segmentPageController:(GNZSegmentPageViewController *)segmentPageController controllerForSegmentAtIndex:(NSUInteger)index;
- (NSUInteger)segmentPageController:(GNZSegmentPageViewController *)segmentPageController segmentIndexForController:(UIViewController *)controller;
@end

@interface GNZSegmentPageViewController : UIViewController
@property (weak, nonatomic) id <GNZSegmentPageViewControllerDatasource> dataSource;
@end

