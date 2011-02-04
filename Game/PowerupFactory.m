//
//  PowerupFactory.m
//  BallStack
//
//  Created by Adam McDonald on 12/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PowerupFactory.h"
#import "Powerup.h"

#define POWERUP_PROBABILITY 10 // 10% chance

@implementation PowerupFactory

- (id)init {
	if (self = [super init]) {
		// Setup
    }
    return self;
}

+ (PowerupFactory *)sharedSingleton {
	static PowerupFactory *sharedSingleton;
	
	if ( !sharedSingleton ) sharedSingleton = [[PowerupFactory alloc] init];
	
	return sharedSingleton;
}

- (Powerup *)createPowerup {
	// Determine powerup properties
	
	int prob = arc4random() % 100;
	if ( prob > POWERUP_PROBABILITY ) return nil;
	
	int rand = arc4random() % 100;
	int powerupType = -1;
	if ( rand <= 16 ) {
		powerupType = PowerupDudBalls;
	} else if ( rand <= 32 ) {
		powerupType = PowerupUndudBalls;
	} else if ( rand <= 48 ) {
		powerupType = PowerupAddBalls;
	} else if ( rand <= 64 ) {
		powerupType = PowerupRemoveBalls;
	} else if ( rand <= 80 ) {
		powerupType = PowerupStackDown;
	} else if ( rand <= 100 ) {
		powerupType = PowerupStackUp; // greatest probability
	}
	
	// Create ball
	Powerup *p = [[Powerup alloc] initWithType:powerupType];
	
	// Finally, return newly created powerup
	//return p;
	return [p autorelease];
}

- (Powerup *)createPowerupOfType:(int)pType {
	return [[[Powerup alloc] initWithType:pType] autorelease];
}

- (void)dealloc {
    [super dealloc];
}

@end
