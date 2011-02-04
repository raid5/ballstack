//
//  BallStackMenuView.m
//  BallStack
//
//  Created by Adam McDonald on 12/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BallStackMenuView.h"
#import "BallStackViewController.h"

@interface BallStackMenuView ()
- (void)home;
@end

@implementation BallStackMenuView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		
		// Home button
		UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[homeButton setFrame:CGRectMake(134.0, 200.0, 52.0, 52.0)];
		[homeButton setBackgroundImage:[UIImage imageNamed:@"homebutton.png"] forState:UIControlStateNormal];
		[homeButton addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:homeButton];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}

- (void)home {
	[[[BallStackViewController sharedSingleton] navigationController] popToRootViewControllerAnimated:YES];
	[self removeFromSuperview];
}

//- - - Touch Events - - -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"[touch] MenuView");
	UITouch* touch = [touches anyObject];
	UITouchPhase phase = [touch phase];
	
	if ( phase == UITouchPhaseBegan ) {
		[self removeFromSuperview];
	} else {
		[self.nextResponder touchesBegan:touches withEvent:event];
	}
}

@end
