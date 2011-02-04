//
//  BallStackView.m
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BallStackView.h"
#import "BallStackMenuView.h"
#import "GEGameViewController.h"
#import "BallFactory.h"
#import "BallStackViewController.h"
#import "PlayerFactory.h"
#import "PowerupFactory.h"
#import "OpponentsView.h"

// A class extension to declare private methods
@interface BallStackView ()
- (void)handleTap:(UITouch *)touch;
- (void)handleDoubleTouch:(UITouch *)touch;
@end

@implementation BallStackView

@synthesize b1, b2, powerupQueue, opponentsView, stack, popSound, loadSound, shootSound;

- (id)initWithFrame:(CGRect)frame managedByGameViewController:(GEGameViewController *)aController {
	if (self = [super initWithFrame:frame managedByGameViewController:aController]) {
		
		self.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]]; 
		
		//#- Touch events are only handled by this view
		self.exclusiveTouch = YES;
		self.multipleTouchEnabled = YES;
		
		// Setup powerup queue view
		powerupQueue = [[PowerupQueue alloc] initWithFrame:CGRectMake(0.0, 410.0, 320.0, 30.0)];
		[self addSubview:powerupQueue];
		
		// Setup opponent view
		opponentsView = [[OpponentsView alloc] initWithFrame:CGRectMake(0.0, 440.0, 320.0, 40.0)];
		[self addSubview:opponentsView];
		
        [self setupSounds];

    }
    return self;
}

- (void)setupSounds {
    NSBundle *mainBundle = [NSBundle mainBundle];	
	popSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"pop" ofType:@"wav"]];
	loadSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"load" ofType:@"wav"]];
	//shootSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"shoot" ofType:@"wav"]];
}


- (void)dealloc {
	[stack release];
	[powerupQueue release];
	[opponentsView release];
	[popSound release];
    [loadSound release];
    [shootSound release];  
    [super dealloc];
}

- (void)initializeGameInstance {
	//NSLog(@"initialize my balls");
	
	[[BallFactory sharedSingleton] resetCount];
	[[PlayerFactory sharedSingleton] resetDisplayId];
	
	[[[BallStackViewController sharedSingleton] ballLayer] removeAllGameObjects];

	b1 = [[BallFactory sharedSingleton] createBall];
	[b1 setBallPositionX:ORG_X andY:ORG_Y];
	b2 = [[BallFactory sharedSingleton] createSmallBall];
	[b2 setBallPositionX:DECK_X andY:DECK_Y];
	
	[b1 setReady:YES];
	[b1 dud];
	[b2 setReady:NO];
	[b2 dud];
			
	// Add balls to layer
	[[[BallStackViewController sharedSingleton] ballLayer] addGameObject:b1];
	[[[BallStackViewController sharedSingleton] ballLayer] addGameObject:b2];

	// if stack is set, remove it from its superview
	if ([self stack]) [[self stack]removeFromSuperview];
	
	// choose a random background for stack
	int rand = arc4random() % 4;
//	NSString *pic = [NSString stringWithFormat:@"stack%d.png", rand];
	self.stack = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"stack%d.png", rand]]]; 

	// Set up stack graphic that will appear to push the balls down the screen
	[[self stack] setFrame:CGRectMake(0, -400, 320, 400)];
	[self addSubview:[self stack]];
	[[self stack] setNeedsDisplay];
	
	// Reset the stack height
	[[BallStackViewController sharedSingleton] setStackHeight:0];
	[[BallStackViewController sharedSingleton] setStackMoveAmount:0];

	// Reload opponent view
	[opponentsView reload];
	
	// Initialize powerup queue view
	[powerupQueue clear];

	[powerupQueue enqueue:[[PowerupFactory sharedSingleton] createPowerupOfType:PowerupStackUp]];
	[powerupQueue enqueue:[[PowerupFactory sharedSingleton] createPowerupOfType:PowerupRemoveBalls]];
	[powerupQueue enqueue:[[PowerupFactory sharedSingleton] createPowerupOfType:PowerupStackDown]];
	[powerupQueue enqueue:[[PowerupFactory sharedSingleton] createPowerupOfType:PowerupAddBalls]];
	[powerupQueue enqueue:[[PowerupFactory sharedSingleton] createPowerupOfType:PowerupDudBalls]];
	[powerupQueue enqueue:[[PowerupFactory sharedSingleton] createPowerupOfType:PowerupUndudBalls]];

	// Force a re-draw to clear previous game contents
	[[self stack] setNeedsDisplay];
	[self setNeedsDisplay];
}

//- - - Touch Events - - -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	int touchNum = [touches count];
	NSLog(@"touchNum = %d", touchNum);
	int taps = [touch tapCount];

	if ( touchNum == 2 ) {
		// Display in game menu
		[self handleDoubleTouch:touch];		
	} else if ( taps == 1 ) {
		// Handle touch events if game is active
		if ( [[BallStackViewController sharedSingleton] active] ) {
			UITouchPhase phase = [touch phase];
			if ( phase == UITouchPhaseBegan ) {
				[self handleTap:touch];
			} else {
				[self.nextResponder touchesBegan:touches withEvent:event];
			}
		}
	}
}

- (void)handleTap:(UITouch *)touch {
	BallStackViewController* bsvc = [BallStackViewController sharedSingleton];
	// grab touch location
	CGPoint p = [touch locationInView:self];
	NSLog(@"[touch] %.4f x %.4f", p.x, p.y);
	
	// if ball 1 is in position and ready to be fired
	if ( ![[[bsvc ballHandler] gameObject] moving] && [b1 ready] ) {

		double theta = atan((ORG_Y-p.y)/abs(ORG_X-p.x));
		
		// if the touch occurred outside valid range, ignore it
		if (theta < MIN_SHOOT_ANGLE) return;

		[bsvc setStackMoveAmount:([bsvc stackMoveAmount] + STACK_MOVE_AMOUNT_SHOT)];
		// move the stack if it needs to be moved  
		[[BallStackViewController sharedSingleton] moveStack];	
		
		// get touch's position relative to the center of the ball at its origin
		p.x -= ORG_X+BALL_WIDTH/2;
		p.y -= ORG_Y+BALL_HEIGHT/2;		
		
		double dist = sqrt(p.x*p.x + p.y*p.y);
		
		CGFloat ballX = p.x/dist;
		CGFloat ballY = p.y/dist;
		
		//NSLog(@"[dirVector] %.4f x %.4f", ballX, ballY);
		//float dirmag = sqrt(ballX*ballX + ballY*ballY);
		//NSLog(@"magnitude %f", dirmag);
		[b1 setDirection:CGPointMake(ballX, ballY)]; 
		[[[BallStackViewController sharedSingleton] ballHandler] setGameObject:b1];

		// play a shooting sound
		//[[self shootSound] play];		
		
		// play a loading sound
		[[self loadSound] play];
		b1 = b2;

		[b1 setDirection:CGPointMake(LOAD_X, LOAD_Y)]; 
		
		b2 = [[BallFactory sharedSingleton] createSmallBall];
		[b2 setBallPositionX:DECK_X andY:DECK_Y];
		
		[[[BallStackViewController sharedSingleton] ballLayer] addGameObject:b2];
	}
}

- (void)handleDoubleTouch:(UITouch *)touch {
	BallStackMenuView *menu = [[BallStackMenuView alloc] initWithFrame:self.frame];
	[self addSubview:menu];
}

@end
