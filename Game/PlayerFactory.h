//
//  PlayerFactory.h
//  BallStack
//
//  Created by Adam McDonald on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface PlayerFactory : NSObject {

@private
	int displayId;
	
}

@property (nonatomic, assign) int displayId;

+ (PlayerFactory *)sharedSingleton;
- (Player *)createPlayerWithPlayerId:(int)pId;
- (void)resetDisplayId;

@end
