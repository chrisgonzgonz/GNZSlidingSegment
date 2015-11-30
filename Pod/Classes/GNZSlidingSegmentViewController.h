//
//  GNZSegmentedController.h
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import <Foundation/Foundation.h>
#import "GNZSegment.h"

@class GNZSlidingSegmentViewController;

@protocol GNZSlidingSegmentViewControllerDatasource <NSObject>
- (id<GNZSegment>)segmentedControlForSlidingSegmentViewController:(GNZSlidingSegmentViewController *)segmentPageController;
- (UIViewController *)slidingSegmentViewController:(GNZSlidingSegmentViewController *)slidingSegmentViewController viewControllerForSegmentAtIndex:(NSUInteger)index;
@end

@interface GNZSlidingSegmentViewController : UIViewController
@property (weak, nonatomic) id <GNZSlidingSegmentViewControllerDatasource> dataSource;
@end

