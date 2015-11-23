//
//  GNZSegmentControl.m
//  Pods
//
//  Created by Chris Gonzales on 11/17/15.
//
//

#import "GNZSegmentedControl.h"

NSString * const GNZSegmentOptionControlBackgroundColor = @"SEGMENT_OPTION_BACKGROUND_COLOR";
NSString * const GNZSegmentOptionSelectedSegmentTintColor = @"SEGMENT_OPTION_SELECTED_COLOR";
NSString * const GNZSegmentOptionDefaultSegmentTintColor = @"SEGMENT_OPTION_DEFAULT_COLOR";

@interface GNZSegmentedControl ()
@property (nonatomic) NSMutableArray *segments;
@property (nonatomic) UIColor *controlBackgroundColor;
@property (nonatomic) UIColor *segmentDefaultColor;
@property (nonatomic) UIColor *segmentSelectedColor;
@property (weak, nonatomic) UIView *selectionIndicator;
@property (nonatomic) NSLayoutConstraint *indicatorConstraint;
@property (nonatomic) NSMutableArray *segmentIndicatorConstraints;
@end
@implementation GNZSegmentedControl

#pragma mark - UIScrollView Delegate 
- (void)updateSegmentIndicatorPosition:(BOOL)rightDirection {
    CGFloat constantDelta = self.frame.size.width/(float)self.segments.count;
    CGFloat bounceDiff = self.frame.size.width * 0.2;
    if (!rightDirection) {
        constantDelta *= -1.0;
        bounceDiff *= -1.0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorConstraint.constant += constantDelta + bounceDiff;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.indicatorConstraint.constant -= bounceDiff;
            [self layoutIfNeeded];
        }];
    }];
}

#pragma mark - Initializers
- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"use initWithSegmentCount");
    return nil;
}

- (instancetype)initWithSegmentCount:(NSUInteger)count options:(NSDictionary *)segmentOptions{
    if (self = [super initWithFrame:CGRectZero]) {
        _controlBackgroundColor = segmentOptions[GNZSegmentOptionControlBackgroundColor];
        _segmentDefaultColor = segmentOptions[GNZSegmentOptionDefaultSegmentTintColor];
        _segmentSelectedColor = segmentOptions[GNZSegmentOptionSelectedSegmentTintColor];
        _segmentIndicatorConstraints = [NSMutableArray new];
        [self setupSegmentsWithCount:count];
    }
    return self;
}

#pragma mark - Layout and Defaults
- (void)setupSegmentsWithCount:(NSUInteger)segmentCount {
    self.backgroundColor = self.controlBackgroundColor;
    CGFloat buttonWidth = self.frame.size.width/(float)segmentCount;
    self.segments = [NSMutableArray new];
    for (NSUInteger count = 0; count < segmentCount; count++) {
        UIButton *previousButton = self.segments.lastObject;
        UIButton *currentButton = [self configuredSegmentButton];
        
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:currentButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0/(float)segmentCount constant:0.0]];
        NSDictionary *views;
        if (count == 0) {
            views = NSDictionaryOfVariableBindings(currentButton);
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[currentButton]" options:0 metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[currentButton]|" options:0 metrics:nil views:views]];
        } else  {
            views = NSDictionaryOfVariableBindings(previousButton,currentButton);
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton][currentButton]" options:0 metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[currentButton]|" options:0 metrics:nil views:views]];
        }
    }
    UIButton *finalButton = self.segments.lastObject;
    NSDictionary *views = NSDictionaryOfVariableBindings(finalButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[finalButton]|" options:0 metrics:@{@"buttonWidth": @(buttonWidth)} views:views]];
    _selectedSegmentIndex = 0;
    [self activateSelectedSegment];
    
    NSLayoutConstraint *segmentCenterConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.segments.firstObject attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:segmentCenterConstraint];
    self.indicatorConstraint = segmentCenterConstraint;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.segments.firstObject attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:5.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self layoutIfNeeded];
}

- (UIButton *)selectedSegmentButton {
    return self.segments[self.selectedSegmentIndex];
}

- (UIButton *)configuredSegmentButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button addTarget:self action:@selector(segmentTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:self.segmentDefaultColor forState:UIControlStateNormal];
    [button setTintColor:self.segmentDefaultColor];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    [self.segments addObject:button];
    return button;
}

#pragma mark - Overrides
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    if (![self validSegmentIndex:selectedSegmentIndex]) return;
    
    BOOL rightDirection = selectedSegmentIndex > _selectedSegmentIndex;
    [self deactivateSelectedSegment];
    _selectedSegmentIndex = selectedSegmentIndex;
    [self activateSelectedSegment];
    [self updateSegmentIndicatorPosition:rightDirection];
    
}

- (UIView *)selectionIndicator {
    if (!_selectionIndicator) {
        UIView *strongIndicator = [UIView new];
        _selectionIndicator = strongIndicator;
        _selectionIndicator.backgroundColor = [UIColor orangeColor];
        _selectionIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_selectionIndicator];
    }
    return _selectionIndicator;
}

#pragma mark - Actions
- (void)segmentTouchedUpInside:(UIButton *)sender {
    NSUInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    NSUInteger currentSelectedIndex = [self.segments indexOfObject:sender];
    
    self.selectedSegmentIndex = currentSelectedIndex;
    
    if (self.selectedSegmentIndex != previousSelectedSegmentIndex)
    {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}


#pragma mark - Set Segment Properties
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    [self setTitle:title andImage:nil withSpacing:0.0 forSegmentAtIndex:segment];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
    [self setTitle:nil andImage:image withSpacing:0.0 forSegmentAtIndex:segment];
}

- (void)setTitle:(NSString *)title andImage:(UIImage *)image withSpacing:(CGFloat)spacing forSegmentAtIndex:(NSUInteger)segment {
    if (![self validSegmentIndex:segment]) return;
    
    UIButton *editingSegment = [self.segments objectAtIndex:segment];
    [editingSegment setImage:image forState:UIControlStateNormal];
    [editingSegment setTitle:title forState:UIControlStateNormal];
    editingSegment.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
    editingSegment.titleEdgeInsets = UIEdgeInsetsMake(1, spacing, 0, 0);
}

#pragma mark - Helpers

- (BOOL)validSegmentIndex:(NSUInteger)segmentIndex {
    return segmentIndex <= self.segments.count;
}

- (void)deactivateSelectedSegment {
    UIButton *previousSelected = self.segments[_selectedSegmentIndex];
    [previousSelected setTitleColor:self.segmentDefaultColor forState:UIControlStateNormal];
    [previousSelected setTintColor:self.segmentDefaultColor];
}

- (void)activateSelectedSegment {
    UIButton *currentSelected = self.segments[_selectedSegmentIndex];
    [currentSelected setTitleColor:self.segmentSelectedColor forState:UIControlStateNormal];
    [currentSelected setTintColor:self.segmentSelectedColor];
}


@end
