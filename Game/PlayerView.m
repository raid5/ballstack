//
//  PlayerView.m
//  BallStack
//
//  Created by Adam McDonald on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PlayerView.h"
#import "Player.h"
#import "BallStackViewController.h"

// A class extension to declare private methods
@interface PlayerView ()
- (void)handleTap:(UITouch *)touch;
@end

@implementation PlayerView

@synthesize playerId, displayId, statusView;

- (id)initWithFrame:(CGRect)frame withPlayerId:(int)pId withDisplayId:(int)dId {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.playerId = pId;
		self.displayId = dId;
		
		self.userInteractionEnabled = YES;
		
		// Do not display for yourself
		if ( playerId != SELF_PLAYERID ) {
			// Setup "health" status view
			statusView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 0.0)];
			[statusView setBackgroundColor:[UIColor blackColor]];
			[self addSubview:statusView];
			
			// Display playerid
			UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 20.0, 20.0)];
			[pLabel setNumberOfLines:1];
			[pLabel setBackgroundColor:[UIColor clearColor]];
			[pLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
			[pLabel setTextColor:[UIColor whiteColor]];
			[pLabel setTextAlignment:UITextAlignmentCenter];
			[pLabel setText:[NSString stringWithFormat:@"%d", displayId]];
			[self addSubview:pLabel];
			[pLabel release];
		}
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
	[statusView release];
    [super dealloc];
}

- (void)updateStatusView:(int)status {
	int statusViewHeight = (int)(30 - (status * 3 / 10.0));
	CGRect statusViewFrame = CGRectMake(0.0, 0.0, 30.0, statusViewHeight);
	[statusView setFrame:statusViewFrame];
}

//- - - Touch Events - - -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"[touch] PlayerView");
	if ( [[BallStackViewController sharedSingleton] active] ) {
		UITouch* touch = [touches anyObject];
		UITouchPhase phase = [touch phase];
		
		if ( phase == UITouchPhaseBegan ) {
			[self handleTap:touch];
		} else {
			[self.nextResponder touchesBegan:touches withEvent:event];
		}
	}
}

- (void)handleTap:(UITouch *)touch {
	[[BallStackViewController sharedSingleton] sendPowerupTo:playerId];
}

@end
