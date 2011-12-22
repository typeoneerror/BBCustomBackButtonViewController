//
//  FirstViewController.h
//  BBCustomBackButtonViewController
//
//  Created by Benjamin Borowski on 12/20/11.
//  Copyright (c) 2011 Typeoneerror Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCustomBackButtonViewController.h"

@interface FirstViewController : BBCustomBackButtonViewController

@property (retain, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)didTouchNextButton:(id)sender;

@end
