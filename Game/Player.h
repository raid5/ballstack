//
//  Player.h
//  BallStack
//
//  Created by Adam McDonald on 11/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SELF_PLAYERID -1

@interface Player : NSObject {

@private
	int playerId;
	int displayId;
	int status;
	UIImageView *playerView;
	
}

@property (nonatomic, assign) int playerId;
@property (nonatomic, assign) int displayId;
@property (nonatomic, assign) int status;
@property (nonatomic, retain) UIImageView *playerView;

- (id)initWithPlayerId:(int)pId andDisplayId:(int)dId andStatus:(int)pStatus;

@end
