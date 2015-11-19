//
//  GNZSegmentedController.h
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import <Foundation/Foundation.h>
#import "GNZSegment.h"

@class GNZSegmentPageViewController;

@protocol GNZSegmentPageViewControllerDatasource <NSObject>
- (id<GNZSegment>)segmentedControlForSegmentPageController:(GNZSegmentPageViewController *)segmentPageController;
- (UIViewController *)segmentPageController:(GNZSegmentPageViewController *)segmentPageController controllerForSegmentAtIndex:(NSUInteger)index;
- (NSUInteger)segmentPageController:(GNZSegmentPageViewController *)segmentPageController segmentIndexForController:(UIViewController *)controller;
@end

@interface GNZSegmentPageViewController : UIViewController
@property (weak, nonatomic) id <GNZSegmentPageViewControllerDatasource> dataSource;
@end

