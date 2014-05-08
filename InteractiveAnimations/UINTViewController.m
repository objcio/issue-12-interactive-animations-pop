//
//  UINTViewController.m
//  InteractiveAnimations
//
//  Created by Chris Eidhof on 02.05.14.
//  Copyright (c) 2014 Unsigned Integer. All rights reserved.
//

#import "UINTViewController.h"
#import "DraggableView.h"
#import "POPSpringAnimation.h"


typedef NS_ENUM(NSInteger, PaneState) {
    PaneStateOpen,
    PaneStateClosed,
};

@interface UINTViewController () <DraggableViewDelegate>

@property (nonatomic) PaneState paneState;
@property (nonatomic, strong) DraggableView *pane;
@property (nonatomic, strong) POPSpringAnimation *animation;
@end

@implementation UINTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    CGSize size = self.view.bounds.size;
    self.paneState = PaneStateClosed;
    DraggableView *view = [[DraggableView alloc] initWithFrame:CGRectMake(0, size.height * .75, size.width, size.height)];
    view.backgroundColor = [UIColor grayColor];
    view.delegate = self;
    [self.view addSubview:view];
    self.pane = view;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (CGPoint)targetPoint
{
    CGSize size = self.view.bounds.size;
    return self.paneState == PaneStateClosed > 0 ? CGPointMake(size.width/2, size.height * 1.25) : CGPointMake(size.width/2, size.height/2 + 50);
}

- (void)animatePaneWithInitialVelocity:(CGPoint)initialVelocity
{
    [self.pane pop_removeAllAnimations];
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.velocity = [NSValue valueWithCGPoint:initialVelocity];
    animation.toValue = [NSValue valueWithCGPoint:self.targetPoint];
    animation.springSpeed = 15;
    animation.springBounciness = 6;
    [self.pane pop_addAnimation:animation forKey:@"animation"];
    self.animation = animation;
}


#pragma mark DraggableViewDelegate

- (void)draggableView:(DraggableView *)view draggingEndedWithVelocity:(CGPoint)velocity
{
    self.paneState = velocity.y >= 0 ? PaneStateClosed : PaneStateOpen;
    [self animatePaneWithInitialVelocity:velocity];
}

- (void)draggableViewBeganDragging:(DraggableView *)view
{
    [view.layer pop_removeAllAnimations];
}


#pragma mark Actions

- (void)didTap:(UITapGestureRecognizer *)tapRecognizer
{
    self.paneState = self.paneState == PaneStateOpen ? PaneStateClosed : PaneStateOpen;
    [self animatePaneWithInitialVelocity:[self.animation.velocity CGPointValue]];
}

@end
