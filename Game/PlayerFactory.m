//
//  PlayerFactory.m
//  BallStack
//
//  Created by Adam McDonald on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PlayerFactory.h"
#import "Player.h"

#define INITIAL_PLAYER_STATUS 100

@implementation PlayerFactory

@synthesize displayId;

- (id)init {
	if (self = [super init]) {
		// Setup
		self.displayId = 0;
    }
    return self;
}

+ (PlayerFactory *)sharedSingleton {
	static PlayerFactory *sharedSingleton;
	
	if ( !sharedSingleton ) sharedSingleton = [[PlayerFactory alloc] init];
	
	return sharedSingleton;
}

- (Player *)createPlayerWithPlayerId:(int)pId {
	return [[[Player alloc] initWithPlayerId:pId andDisplayId:displayId++ andStatus:INITIAL_PLAYER_STATUS] autorelease];
}

- (void)resetDisplayId {
	displayId = 0;
}

- (void)dealloc {
    [super dealloc];
}

@end
