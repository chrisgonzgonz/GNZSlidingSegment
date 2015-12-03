//
//  GNZSegmentedController.h
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import <Foundation/Foundation.h>
#import "GNZSegment.h"

@class GNZSlidingSegmentView;

@protocol GNZSlidingSegmentViewDatasource <NSObject>
- (id<GNZSegment>)segmentedControlForSlidingSegmentView:(GNZSlidingSegmentView *)slidingSegmentView;
- (UIViewController *)slidingSegmentView:(GNZSlidingSegmentView *)slidingSegmentView viewControllerForSegmentAtIndex:(NSUInteger)index;
@end

@interface GNZSlidingSegmentView : UIView
@property (weak, nonatomic) id <GNZSlidingSegmentViewDatasource> dataSource;
@end

