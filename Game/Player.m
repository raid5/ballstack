//
//  Player.m
//  BallStack
//
//  Created by Adam McDonald on 11/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize playerId, displayId, status, playerView;

- (id)initWithPlayerId:(int)pId andDisplayId:(int)dId andStatus:(int)pStatus{
	if (self = [super init]) {
		self.playerId = pId;
		self.displayId = dId;
		self.status = pStatus;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
