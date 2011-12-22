//
//  BBCustomBackButtonViewController.h
//  BBCustomBackButtonViewController
//
//  Created by Benjamin Borowski on 12/20/11.
//  Copyright (c) 2011 Typeoneerror Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

// adds custom back button and simulates native animation
@interface BBCustomBackButtonViewController : UIViewController
{
    // true if self has a navigation controller pushed on top of it
    BOOL _wasPushed;
}

@property (nonatomic, retain) UIButton *backButton;

// add our custom back button to the navigation bar
- (void)addCustomBackButton;

// user tapped the custom back button
- (void)didTouchBackButton:(id)sender;

@end
