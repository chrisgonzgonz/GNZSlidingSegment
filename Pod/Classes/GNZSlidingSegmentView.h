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
@protocol GNZSlidingSegmentViewDelegate <NSObject>
@optional
- (void)slidingSegmentView:(GNZSlidingSegmentView *)slidingSegmentView segmentDidChange:(NSUInteger)newSegmentIndex;
- (void)slidingSegmentView:(GNZSlidingSegmentView *)slidingSegmentView didChangeFromPreviousIndex:(NSUInteger)previous toIndex:(NSUInteger)next;
@end

@interface GNZSlidingSegmentView : UIView
@property (weak, nonatomic) id <GNZSlidingSegmentViewDatasource> dataSource;
@property (weak, nonatomic) id <GNZSlidingSegmentViewDelegate> delegate;
@property (nonatomic) BOOL scrollsToTop;
@end

