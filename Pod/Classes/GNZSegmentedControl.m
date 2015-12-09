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
NSString * const GNZSegmentOptionIndicatorColor = @"SEGMENT_INDICATOR_COLOR";

@interface GNZSegmentedControl ()
@property (nonatomic) NSUInteger selectedSegmentIndex;
@property (nonatomic) NSMutableArray *segments;
@property (nonatomic) UIColor *controlBackgroundColor;
@property (nonatomic) UIColor *segmentDefaultColor;
@property (nonatomic) UIColor *segmentSelectedColor;
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic) UIColor *hairlineShadowColor;
@property (nonatomic) GNZIndicatorStyle indicatorStyle;

//default
@property (weak, nonatomic) UIView *defaultSelectionIndicator;
@property (nonatomic) NSLayoutConstraint *defaultIndicatorConstraint;

//elevator
@property (nonatomic) NSMutableArray<NSLayoutConstraint *> *elevatorHeightConstraints;

@end
@implementation GNZSegmentedControl

#pragma mark - Initializers
- (instancetype)initWithSegmentCount:(NSUInteger)count indicatorStyle:(GNZIndicatorStyle)style options:(NSDictionary<NSString *,UIColor *> *)segmentOptions {
    if (self = [super initWithFrame:CGRectZero]) {
        _indicatorStyle = style;
        _elevatorHeightConstraints = [NSMutableArray new];
        _controlBackgroundColor = segmentOptions[GNZSegmentOptionControlBackgroundColor];
        _segmentDefaultColor = segmentOptions[GNZSegmentOptionDefaultSegmentTintColor];
        _segmentSelectedColor = segmentOptions[GNZSegmentOptionSelectedSegmentTintColor];
        _indicatorColor = segmentOptions[GNZSegmentOptionIndicatorColor];
        
        [self setupSegmentsWithCount:count];
    }
    return self;
}

#pragma mark - Layout and Defaults
- (void)setupSegmentsWithCount:(NSUInteger)segmentCount {
    self.backgroundColor = self.controlBackgroundColor;
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
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[finalButton]|" options:0 metrics:nil views:views]];
    
    _selectedSegmentIndex = 0;
    [self activateSelectedSegment];
    
    [self setIndicatorConstraintsForStyle:self.indicatorStyle];
    [self addHairlineShadow];
}

-(void)addHairlineShadow
{
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f/UIScreen.mainScreen.scale)];
    [self.layer setShadowRadius:0];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.25f];
    
}

- (void)setIndicatorConstraintsForStyle:(GNZIndicatorStyle)style {
    switch (style) {
        case GNZIndicatorStyleElevator:
            [self createElevatorIndicatorConstraints];
            break;
        default:
            [self createDefaultIndicatorConstraints];
            break;
    }
}

- (void)createDefaultIndicatorConstraints {
    NSLayoutConstraint *segmentRightConstraint = [NSLayoutConstraint constraintWithItem:self.defaultSelectionIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.segments.firstObject attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:segmentRightConstraint];
    self.defaultIndicatorConstraint = segmentRightConstraint;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultSelectionIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.segments.firstObject attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultSelectionIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:5.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultSelectionIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self layoutIfNeeded];
}

- (void)createElevatorIndicatorConstraints {
    for (UIView *segmentView in self.segments) {
        UIView *segmentIndicator = [self selectionIndicator];
        [segmentView addSubview:segmentIndicator];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:segmentIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
        [segmentView addConstraint:heightConstraint];
        [self.elevatorHeightConstraints addObject:heightConstraint];

        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:segmentIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:segmentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [segmentView addConstraint:bottomConstraint];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:segmentIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:segmentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        [segmentView addConstraint:widthConstraint];
        
        NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:segmentIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:segmentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        [segmentView addConstraint:xConstraint];
        
//        [segmentView layoutIfNeeded];
    }
    
    self.elevatorHeightConstraints.firstObject.constant = 5;
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

#pragma mark - GNZSegment Protocol
- (NSUInteger)numberOfSegments {
    return self.segments.count;
}

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    if (![self validSegmentIndex:selectedSegmentIndex]) return;
    
    [self deactivateSelectedSegment];
    _selectedSegmentIndex = selectedSegmentIndex;
    [self activateSelectedSegment];
}


#pragma mark - Overrides

- (void)setFont:(UIFont *)font {
    if (font) {
        for (UIButton *button in self.segments) {
            [button.titleLabel setFont:font];
        }
        _font = font;
    }
}

- (UIView *)defaultSelectionIndicator {
    if (!_defaultSelectionIndicator) {
        UIView *strongIndicator = [UIView new];
        _defaultSelectionIndicator = strongIndicator;
        _defaultSelectionIndicator.backgroundColor = self.indicatorColor;
        _defaultSelectionIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_defaultSelectionIndicator];
    }
    return _defaultSelectionIndicator;
}

- (UIView *)selectionIndicator {
    UIView *newIndicator = [UIView new];
    newIndicator.backgroundColor = self.indicatorColor;
    newIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    return newIndicator;
}

#pragma mark - Actions
- (void)segmentTouchedUpInside:(UIButton *)sender {
    NSUInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    NSUInteger currentSelectedIndex = [self.segments indexOfObject:sender];
    
    _selectedSegmentIndex = currentSelectedIndex;
    
    if (currentSelectedIndex != previousSelectedSegmentIndex)
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

- (void)adjustIndicatorForScroll:(UIScrollView *)scrollView {
    switch (self.indicatorStyle) {
        case GNZIndicatorStyleElevator:
            [self adjustElevatorIndicatorsWithScroll:scrollView];
            break;
        case GNZIndicatorStyleDefault:
            [self adjustDefaultIndicatorWithScroll:scrollView];
            break;
    }
}

- (void)adjustDefaultIndicatorWithScroll:(UIScrollView *)scrollView {
    self.defaultIndicatorConstraint.constant = (scrollView.contentOffset.x/scrollView.contentSize.width)*self.frame.size.width;
}

- (void)adjustElevatorIndicatorsWithScroll:(UIScrollView *)scrollView {
    for (int i = 0; i < self.elevatorHeightConstraints.count; i++) {
        CGFloat segmentPosition = i*(self.frame.size.width);
        CGFloat distanceFromViewport = fabs(segmentPosition-scrollView.contentOffset.x);
        CGFloat percentHeight = 1-(distanceFromViewport/self.frame.size.width);
        percentHeight = percentHeight*2-1;
        NSLayoutConstraint *constraint = self.elevatorHeightConstraints[i];
        CGFloat constant =  percentHeight*5;
        constraint.constant = MAX(0, constant);
    }
}

@end
