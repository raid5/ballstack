//
//  OpponentsView.m
//  BallStack
//
//  Created by Adam McDonald on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OpponentsView.h"
#import "BallStackViewController.h"
#import "Game.h"
#import "Player.h"
#import "PlayerView.h"

#define OPP_WIDTH 30.0
#define OPP_HEIGHT 30.0
#define OPP_PADDING 5.0

@implementation OpponentsView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self reload];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Draw
}

- (void)dealloc {
    [super dealloc];
}

- (void)reload {
	// Clear opponents
	for ( UIView *view in [self subviews] ) {
		[view removeFromSuperview];
	}
	
	// Load all players
	Game *g = [[BallStackViewController sharedSingleton] game];
	int pCount = [[g players] count];
	for ( int i = 0; i < pCount; i++ ) {
		Player *p = (Player *)[[g players] objectAtIndex:i];
		
		int xOffset = (i * (OPP_WIDTH + OPP_PADDING)) + OPP_PADDING;
		PlayerView *pView = [[PlayerView alloc] initWithFrame:CGRectMake(xOffset, OPP_PADDING, OPP_WIDTH, OPP_HEIGHT) withPlayerId:[p playerId] withDisplayId:[p displayId]];
		if ( [p status] == -1 ) {
			// dead
			//[pView setBackgroundColor:[UIColor redColor]];
			[pView setImage:[UIImage imageNamed:@"playerview-gray.png"]];
		} else if ( [p playerId] == SELF_PLAYERID ) {
			// self
			//[pView setBackgroundColor:[UIColor blueColor]];
			[pView setImage:[UIImage imageNamed:@"playerview-blue.png"]];
		} else {
			// opponent
			//[pView setBackgroundColor:[UIColor purpleColor]];
			[pView setImage:[UIImage imageNamed:@"playerview-green.png"]];
		}
		[self addSubview:pView];
		
		// Assign view for player
		[p setPlayerView:pView];
	}
}

@end
