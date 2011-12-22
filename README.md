If you've done any iOS development, you know that even though many things are very easy to customize, sometimes, things that seem very easy are not. For example, you cannot change the text color on the Back button very easily. If you want to make your own Back Button, it's relatively easy. Just instantiate a `UIBarButton` item and set it to the `leftBarButtonItem` property of the `navigationBar`. Unfortunately, doing this renders the button as a static, non-animating plain old button, so you lose that nice animation in between view controllers.

This project shows a quick method for creating a completely custom back button that does all the in/out animated goodness for you. Just set the base class of your UIViewControllers to a class like `BBCustomBackButtonViewController`. When views appear or disappear, it'll automatically animate your back buttons in and out similar to Apple's standard UI.

### How it works:

When the view loads, a custom back button is added if the navigation controller is not the first on the navigation stack:

    - (void)viewDidLoad
    {
        // only add back if not first controller
        if ([[[self navigationController] viewControllers] objectAtIndex:0] != self)
        {
            [self addCustomBackButton];
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

When a view is about to disappear, we check to see if it's disappearing because it's being popped from the stack
or if it's disappearing because another view controller is being added to the stack. The back button
automatically animates the correct direction.

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