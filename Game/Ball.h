//
//  Ball.h
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
#import "GEGameObject.h"
#import "BallFactory.h"
#import <AudioToolbox/AudioServices.h>

#define BALL_WIDTH         32.0
#define BALL_HEIGHT        28.0
#define SMALL_BALL_WIDTH   24.0
#define SMALL_BALL_HEIGHT  24.0
#define ORG_X              145
#define ORG_Y              370 //335
#define DECK_X             195 //185
#define DECK_Y             385
#define DX                 ((ORG_X+BALL_WIDTH/2) - (DECK_X+SMALL_BALL_WIDTH/2))
#define DY                 ((ORG_Y+BALL_HEIGHT/2) - (DECK_Y+SMALL_BALL_HEIGHT/2))
#define LOAD_X			   DX/sqrt(DX*DX+DY*DY)     // unit vector in x direction from on deck position to loaded position
#define LOAD_Y			   DY/sqrt(DX*DX+DY*DY)		// unit vector in y direction from on deck position to loaded position
#define LOAD_ADJUSTEMENT   4                  // fudge factor for determining when the ball is loaded
#define SPEED              15
#define SLOW_SPEED         5

#define SCREEN_WIDTH       320
#define SCREEN_HEIGHT      480

@class Powerup;

@interface Ball : GEGameObject {

@private
	BOOL ready;
	BOOL isDud;
	Powerup *powerup;
	Color color;
	NSMutableArray *parents;
	NSMutableArray *children;
	NSMutableArray *siblings;
	BOOL isRoot;
	BOOL isSmall;
}

@property (nonatomic, assign) BOOL ready;
@property (nonatomic, assign) BOOL isDud;
@property (nonatomic, retain) Powerup *powerup;
@property (nonatomic, assign) Color color;
@property (nonatomic, retain) NSMutableArray *parents;
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, retain) NSMutableArray *siblings;
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, assign) BOOL isSmall;


- (id)initWithIdentifier:(int)ident withImage:(UIImage *)img withPowerup:(Powerup *)aPowerup withColor:(Color)color withSmallSize:(BOOL)small;
- (void)setBallPositionX:(double)x andY:(double)y;
- (BOOL)hasPowerup;
- (void)update;
- (void)addParent:(Ball*) parent;
- (void)addChild:(Ball*) child;
- (void)addSibling:(Ball*) sibling;
- (BOOL)removeParent:(Ball*)parent;
- (BOOL)removeChild:(Ball*)child;
- (BOOL)removeSibling:(Ball*)sibling;
- (BOOL)hasChildren;
- (BOOL)hasSiblings;
- (CGPoint)centerPosition;
- (void)dud;
- (void)undud;
- (void)pop;
- (NSMutableArray*)isRooted;
- (void)draw;


@end
