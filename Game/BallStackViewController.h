//
//  BallStackViewController.h
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEGameViewController.h"
#import "GELayer.h"
#import "PowerupQueue.h"
#import "BallGrid.h"
#import "SoundEffect.h"

@class BallCollisionHandler, Game;

#define STACK_MOVE_AMOUNT_SHOT    10 // distance stack moves when a shot is taken
#define STACK_MOVE_AMOUNT_POWERUP 20 // distance stack moves when a powerup is received
#define STACK_PIC_HEIGHT 400
#define STACK_PIC_WIDTH  320
#define DEATH_LINE		  320	//Distance of death line (y value) from origin

@interface BallStackViewController : GEGameViewController {

@private
	Game *game;
	GELayer *ballLayer;
	BallCollisionHandler *ballHandler;
	BallGrid *ballGrid;
	int lowBall;
	int stackHeight;
	int stackMoveAmount;
	UIButton *addTimeButton;
	UILabel *countdownLabel;
	NSTimer *countdown;
	NSTimer *statusUpdate;
	BOOL ballsNeedRemoved;
	BOOL ballsNeedDuds;
	BOOL ballsNeedUnduds;	
	SoundEffect *winSound;
	SoundEffect *deathSound;	
	SoundEffect *powerdownSound;	
	SoundEffect *powerupSound;	
	SoundEffect *startSound;
	SoundEffect *tickSound;
	SoundEffect *tockSound;	
	
}

@property (nonatomic, retain) GELayer *ballLayer;
@property (nonatomic, retain) BallCollisionHandler *ballHandler;
@property (nonatomic, assign) int lowBall;
@property (nonatomic, assign) int stackMoveAmount;
@property (nonatomic, assign) int stackHeight;
@property (nonatomic, retain) UIButton *addTimeButton;
@property (nonatomic, retain) UILabel *countdownLabel;
@property (nonatomic, retain) NSTimer *countdown;
@property (nonatomic, retain) NSTimer *statusUpdate;
@property (nonatomic, retain) BallGrid *ballGrid;
@property (nonatomic, assign) BOOL ballsNeedRemoved;
@property (nonatomic, assign) BOOL ballsNeedDuds;
@property (nonatomic, assign) BOOL ballsNeedUnduds;
@property (nonatomic, retain) SoundEffect *winSound;
@property (nonatomic, retain) SoundEffect *deathSound;
@property (nonatomic, retain) SoundEffect *powerdownSound;
@property (nonatomic, retain) SoundEffect *powerupSound;
@property (nonatomic, retain) SoundEffect *startSound;
@property (nonatomic, retain) SoundEffect *tickSound;
@property (nonatomic, retain) SoundEffect *tockSound;


+ (BallStackViewController *)sharedSingleton;
- (Game *)game;
- (void)setGame:(Game *)theGame;
- (void)addRandomBalls;
- (void)startGame;
- (void)update;
- (void)sendPowerupTo:(int)playerId;
- (void)moveStack;
- (void)setupSounds;


@end

