//
//  SecondViewController.m
//  T1ECustomBackButton
//
//  Created by Benjamin Borowski on 12/20/11.
//  Copyright (c) 2011 Typeoneerror Studios. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@implementation SecondViewController

@synthesize nextButton = _nextButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)dealloc
{
    [_nextButton release];

    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setNextButton:nil];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didTouchNextButton:(id)sender
{
    ThirdViewController *thirdViewController = [[ThirdViewController new] autorelease];
    [[self navigationController] pushViewController:thirdViewController animated:YES];
}

@end
