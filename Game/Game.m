//
//  Game.m
//  BallStack
//
//  Created by Adam McDonald on 11/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "Player.h"
#import "PlayerView.h"

#define MAX_PLAYERS 8

@implementation Game

@synthesize gameId, title, maxPlayers, joinedPlayers, secondsUntilStart, players;

- (id)initWithGameId:(int)gId titled:(NSString *)gTitle withMaxPlayers:(int)gMaxNum withJoinedPlayers:(int)gJoinedNum gStartingIn:(int)gSeconds {
	if (self = [super init]) {
		self.gameId = gId;
		self.title = gTitle;
		self.maxPlayers = gMaxNum;
		self.joinedPlayers = gJoinedNum;
		self.secondsUntilStart = gSeconds;
		self.players = [[NSMutableArray alloc] initWithCapacity:MAX_PLAYERS];
    }
    return self;
}

- (void)dealloc {
	[players release];
    [super dealloc];
}

- (void)decrementSeconds {
	secondsUntilStart = (secondsUntilStart - 1);
}

- (void)addPlayer:(Player *)aPlayer {
	//NSLog(@"addPlayer(%d)", [aPlayer playerId]);
	[players addObject:aPlayer];
}

- (void)removePlayer:(int)playerId {
	// Determine if player exists in player list
	int removeIndex = -1;
	for ( int i = 0; i < [players count]; i++ ) {
		Player *p = (Player *)[players objectAtIndex:i];
		if ( [p playerId] == playerId ) {
			removeIndex = i;
			break;
		}
	}
	
	// Remove player if necessary
	if ( removeIndex >= 0 ) [players removeObjectAtIndex:removeIndex];
}

- (void)setStatus:(int)playerStatus forPlayer:(int)playerId {
	for ( int i = 0; i < [players count]; i++ ) {
		Player *p = (Player *)[players objectAtIndex:i];
		if ( [p playerId] == playerId ) {
			// Update players status value
			[p setStatus:playerStatus];
			
			// Update players status view
			[(PlayerView *)[p playerView] updateStatusView:playerStatus];
			
			// Update PlayerView if dead
			if ( playerStatus == -1 ) {
				// Remove statusView (doesn't make sense here)
				[[(PlayerView *)[p playerView] statusView] removeFromSuperview];
				
				// Set playerView to red to indicate death
				//[[p playerView] setBackgroundColor:[UIColor redColor]];
				[[p playerView] setImage:[UIImage imageNamed:@"playerview-gray.png"]];
			}
			
			break;
		}
	}
}

- (BOOL)isFull {
	return ( joinedPlayers == maxPlayers ) ? YES : NO;
}

@end
