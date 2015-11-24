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
- (UIViewController *)viewControllerForSegmentPageController:(GNZSegmentPageViewController *)segmentPageController atIndex:(NSUInteger)index;
- (NSUInteger)numberOfPagesForSegmentPageView:(GNZSegmentPageViewController *)segmentPageController;
@end

@interface GNZSegmentPageViewController : UIViewController
@property (weak, nonatomic) id <GNZSegmentPageViewControllerDatasource> dataSource;
@end

