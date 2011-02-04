//
//  IntroView.m
//  BallStack
//
//  Created by Adam McDonald on 11/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IntroView.h"
#import "DevViewController.h"

#define DEV_MODE YES

@implementation IntroView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main-bg.png"]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}

//- - - Touch Events - - -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
	int taps = [touch tapCount];

	if ( taps == 2 ) {
		if ( DEV_MODE ) {
			DevViewController *dev = [[DevViewController alloc] initWithNibName:@"Dev" bundle:nil];
			id appDelegate = [[UIApplication sharedApplication] delegate];
			[[appDelegate navigationController] pushViewController:dev animated:YES];
		}
	} else {
		[self.nextResponder touchesBegan:touches withEvent:event];
	}
}

@end
