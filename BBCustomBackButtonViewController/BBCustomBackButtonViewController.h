//
//  BBCustomBackButtonViewController.h
//  BBCustomBackButtonViewController
//
//  Created by Benjamin Borowski on 12/20/11.
//  Copyright (c) 2011 Typeoneerror Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBCustomBackButtonViewController : UIViewController
{
    BOOL _wasPushed;
}

@property (nonatomic, retain) UIButton *backButton;

- (void)addCustomBackButton;
- (void)didTouchBackButton:(id)sender;

@end
