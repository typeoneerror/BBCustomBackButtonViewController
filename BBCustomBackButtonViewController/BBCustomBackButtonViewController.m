//
//  BBCustomBackButtonViewController.m
//  BBCustomBackButtonViewController
//
//  Created by Benjamin Borowski on 12/20/11.
//  Copyright (c) 2011 Typeoneerror Studios. All rights reserved.
//

#import "BBCustomBackButtonViewController.h"


#define kBackButtonAnimationOffset  80.0f
#define kBackButtonAnimationSpeed   0.2f
#define kBackButtonFrame            CGRectMake(6.0f, 6.0f, 52.0f, 31.0f)


@implementation BBCustomBackButtonViewController

@synthesize backButton = _backButton;

- (void)dealloc
{
    [_backButton release];
}

- (void)viewDidLoad
{
    if ([[[self navigationController] viewControllers] objectAtIndex:0] != self)
    {
        [self addCustomBackButton];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSArray *viewControllers = self.navigationController.viewControllers;
    if (animated && viewControllers.count > 1 && !self.navigationController.modalViewController)
    {
        CGFloat offset = kBackButtonAnimationOffset;
        if (_wasPushed) offset *= -1;
        CGRect frame = kBackButtonFrame;
        frame.origin.x = offset;
        self.backButton.frame = frame;

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kBackButtonAnimationSpeed];
        frame.origin.x = kBackButtonFrame.origin.x;
        self.backButton.frame = frame;
        [UIView commitAnimations];
    }

    _wasPushed = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSArray *viewControllers = self.navigationController.viewControllers;

    // If view is disappearing but still in stack, we can assume a modal is hiding it.
    if (animated && [viewControllers objectAtIndex:viewControllers.count - 1] != self)
    {
        CGFloat offset;
        if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count - 2] == self)
        {
            // View is disappearing because a new view controller was pushed onto the stack
            offset = -kBackButtonAnimationOffset;
            _wasPushed = YES;
        }
        else if ([viewControllers indexOfObject:self] == NSNotFound)
        {
            // View is disappearing because it was popped from the stack
            offset = kBackButtonAnimationOffset;
            _wasPushed = NO;
        }

        CGRect frame = kBackButtonFrame;
        frame.origin.x = offset;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kBackButtonAnimationSpeed];
        self.backButton.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)addCustomBackButton
{
    // create back button
    UIImage *buttonImage = [UIImage imageNamed:@"back-button.png"];
    UIButton *button = [[[UIButton alloc] initWithFrame:
                         CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)] autorelease];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setAdjustsImageWhenHighlighted:YES];
    [button setAdjustsImageWhenDisabled:YES];
    [button addTarget:self action:@selector(didTouchBackButton:) forControlEvents:UIControlEventTouchUpInside];

    // add back button to left bar button slot
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    [[self navigationItem] setLeftBarButtonItem:backButton];

    // save the back button so we can animate it later
    self.backButton = button;

    // hide the normal back button
    [[self navigationItem] setHidesBackButton:YES];
}

- (void)didTouchBackButton:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
