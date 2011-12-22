If you've done any iOS development, you know that even though many things are very easy to customize, sometimes, things that seem very easy are not. For example, you cannot change the text color on the Back button very easily. If you want to make your own Back Button, it's relatively easy. Just instantiate a `UIBarButton` item and set it to the `leftBarButtonItem` property of the `navigationBar`. Unfortunately, doing this renders the button as a static, non-animating plain old button, so you lose that nice animation in-between view controllers.

This project shows a quick method for creating a completely custom back button that does all the in/out animated goodness for you. Just set the base class of your UIViewControllers to a class that extends [BBCustomBackButtonViewController](https://github.com/typeoneerror/BBCustomBackButtonViewController/blob/master/BBCustomBackButtonViewController/BBCustomBackButtonViewController.m). When views appear or disappear, it'll automatically animate your back buttons in and out similar to Apple's standard UI and you can fully customize the look of the text and button since it's just a UIButton behind.

### How it works:

When the view loads, a custom back button is added if the navigation controller is not the first on the navigation stack:

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        NSArray *viewControllers = [[self navigationController] viewControllers];
        // only add back if not first controller
        if ([viewControllers objectAtIndex:0] != self)
        {
            // assign the title of the last controller to the back button title
            NSString *backTitle = [[viewControllers objectAtIndex:[viewControllers count] - 2] title];
            if (backTitle != NULL)
            {
                [self addCustomBackButtonWithTitle:backTitle];
            }
            else
            {
                // no title so use the default
                [self addCustomBackButton];
            }
        }
    }

The addCustomBackButton method creates a UIBarButton item and assigns it a customView which is a button. The button is assigned to the backButton property, so you can access all the properties of the button there (change the text color, shadows, fonts, etc). For example, in the sample project, I change the back button's text color to green in viewDidLoad:

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        [self.backButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }


When a view is about to disappear, we check to see if it's disappearing because it's being popped from the stack
or if it's disappearing because another view controller is being added to the stack. The back button
automatically animates in the correct direction, emulating the Apple animation that UINavigationController provides.

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
            frame.size.width = self.backButton.frame.size.width;

            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kBackButtonAnimationSpeed];
            self.backButton.frame = frame;
            [UIView commitAnimations];
        }
    }


When a view is about to appear, we use a instance var to see if it was pushed off previously, and
use that to determine the direction the back button needs to animate.

    - (void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];

        NSArray *viewControllers = self.navigationController.viewControllers;
        // only animate if being animated (avoids animation when changing tabs for instance)
        // make sure it's being re-revealed after dismissing a modal view
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