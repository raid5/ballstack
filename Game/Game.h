//
//  Game.h
//  BallStack
//
//  Created by Adam McDonald on 11/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEST_GAMEID -1

@class Player;

@interface Game : NSObject {

@private
	int gameId;
	NSString *title;
	int maxPlayers;
	int joinedPlayers;
	int secondsUntilStart;
	NSMutableArray *players;
	
}

@property (nonatomic, assign) int gameId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) int maxPlayers;
@property (nonatomic, assign) int joinedPlayers;
@property (nonatomic, assign) int secondsUntilStart;
@property (nonatomic, retain) NSMutableArray *players;

- (id)initWithGameId:(int)gId titled:(NSString *)gTitle withMaxPlayers:(int)gMaxNum withJoinedPlayers:(int)gJoinedNum gStartingIn:(int)gSeconds;
- (void)decrementSeconds;
- (void)addPlayer:(Player *)aPlayer;
- (void)removePlayer:(int)playerId;
- (void)setStatus:(int)playerStatus forPlayer:(int)playerId;
- (BOOL)isFull;

@end
