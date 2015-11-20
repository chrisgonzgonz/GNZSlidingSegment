//
//  GNZSegmentControl.h
//  Pods
//
//  Created by Chris Gonzales on 11/17/15.
//
//

#import <UIKit/UIKit.h>
#import "GNZSegment.h"

extern NSString * const GNZSegmentOptionControlBackgroundColor;
extern NSString * const GNZSegmentOptionSelectedSegmentTintColor;
extern NSString * const GNZSegmentOptionDefaultSegmentTintColor;

@interface GNZSegmentedControl : UIControl <GNZSegment, UIScrollViewDelegate>
@property (nonatomic) NSUInteger selectedSegmentIndex;
- (instancetype)initWithSegmentCount:(NSUInteger)count options:(NSDictionary *)segmentOptions;
- (void)setTitle:(NSString*)title forSegmentAtIndex:(NSUInteger)segment;
- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (void)setTitle:(NSString *)title andImage:(UIImage *)image withSpacing:(CGFloat)spacing forSegmentAtIndex:(NSUInteger)segment;
@end
