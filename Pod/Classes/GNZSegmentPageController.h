//
//  GNZSegmentedController.h
//  Pods
//
//  Created by Chris Gonzales on 11/18/15.
//
//

#import <Foundation/Foundation.h>
#import "GNZSegmentedControl.h"

@interface GNZSegmentPageController : NSObject
@property (nonatomic) UIView *view;
- (instancetype)initWithSegmentedControl:(GNZSegmentedControl *)segmentedControl andChildViewControllers:(NSArray *)children;
@end
