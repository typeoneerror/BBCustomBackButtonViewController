//
//  BBCustomBackButtonViewController.m
//  BBCustomBackButtonViewController
//
//  Created by Benjamin Borowski on 12/20/11.
//  Copyright (c) 2011 Typeoneerror Studios. All rights reserved.
//

#import "BBCustomBackButtonViewController.h"


#define kBackButtonAnimationOffset  80.0f
#define kBackButtonAnimationSpeed   0.3f
#define kBackButtonFrame            CGRectMake(6.0f, 6.0f, 52.0f, 31.0f)
#define kBackButtonMarginRight      7.0f
#define kBackButtonPadding          10.0f


@implementation BBCustomBackButtonViewController

@synthesize backButton = _backButton;
@synthesize backButtonTitle = _backButtonTitle;

- (void)dealloc
{
    [_backButton release];
    [_backButtonTitle release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *viewControllers = [[self navigationController] viewControllers];
    // only add back if not first controller
    if ([viewControllers objectAtIndex:0] != self)
    {
        // assign the title of the last controller to the back button title
        NSString *backTitle = [[viewControllers objectAtIndex:[viewControllers count] - 2] title];
        if (backTitle != NULL || _backButtonTitle != NULL)
        {
            backTitle = _backButtonTitle ? _backButtonTitle : backTitle;
            [self addCustomBackButtonWithTitle:backTitle];
        }
        else
        {
            // no title so use the default
            [self addCustomBackButton];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSArray *viewControllers = self.navigationController.viewControllers;
    // only animate if being animated (avoids animating when changing tabs, for example)
    // make sure it's not being re-revealed after dismissing a modal view.
    if (animated && viewControllers.count > 1 && !self.navigationController.modalViewController)
    {
        CGFloat offset = kBackButtonAnimationOffset;
        // if it was previously hidden by another controller, reverse animation direction
        if (_wasPushed) offset *= -1;
        CGRect frame = kBackButtonFrame;
        frame.size.width = self.backButton.frame.size.width;
        frame.origin.x = offset;
        self.backButton.frame = frame;

        // animate the back button
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

        // This segment care of Sbrocket.
        // @see http://stackoverflow.com/a/1816682/53653
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
        frame.size.width = self.backButton.frame.size.width;

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kBackButtonAnimationSpeed];
        self.backButton.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)addCustomBackButton
{
    NSString *title = self.title ? self.title : NSLocalizedString(@"Back", nil);
    if (_backButtonTitle != nil) title = _backButtonTitle;
    [self addCustomBackButtonWithTitle:title];
}

// Much of this method pulled from Wolfgang Schreur's sweet UIBarButton category.
// @see http://stackoverflow.com/a/7068222/53653
- (void)addCustomBackButtonWithTitle:(NSString *)title
{
    UIImage *image = [UIImage imageNamed:@"back-button"];
    image = [image stretchableImageWithLeftCapWidth:14.0f topCapHeight:0.0f];
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];

    CGSize textSize = [title sizeWithFont:font];
    CGSize buttonSize = CGSizeMake(textSize.width + kBackButtonPadding * 2, image.size.height);

    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height)] autorelease];
    [button addTarget:self action:@selector(didTouchBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];

    [button.titleLabel setFont:font];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];

    // defaults are bright to show demo
    // override in viewDidLoad by accessing self.backButton
    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithRed:67.0f/255.0f green:3.0f/255.0f blue:38.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

    CGFloat margin = floorf((button.frame.size.height - textSize.height) / 2);
    CGFloat marginRight = kBackButtonMarginRight;
    CGFloat marginLeft = button.frame.size.width - textSize.width - marginRight;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(margin, marginLeft, margin, marginRight)];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    [self.navigationItem.leftBarButtonItem setWidth:buttonSize.width];
    self.backButton = button;
}

- (void)didTouchBackButton:(id)sender
{
    // manually pop current view
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
