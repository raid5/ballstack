//
//  Powerup.h
//  BallStack
//
//  Created by Adam McDonald on 12/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	PowerupStackUp,
	PowerupStackDown,
	PowerupAddBalls,
	PowerupRemoveBalls,
	PowerupDudBalls,
	PowerupUndudBalls,
	//PowerupStackClear,
	//PowerupScrambleBalls,
	//PowerupScreenSwap,
} PowerupType;

@interface Powerup : NSObject {

@private
	int pType;
	UIView *pView;
	
}

@property (nonatomic, assign) int pType;
@property (nonatomic, retain) UIView *pView;

- (id)initWithType:(int)powerupType;

@end
