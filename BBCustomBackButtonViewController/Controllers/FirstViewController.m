//
//  FirstViewController.m
//  BBCustomBackButtonViewController
//
//  Created by Benjamin Borowski on 12/20/11.
//  Copyright (c) 2011 Typeoneerror Studios. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation FirstViewController

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

    self.title = @"First Controller";
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
    SecondViewController *secondViewController = [[SecondViewController new] autorelease];
    [[self navigationController] pushViewController:secondViewController animated:YES];
}

@end
