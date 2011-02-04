//
//  BallFactory.m
//  BallStack
//
//  Created by Jason on 11/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BallFactory.h"
#import "Ball.h"
#import "Powerup.h"
#import "PowerupFactory.h"
#import <stdlib.h>

@implementation BallFactory

@synthesize count;

- (id)init {
	if (self = [super init]) {
		// Setup
		self.count = 0;
    }
    return self;
}

+ (BallFactory *)sharedSingleton {
	static BallFactory *sharedSingleton;
	
	if ( !sharedSingleton ) sharedSingleton = [[BallFactory alloc] init];
	
	return sharedSingleton;
}

- (Ball *)createBall {
	// Determine ball properties
	
	// (Possible) Powerup
	Powerup *pwr = [[PowerupFactory sharedSingleton] createPowerup];
	
	// Image (based on possible powerup)
	UIImage *img;

	Color color;
	int rand = arc4random() % 100;
	
	if ( pwr == nil ) {
		// Select from images WITHOUT powerups
		if ( rand <= 20 ) {
			color = Blue;
			img = [UIImage imageNamed:@"ball-blue.png"];
		} else if ( rand <= 40 ) {
			color= Green;
			img = [UIImage imageNamed:@"ball-green.png"];
		} else if ( rand <= 60 ) {
			color = Orange;
			img = [UIImage imageNamed:@"ball-orange.png"];
		} else if ( rand <= 80 ) {
			color = Red;
			img = [UIImage imageNamed:@"ball-red.png"];
		} else if ( rand <= 100 ) {
			color = Purple;
			img = [UIImage imageNamed:@"ball-purple.png"];
		}
	} else {
		// Select from images WITH powerups
		if ( rand <= 20 ) {
			color = Blue;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-blue-%d.png", [pwr pType]]];
		} else if ( rand <= 40 ) {
			color = Green;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-green-%d.png", [pwr pType]]];
		} else if ( rand <= 60 ) {
			color = Orange;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-orange-%d.png", [pwr pType]]];
		} else if ( rand <= 80 ) {
			color = Red;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-red-%d.png", [pwr pType]]];
		} else if ( rand <= 100 ) {
			color = Purple;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-purple-%d.png", [pwr pType]]];
		}

	}
	
	// Create ball
	Ball *b = [[Ball alloc] initWithIdentifier:count withImage:img withPowerup:pwr withColor:color withSmallSize:NO];
	
	// Increment identifier count
	count++;
	
	// Finally, return newly created ball
	return b;
}

- (Ball *)createBallWithColor:(Color)color {	
	// (Possible) Powerup
	Powerup *pwr = [[PowerupFactory sharedSingleton] createPowerup];
	
	// Image (based on possible powerup)
	UIImage *img;
	
	if ( pwr == nil ) {
		// Select from images WITHOUT powerups
		if ( color == Blue ) {
			img = [UIImage imageNamed:@"ball-blue.png"];
		} else if ( color == Green ) {
			img = [UIImage imageNamed:@"ball-green.png"];
		} else if ( color == Orange ) {
			img = [UIImage imageNamed:@"ball-orange.png"];
		} else if ( color == Red ) {
			img = [UIImage imageNamed:@"ball-red.png"];
		} else if ( color == Purple ) {
			img = [UIImage imageNamed:@"ball-purple.png"]; // color = Purple
		} else {
			;//color = Black,  dud
		}
	} else {
		// Select from images WITH powerups
		if ( color == Blue ) {
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-blue-%d.png", [pwr pType]]];
		} else if ( color == Green ) {
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-green-%d.png", [pwr pType]]];
		} else if ( color == Orange ) {
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-orange-%d.png", [pwr pType]]];
		} else if ( color == Red ) {
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-red-%d.png", [pwr pType]]];
		} else if ( color == Purple ) {
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-purple-%d.png", [pwr pType]]];
		} else {
			;//color = Black, dud
		}	
	}
	
	// Create ball
	Ball *b = [[Ball alloc] initWithIdentifier:count withImage:img withPowerup:pwr withColor:color withSmallSize:NO];
	
	// Increment identifier count
	count++;
	
	// Finally, return newly created ball
	return b;
}

- (Ball *)createSmallBall {
	// Determine ball properties
	
	// (Possible) Powerup
	Powerup *pwr = [[PowerupFactory sharedSingleton] createPowerup];
	
	// Image (based on possible powerup)
	UIImage *img;
	
	Color color;
	int rand = arc4random() % 100;
	
	if ( pwr == nil ) {
		// Select from images WITHOUT powerups
		if ( rand <= 20 ) {
			color = Blue;
			img = [UIImage imageNamed:@"ball-blue-small.png"];
		} else if ( rand <= 40 ) {
			color= Green;
			img = [UIImage imageNamed:@"ball-green-small.png"];
		} else if ( rand <= 60 ) {
			color = Orange;
			img = [UIImage imageNamed:@"ball-orange-small.png"];
		} else if ( rand <= 80 ) {
			color = Red;
			img = [UIImage imageNamed:@"ball-red-small.png"];
		} else if ( rand <= 100 ) {
			color = Purple;
			img = [UIImage imageNamed:@"ball-purple-small.png"];
		}
	} else {
		// Select from images WITH powerups
		if ( rand <= 20 ) {
			color = Blue;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-blue-small.png"]]; //-%d.png", [pwr pType]]];
		} else if ( rand <= 40 ) {
			color = Green;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-green-small.png"]]; //-%d.png", [pwr pType]]];
		} else if ( rand <= 60 ) {
			color = Orange;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-orange-small.png"]]; //-%d.png", [pwr pType]]];
		} else if ( rand <= 80 ) {
			color = Red;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-red-small.png"]]; //-%d.png", [pwr pType]]];
		} else if ( rand <= 100 ) {
			color = Purple;
			img = [UIImage imageNamed:[NSString stringWithFormat:@"ball-purple-small.png"]]; //-%d.png", [pwr pType]]];
		}
		
	}
	
	// Create ball
	Ball *b = [[Ball alloc] initWithIdentifier:count withImage:img withPowerup:pwr withColor:color withSmallSize:YES];
	
	// Increment identifier count
	count++;
	
	// Finally, return newly created ball
	return b;
}

- (Ball *)enlargeBall:(Ball *)b {

	Powerup *pwr = [b powerup];
	Color color = [b color];
	
	if ([b isDud]) {
		[b setImage:[UIImage imageNamed:@"ball-black.png"]];
		[b setRadius:BALL_WIDTH/2];
		return b;
	}
	if ( pwr == nil ) {
		// Select from images WITHOUT powerups
		if ( color == Blue ) {
			[b setImage:[UIImage imageNamed:@"ball-blue.png"]];
		} else if ( color == Green ) {
			[b setImage:[UIImage imageNamed:@"ball-green.png"]];
		} else if ( color == Orange ) {
			[b setImage:[UIImage imageNamed:@"ball-orange.png"]];
		} else if ( color == Red ) {
			[b setImage:[UIImage imageNamed:@"ball-red.png"]];
		} else if ( color == Purple ) {
			[b setImage:[UIImage imageNamed:@"ball-purple.png"]]; // color = Purple
		} else {
			;//color = Black,  dud
		}
	} else {
		// Select from images WITH powerups
		if ( color == Blue ) {
			[b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball-blue-%d.png", [pwr pType]]]];
		} else if ( color == Green ) {
			[b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball-green-%d.png", [pwr pType]]]];
		} else if ( color == Orange ) {
			[b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball-orange-%d.png", [pwr pType]]]];
		} else if ( color == Red ) {
			[b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball-red-%d.png", [pwr pType]]]];
		} else if ( color == Purple ) {
			[b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball-purple-%d.png", [pwr pType]]]];
		} else {
			;//color = Black, dud
		}	
	}	
	[b setRadius:BALL_WIDTH/2];	
	return b;	
}

- (void)resetCount { count = 0; }

@end