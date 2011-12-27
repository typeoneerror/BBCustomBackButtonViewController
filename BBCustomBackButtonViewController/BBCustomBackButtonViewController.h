//
//  BBCustomBackButtonViewController.h
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

@property (retain, nonatomic) UIButton *backButton;
@property (copy, nonatomic) NSString *backButtonTitle;

// add our custom back button to the navigation bar
// defaults to "Back"
- (void)addCustomBackButton;

// add custom back button with custom title
- (void)addCustomBackButtonWithTitle:(NSString *)title;

// user tapped the custom back button
- (void)didTouchBackButton:(id)sender;

@end
