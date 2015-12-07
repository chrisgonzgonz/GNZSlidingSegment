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
@protocol gnzSlidingSegmentViewDelegate <NSObject>
@optional
- (void)slidingSegmentView:(GNZSlidingSegmentView *)slidingSegmentView segmentDidChange:(NSUInteger)newSegmentIndex;
@end

@interface GNZSlidingSegmentView : UIView
@property (weak, nonatomic) id <GNZSlidingSegmentViewDatasource> dataSource;
@property (weak, nonatomic) id <gnzSlidingSegmentViewDelegate> delegate;
@end

