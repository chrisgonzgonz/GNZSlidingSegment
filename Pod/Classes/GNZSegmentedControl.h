//
//  GNZSegmentControl.h
//  Pods
//
//  Created by Chris Gonzales on 11/17/15.
//
//

#import <UIKit/UIKit.h>
#import "GNZSegment.h"


NS_ASSUME_NONNULL_BEGIN
extern NSString * const GNZSegmentOptionControlBackgroundColor;
extern NSString * const GNZSegmentOptionSelectedSegmentTintColor;
extern NSString * const GNZSegmentOptionDefaultSegmentTintColor;
extern NSString * const GNZSegmentOptionIndicatorColor;

typedef NS_ENUM(NSUInteger, GNZIndicatorStyle) {
    GNZIndicatorStyleDefault,
    GNZIndicatorStyleElevator
};

@interface GNZSegmentedControl : UIControl <GNZSegment>
@property (nonatomic) UIFont *font;
+ (instancetype)new __attribute__((unavailable("use initWithSegmentCount:options:")));
- (instancetype)init __attribute__((unavailable("use initWithSegmentCount:options:")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("use initWithSegmentCount:options:")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("use initWithSegmentCount:options:")));
- (instancetype)initWithSegmentCount:(NSUInteger)count indicatorStyle:(GNZIndicatorStyle)style options:(NSDictionary<NSString *, UIColor *> *)segmentOptions;

- (void)setTitle:(NSString*)title forSegmentAtIndex:(NSUInteger)segment;
- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (void)setTitle:(nullable NSString *)title andImage:(nullable UIImage *)image withSpacing:(CGFloat)spacing forSegmentAtIndex:(NSUInteger)segment;
- (void)adjustIndicatorForScroll:(UIScrollView *)scrollView;
@end
NS_ASSUME_NONNULL_END
