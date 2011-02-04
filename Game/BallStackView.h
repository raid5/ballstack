//
//  BallStackView.h
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Math.h>
#import "GESingleViewGame.h"
#import "Ball.h"
#import "BallCollisionHandler.h"
#import "SoundEffect.h"

#define MIN_SHOOT_ANGLE  M_PI/10.0

@class PowerupQueue, OpponentsView;

@interface BallStackView : GESingleViewGame {

@private
	Ball *b1;
	Ball *b2;
	PowerupQueue *powerupQueue;
	OpponentsView *opponentsView;
	UIImageView *stack;
	SoundEffect *popSound;
	SoundEffect *loadSound;	
	SoundEffect *shootSound;	
}

@property (nonatomic, retain) Ball *b1;
@property (nonatomic, retain) Ball *b2;
@property (nonatomic, retain) PowerupQueue *powerupQueue;
@property (nonatomic, retain) OpponentsView *opponentsView;
@property (nonatomic, retain) UIImageView *stack;
@property (nonatomic, retain) SoundEffect *popSound;
@property (nonatomic, retain) SoundEffect *loadSound;
@property (nonatomic, retain) SoundEffect *shootSound;

- (id)initWithFrame:(CGRect)frame managedByGameViewController:(GEGameViewController *)aController;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)initializeGameInstance;
- (void)setupSounds;

@end
