//
//  BallStackViewController.m
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "BallStackViewController.h"
#import "BallStackView.h"
#import "BallGrid.h"
#import "Game.h"
#import "Ball.h"
#import "Player.h"
#import "PlayerFactory.h"
#import "GENetworkManager.h"
#import "NetworkConstants.h"
#import "PowerupFactory.h"
#import <stdlib.h>

#define COUNTDOWN_INTERVAL 1
#define STATUS_UPDATE_INTERVAL 1
#define BALL_REMOVAL_PROB 50	// Only removes balls without children
#define BALL_DUD_PROB 10
#define BALL_UNDUD_PROB 80


// A class extension to declare private methods
@interface BallStackViewController ()
- (void)stopGame;
//- (void)home;
- (void)addTime;
- (void)leaveGame;
- (void)applyPowerup:(int)pType;
- (void)doCountdown;
- (void)stopCountdown;
- (void)startStatusUpdates;
- (void)stopStatusUpdates;
- (void)sendStatusUpdate;
- (void)handleStatusUpdateResponse:(NSArray *)response;
- (void)handlePowerupUsageResponse:(NSArray *)response;
- (void)handlePlayerJoinResponse:(NSArray *)response;
- (void)handlePlayerLeftResponse:(NSArray *)response;
- (void)handleStartGameResponse:(NSArray *)response;
- (void)handleAddTimeResponse:(NSArray *)response;
- (BOOL)victoryCheck;
- (void)breakDeathLine;
- (void)addBalls;
- (BOOL)shouldRemoveBall:(Ball *)aBall;
- (BOOL)shouldDudBall:(Ball *)aBall;
- (BOOL)shouldUndudBall:(Ball *)aBall;
- (void)alertVictory;
- (void)alertDeath;
@end

@implementation BallStackViewController

@synthesize addTimeButton, countdownLabel, countdown;
@synthesize ballGrid, ballLayer, ballHandler, statusUpdate;
@synthesize stackMoveAmount, lowBall, stackHeight;
@synthesize ballsNeedRemoved, ballsNeedDuds, ballsNeedUnduds;
@synthesize winSound, deathSound, powerdownSound, powerupSound, startSound, tickSound, tockSound;

- (id)init {
	if (self = [super init]) {
		// Setup game ball layer (this is re-used for all games)
		ballLayer = [[GELayer alloc] init];
		[self addLayer:ballLayer];
		// Setup collision handler
		ballHandler = [[BallCollisionHandler alloc] initWithGELayer:ballLayer];
		[self registerCollisionHandler:ballHandler];
		self.ballsNeedRemoved = NO;
		[self setupSounds];
    }
    return self;
}

+ (BallStackViewController *)sharedSingleton {
	static BallStackViewController *sharedSingleton;
	
	if (!sharedSingleton) sharedSingleton = [[BallStackViewController alloc] init];
	
	return sharedSingleton;
}

- (void)setupSounds {
    NSBundle *mainBundle = [NSBundle mainBundle];	
	winSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"win" ofType:@"wav"]];			
	deathSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"death" ofType:@"wav"]];		
	powerdownSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"powerdown" ofType:@"wav"]];		
	powerupSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"powerup" ofType:@"wav"]];		
	startSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"start" ofType:@"wav"]];	
	tickSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"tick" ofType:@"wav"]];	
	tockSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"tock" ofType:@"wav"]];		
}


- (void)loadView {
	[super loadView];
	
	//BallStackView *bsView = [[BallStackView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] managedByGameViewController:self];
	BallStackView *bsView = [[BallStackView alloc] initWithFrame:[[UIScreen mainScreen] bounds] managedByGameViewController:self];
	//BallStackView *bsView = [[BallStackView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0) managedByGameViewController:self];
	self.view = bsView;
	[bsView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Countdown label
	countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 100.0, 320.0, 60.0)];
	[countdownLabel setNumberOfLines:1];
	[countdownLabel setBackgroundColor:[UIColor clearColor]];
	[countdownLabel setFont:[UIFont boldSystemFontOfSize:48.0]];
	[countdownLabel setTextAlignment:UITextAlignmentCenter];
	
	/*
	// Home button
	UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[homeButton setFrame:CGRectMake(5.0, 360.0, 52.0, 52.0)];
	[homeButton setBackgroundImage:[UIImage imageNamed:@"homebutton.png"] forState:UIControlStateNormal];
	[homeButton addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:homeButton];
	*/
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[self view] setFrame:CGRectMake(0,0,320,480)];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self leaveGame];
	[self stopCountdown];
	[self stopGame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[ballLayer release];
	[ballHandler release];
	[winSound release];
	[powerupSound release];
	[deathSound release];
	[startSound release];
	[tickSound release];
	[tockSound release];
	[countdownLabel release];
    [super dealloc];
}

- (Game *)game {
	return game;
}

- (void)setGame:(Game *)theGame {
	game = theGame;
	
	//- - - GAME INSTANCE SPECIFIC DATA - - -
	lowBall = 0;
	ballGrid = [[BallGrid alloc] init];
	
	// Initialize add time button
	addTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[addTimeButton setFrame:CGRectMake(134.0, 48.0, 52.0, 52.0)];
	[addTimeButton setBackgroundImage:[UIImage imageNamed:@"addtimebutton.png"] forState:UIControlStateNormal];
	[addTimeButton addTarget:self action:@selector(addTime) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:addTimeButton];
	
	// Initialize game countdown
	countdown = [NSTimer scheduledTimerWithTimeInterval:COUNTDOWN_INTERVAL target:self selector:@selector(doCountdown) userInfo:nil repeats:YES];
	[countdownLabel setText:[NSString stringWithFormat:@"%d", [game secondsUntilStart]]];
	[[self view] addSubview:countdownLabel];
	
	// Clear ball layer
	[ballLayer removeAllGameObjects];
	
	// Reset game view
	[(BallStackView *)self.view initializeGameInstance];
}

/* 	Adds a predefined set of random balls to a layer
	Assumes that layers are 8 cols wide.
	All ball configurations are hard-coded as well. */
- (void)addRandomBalls {
	
	int rows = 3; // number of rows in these ballsets
	int cols = 10; //   "    "  cols "  "     "
	int col, row; // loop variables
	
	char* balls; 
	Ball *b;
	
	BallCell *bc;
	CGPoint p;
	
	/* first of many configuration patterns
	   g - Green, r - Red, y - yellow, b - blue, o - orange, x - empty
	   power-ups are still random */
	char balls0[3][10] = {
		{'g', 'r', 'b', 'p', 'p', 'b', 'r', 'g', 'b', 'p'},
		{'b', 'g', 'b', 'x', 'b', 'g', 'b', 'x', 'g', 'x'},
		{'r', 'p', 'o', 'x', 'x', 'o', 'p', 'r', 'p', 'x'}};

	char balls1[3][10] = {
		{'g', 'r', 'b', 'x', 'x', 'b', 'r', 'g', 'p', 'r'},
		{'x', 'g', 'x', 'x', 'x', 'g', 'x', 'x', 'b', 'x'},
		{'r', 'p', 'o', 'x', 'x', 'o', 'p', 'r', 'x', 'g'}};
	
	char balls2[3][10] = {
		{'b', 'g', 'b', 'x', 'b', 'g', 'b', 'x', 'g', 'r'},
		{'r', 'p', 'o', 'x', 'x', 'o', 'p', 'r', 'b', 'x'},
		{'x', 'g', 'b', 'x', 'b', 'g', 'x', 'x', 'b', 'r'}};
		
	char balls3[3][10] = {
		{'r', 'r', 'b', 'p', 'p', 'b', 'r', 'r', 'g', 'b'},
		{'b', 'g', 'b', 'x', 'b', 'g', 'b', 'x', 'p', 'x'},
		{'x', 'p', 'o', 'x', 'x', 'o', 'p', 'x', 'r', 'g'}};

	char balls4[3][10] = {
		{'p', 'b', 'r', 'g', 'p', 'r', 'b', 'p', 'b', 'g'},
		{'x', 'g', 'o', 'p', 'o', 'g', 'x', 'x', 'g', 'x'},
		{'r', 'o', 'b', 'x', 'x', 'p', 'o', 'r', 'r', 'p'}};	
	
	char balls5[3][10] = {
		{'g', 'r', 'b', 'p', 'p', 'b', 'r', 'g', 'b', 'g'},
		{'b', 'g', 'b', 'x', 'b', 'g', 'b', 'x', 'p', 'x'},
		{'r', 'p', 'o', 'x', 'x', 'o', 'p', 'r', 'b', 'r'}};	
	
	char balls6[3][10] = {
		{'g', 'r', 'b', 'p', 'p', 'b', 'r', 'g', 'b', 'r'},
		{'b', 'g', 'b', 'x', 'b', 'g', 'b', 'x', 'p', 'x'},
		{'r', 'p', 'o', 'x', 'x', 'o', 'p', 'r', 'b', 'r'}};	
	
	
	int rand = arc4random() % 7;  // random number to decide which set to use
	//NSLog(@"rand : %d", rand);

	// point balls to the chosen set 
	if (rand == 0) {
		balls = *balls0;
	} else if (rand == 1) {
		balls = *balls1;
	 } else if (rand == 2) {
		balls = *balls2;
	 } else if (rand == 3) {
		balls = *balls3;
	 } else if (rand == 4) {
		balls = *balls4;
	 } else if (rand == 5) {
		balls = *balls5;
	 } else { //rand == 6
		balls = *balls6;
	 }
	
	// make the balls, add them to the grid, the layer, make them active and
	// ready to sit there. Also set their frame, so they will be drawn
	int numCols; 
	for (row = 0; row < rows; row++) {
		if (row % 2 > 0) {  // odd row
			numCols = cols - 1;
		} else {
			numCols = cols;
		}
		for (col = 0; col < numCols; col++) {
			Color color;
			char c = *(balls + (row * cols) + col);
			if (c == 'g') {
				color = Green;
			} else if (c == 'b') {
				color = Blue;
			} else if (c == 'r') {
				color = Red;
			} else if (c == 'p') {
				color = Purple;
			} else if (c == 'o') {
				color = Orange;
			} else {
				continue;
			}
			// this is the ballCell they are going into
			bc = [[[ballGrid rows] objectAtIndex:row] objectAtIndex:col];
			// make a ball
			b = [[BallFactory sharedSingleton] createBallWithColor:color];					
			// initialize it 
			[b setActive:YES];
			[b setMoving:NO];	
			// let its cell know it lives here now
			[bc setCellBall:b];
			// add it to the layer and make it be drawn
			p = [bc pos];
			[b setPosition:p];
			//[b setFrame:CGRectMake(p.x, p.y, BALL_WIDTH, BALL_HEIGHT)];
			[[[BallStackViewController sharedSingleton] ballHandler] handlePostCollisionEvents:b];
			if (row == 0)
				[b setIsRoot:YES];
			[ballLayer addGameObject:b];
		}		
	}
}

- (void)addStartBalls {
	[[self startSound] play];		
	[[(BallStackView*)[self view] b1] undud];
	[[(BallStackView*)[self view] b2] undud];
}

- (void)startGame {
	// Add two starting balls to the game
	[self addStartBalls];
	
	// Add random balls to the game
	[self addRandomBalls];

	// Start game loop
	[self startGameLoop];

	//#- Does not execute doGameLoop via NSTimer
//	[NSThread detachNewThreadSelector:@selector(startGameLoop)
//							 toTarget:self
//						   withObject:nil];
	
	// Start status updates
	if ( [game gameId] != TEST_GAMEID ) [self startStatusUpdates];
	
	NSLog(@"Starting game ... [gameId: %d]", [game gameId]);
}

- (void)stopGame {
	// Stop game loop
	[self stopGameLoop];
	
	// Stop status updates
	[self stopStatusUpdates];
}
/*
- (void)home {
	[self.navigationController popToRootViewControllerAnimated:YES];
}
*/
- (void)addTime {
	if ( ![self active] ) {
		NSString *msg = [NSString stringWithFormat:@"%d", BSMessageAddTime];
		[[GENetworkManager sharedSingleton] sendMessage:msg];	
	}
}

- (void)leaveGame {
	NSString *msg = [NSString stringWithFormat:@"%d", BSMessageLeaveGame];
	[[GENetworkManager sharedSingleton] sendMessage:msg];
}

- (void)sendPowerupTo:(int)playerId {
	if ( [[(BallStackView *)self.view powerupQueue] available] ) {
		Powerup *p = [[(BallStackView *)self.view powerupQueue] dequeue];
		
		NSLog(@"sending powerup type %d to %d, take it!", [p pType], playerId);
		[[self powerupSound] play];
		if ( playerId == SELF_PLAYERID ) {
			[self applyPowerup:[p pType]];
		} else {
			NSString *msg = [NSString stringWithFormat:@"%d;%d;%d", BSMessagePowerupUsage, playerId, [p pType]];
			[[GENetworkManager sharedSingleton] sendMessage:msg];
		}
		
		[p release];
	}
}

- (void)applyPowerup:(int)pType {
	NSLog(@"Powerup type %d applied.", pType);
	[[self powerdownSound] play];
	switch ( pType ) {
		case PowerupStackUp:
			NSLog(@"StackUp");
			[self setStackMoveAmount:-STACK_MOVE_AMOUNT_POWERUP];
			break;
		case PowerupStackDown:
			NSLog(@"StackDown");
			[self setStackMoveAmount:STACK_MOVE_AMOUNT_POWERUP];
			break;
		//case PowerupStackClear:
		//	NSLog(@"StackClear");
		//	break;
		case PowerupAddBalls:
			NSLog(@"AddBalls");
			[self addBalls];
			break;
		case PowerupRemoveBalls:
			NSLog(@"RemoveBalls");
			ballsNeedRemoved = YES;
			break;
		case PowerupDudBalls:
			NSLog(@"DudBalls");
			ballsNeedDuds = YES;
			break;
		case PowerupUndudBalls:
			NSLog(@"UndudBalls");
			ballsNeedUnduds = YES;
			break;
		//case PowerupScrambleBalls:
		//	NSLog(@"ScrambleBalls");	
		//	break;
		default:
			break;
	}
}

- (void)doCountdown {
	[game decrementSeconds];
	int secondsUntilStart = [game secondsUntilStart];
	if (secondsUntilStart == 0) {
		[self stopCountdown];
	} else {
		[countdownLabel setText:[NSString stringWithFormat:@"%d", secondsUntilStart]];
		if (secondsUntilStart % 2 == 0) {	
			[[self tickSound] play];
		} else {
			[[self tockSound] play];
		}
	}
}

- (void)stopCountdown {
	// Stop countdown timer and remove display
	if ( countdown != nil ) {
		NSLog(@"countdown stopped.");
		[countdownLabel removeFromSuperview];
		[countdown invalidate];
		countdown = nil;
		
		// Remove addTime button
		[addTimeButton removeFromSuperview];
	}
}

- (void)startStatusUpdates {
	statusUpdate = [NSTimer scheduledTimerWithTimeInterval:STATUS_UPDATE_INTERVAL target:self selector:@selector(sendStatusUpdate) userInfo:nil repeats:YES];
}

- (void)stopStatusUpdates {
	if ( statusUpdate != nil ) {
		NSLog(@"status updates stopped.");
		[statusUpdate invalidate];
		statusUpdate = nil;
	}
}

- (void)sendStatusUpdate {
	// Determine if we need to account for ball height
	//   Only when there are balls in the stack
	int bCount = [[ballLayer gameObjects] count];
	
	BOOL emptyStack = ( bCount <= 2 ) ? YES : NO;
	int ballHeight = ( emptyStack ) ? 0 : BALL_HEIGHT - VERTICAL_ADJUSTMENT;

	int status = 100 - ((lowBall + ballHeight) / (float)DEATH_LINE) * 100;
	if ( status <= -1 ) status = -1;
	else if ( status >= 100 ) status = 100;
		
	NSString *msg = [NSString stringWithFormat:@"%d;%d", BSMessageStatusUpdate, status];
	[[GENetworkManager sharedSingleton] sendMessage:msg];	
}

/* Moves the stack. This method assumes that the shared singleton
   in BallStackViewController has had stackMoveAmount set to the integer 
   value that is to be moved. Note that setting stackMoveAmount to a negative 
   value moves the stack up on the screen and a positive value moves the stack 
   down
 */
- (void)moveStack {
	CGPoint p;
	NSMutableArray *balls = [ballLayer gameObjects];	
	if (stackHeight + stackMoveAmount < 0) {
		stackMoveAmount = -stackHeight;
		stackHeight = 0;
	} else {
		stackHeight += stackMoveAmount;		
	}
	for ( Ball *b in balls ) {
		if ([b moving]) continue; 
		p = [b position];
		[b setPosition:CGPointMake(p.x, p.y + stackMoveAmount)];
		//[b setFrame:CGRectMake(p.x, p.y + stackMoveAmount, BALL_WIDTH, BALL_HEIGHT)];
	}
	[[(BallStackView*)[self view] stack]  setFrame:CGRectMake(0, stackHeight - STACK_PIC_HEIGHT, STACK_PIC_WIDTH, STACK_PIC_HEIGHT)];
	
	[self setStackMoveAmount:0];
}

- (void)update {
	[super update];
	
	// Are you the winner?
	if ( [self victoryCheck] ) {
		[self stopGame];
		[[self winSound] play];		
		[self alertVictory];
		return;
	}
	
	// move the stack if it needs to be moved  
	[[BallStackViewController sharedSingleton] moveStack];	
	
	NSMutableArray *balls = [ballLayer gameObjects];
	
	NSMutableArray *ballsToRemove = nil;
	if ( ballsNeedRemoved ) {
		int capacity = ( [balls count] / (float)BALL_REMOVAL_PROB );
		ballsToRemove = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	// Iterate ball layer only
	// 1. Determine the lowest ball and check against death line
	// 2. If balls need removed due to powerup, determine which
	
	lowBall = 0; // reset (lowest ball per update)
	for ( Ball *b in balls ) {
		// Check stationary balls (only active balls should remain at this point)
		if ( ![b moving] ) {
			float posY = [b position].y;
			
			// Find low ball
			if ( (int)posY > lowBall ) [self setLowBall:(int)posY];
			
			// Check for DEATH
			if ( posY + BALL_HEIGHT - VERTICAL_ADJUSTMENT > DEATH_LINE ) {
				[self breakDeathLine];
				return;
			}
			
			// If balls need removed/dud/undud (due to powerup), check to see
			//   if the current ball is a victim. :)
			if ( ballsNeedRemoved && [self shouldRemoveBall:b] ) {
				[ballsToRemove addObject:b];
			} else if ( ballsNeedDuds && [self shouldDudBall:b] ) {
				[b dud];
			} else if ( ballsNeedUnduds&& [self shouldUndudBall:b] ) {
				[b undud];
			}
		}
	}
	
	// Now remove balls if needed
	//   It is safe to actually remove the balls from the ballLayer 
	//   gameObjects since we are the only one iterating it at the moment.
	if ( ballsNeedRemoved && [ballsToRemove count] > 0 ) {
		for ( Ball *bRemove in ballsToRemove ) [bRemove pop];
	}
	if ( ballsToRemove != nil ) [ballsToRemove release];
	
	ballsNeedRemoved = NO;
	ballsNeedDuds = NO;
	ballsNeedUnduds = NO;
}

- (BOOL)victoryCheck {
	BOOL victoryIsMine = YES;
	if ( [[game players] count] > 1 ) {
		// Opponents exist, check if they are all dead
		for ( Player *p in [game players] ) {
			if ( [p playerId] == SELF_PLAYERID ) continue;
			if ( [p status] != -1 ) {
				victoryIsMine = NO;
				break;
			}
		}
	} else {
		// Single player mode, you cannot win!
		victoryIsMine = NO;
	}
	return victoryIsMine;
}

- (void)breakDeathLine {
	NSString *msg = [NSString stringWithFormat:@"%d;-1", BSMessageStatusUpdate];
	[[GENetworkManager sharedSingleton] sendMessage:msg];
	[self stopGame];
	[[self deathSound] play];
	[self alertDeath];
}

- (void)addBalls {
	// Add between 3 and 5 new balls
	int numBalls = arc4random() % 3 + 3;
	//NSLog(@"addBalls, numBalls = %d", numBalls);
	
	for ( int i = 0; i < numBalls; i++ ) {
		NSLog(@"addBalls, ball #%d", i);
		
		// Determine a valid grid cell to place the ball
		NSMutableArray *rowZero = [[ballGrid rows] objectAtIndex:0];
		
		int randomZeroIndex = arc4random() % NUM_COLS;
		//NSLog(@"randomZeroIndex: %d", randomZeroIndex);
		BallCell *randomZeroCell = [rowZero objectAtIndex:randomZeroIndex];
		BallCell *targetCell = randomZeroCell;
		
		if ( [[ballLayer gameObjects] count] > 2 ) {
			// Screen is not "empty", therefore perform add balls search.
			//   In the case that the screen IS "empty", this search will not be
			//   performed and the 'targetCell' will be used to place the new ball.
			
			while ( [randomZeroCell empty] ) {
				randomZeroIndex = arc4random() % NUM_COLS;
				//NSLog(@"randomZeroIndex: %d", randomZeroIndex);
				randomZeroCell = [rowZero objectAtIndex:randomZeroIndex];		
			}
			
			// Found start cell, traverse children
			Ball *targetBall = [randomZeroCell cellBall];
			while ( [targetBall hasChildren] ) {
				// Pick a child
				if ( [[targetBall children] count] == 2 ) {
					// Choose the favorite child
					//NSLog(@"[targetBall] two children");
					int childIndex = arc4random() % 2;
					targetBall = [[targetBall children] objectAtIndex:childIndex];
				} else {
					// Only one child, easy pickings
					//NSLog(@"[targetBall] one child");
					targetBall = [[targetBall children] objectAtIndex:0];
				}
			}
			
			// Found target ball with no children
			CGPoint center = [targetBall centerPosition];
			//CGPoint targetCenter = CGPointMake(center.x + (BALL_WIDTH / 2.0), center.y - [[BallStackViewController sharedSingleton] stackHeight]);
			CGPoint targetCenter = CGPointMake(center.x, center.y/* - [[BallStackViewController sharedSingleton] stackHeight]*/);
			NSLog(@"before calcRow/Col");
			int targetRow = [ballGrid calculateRow:targetCenter];
			if (targetRow % 2 > 0)
				targetCenter.x += (BALL_WIDTH/2) - 1;
			int targetCol = [ballGrid calculateCol:targetCenter];
			NSLog(@"[targetcell] %d x %d", targetRow, targetCol);
			
			int newRow = targetRow;
			int newCol = targetCol;
			if ( ![targetBall hasSiblings] ) {
				NSLog(@"[ADD] sibling position");
				
				// No siblings, add ball to one of the sibling positions
				if ( newRow % 2 > 0 ) {
					// Odd (short) row
					if ( newCol == 0 ) {
						// Leftmost column, move right 1
						newCol += 1;
					} else if ( newCol == (NUM_COLS - 2) ) {
						// Rightmost column, move left 1
						newCol -= 1;
					} else {
						// Middle column
						int adjustment = arc4random() % 2; // Subtract 1 or Add 1 to column index
						if ( adjustment == 0 ) {
							newCol -= 1;
						} else {
							newCol += 1;
						}
					}
					
				} else {
					// Even (long) row
					if ( newCol == 0 ) {
						// Leftmost column, move right 1
						newCol += 1;
					} else if ( newCol == (NUM_COLS - 1) ) {
						// Rightmost column, move left 1
						newCol -= 1;
					} else {
						// Middle column
						int adjustment = arc4random() % 2; // Subtract 1 or Add 1 to column index
						if ( adjustment == 0 ) {
							newCol -= 1;
						} else {
							newCol += 1;
						}
					}
				}
				
			} else {
				// Siblings exist, add ball to a child position
				NSLog(@"[ADD] child position");
				
				// Bump down to next row
				newRow += 1;

				if ( newRow % 2 > 0 ) {
					// Odd (short) row
					NSLog(@"odd (short) row");
					if ( newCol == 0 ) {
						// Leftmost column, leave index
						NSLog(@"leftmost");
					} else if ( newCol == (NUM_COLS - 1) ) {
						// Rightmost column, move left 1
						newCol -= 1;
						NSLog(@"rightmost");
					} else {
						// Middle column
						NSLog(@"midmost");
						int adjustment = arc4random() % 2; // Subtract 0 or 1 to column index
						newCol -= adjustment;
					}
				} else {
					// Even (long) row
					NSLog(@"even (long) row");
					int adjustment = arc4random() % 2; // Add 0 or 1 to column index
					newCol += adjustment;
				}
				
			}
			
			NSLog(@"[newcell] %d x %d", newRow, newCol);
			
			// Insert ball into cell
			targetCell = [[[ballGrid rows] objectAtIndex:newRow] objectAtIndex:newCol];
		}
		
		CGPoint targetPos = [targetCell pos];
		Ball *b = [[BallFactory sharedSingleton] createBall];
		if ([targetCell row] == 0) [b setIsRoot:YES];
		//[b setBallPositionX:targetPos.x andY:targetPos.y];
		[b setPosition:CGPointMake(targetPos.x, targetPos.y + [[BallStackViewController sharedSingleton] stackHeight])];
		[b setMoving:NO];
		
		// Add ball to ballLayer
		[[[BallStackViewController sharedSingleton] ballLayer] addGameObject:b];
		
		// 'handlePostCollisionEvents' on ball
		[[[BallStackViewController sharedSingleton] ballHandler] handlePostCollisionEvents:b];
	}
}

- (BOOL)shouldRemoveBall:(Ball *)aBall {
	int rand = arc4random() % 100;
	return ( rand <= BALL_REMOVAL_PROB && [[aBall children] count] == 0 ) ? YES : NO;
}

- (BOOL)shouldDudBall:(Ball *)aBall {
	int rand = arc4random() % 100;
	return ( ![aBall isDud] && rand <= BALL_DUD_PROB ) ? YES : NO;
}

- (BOOL)shouldUndudBall:(Ball *)aBall {
	int rand = arc4random() % 100;
	return ( [aBall isDud] && rand <= BALL_UNDUD_PROB ) ? YES : NO;
}

//- - - Networking - - -
- (void)parseServerMessage:(NSString *)msg {
	NSArray *msgData = [msg componentsSeparatedByString:@";"];
	
	BSMessage bsm = [[msgData objectAtIndex:BSMESSAGE_TYPE_INDEX] intValue];
	
	switch (bsm) {
		case BSMessageUnknown:
			NSLog(@"[BSMessageUnknown]");
			break;
		case BSMessageStatusUpdate:
			NSLog(@"[BSMessageStatusUpdate]");
			[self handleStatusUpdateResponse:msgData];
			break;
		case BSMessagePowerupUsage:
			NSLog(@"[BSMessagePowerupUsage]");
			[self handlePowerupUsageResponse:msgData];
			break;
		case BSMessagePlayerJoin:
			NSLog(@"[BSMessagePlayerJoin]");
			[self handlePlayerJoinResponse:msgData];
			break;
		case BSMessagePlayerLeft:
			NSLog(@"[BSMessagePlayerLeft]");
			[self handlePlayerLeftResponse:msgData];
			break;
		case BSMessageStartGame:
			NSLog(@"[BSMessageStartGame]");
			[self handleStartGameResponse:msgData];
			break;
		case BSMessageAddTime:
			NSLog(@"[BSMessageAddTime]");
			[self handleAddTimeResponse:msgData];
			break;			
		default:
			break;
	}
}

- (void)handleStatusUpdateResponse:(NSArray *)response {
	if ( [self active] ) {
		int playerId = [[response objectAtIndex:BSMESSAGE_STATUSUPDATE_PLAYERID_INDEX] intValue];
		int status = [[response objectAtIndex:BSMESSAGE_STATUSUPDATE_STATUS_INDEX] intValue];
		//NSLog(@"Player %d, Status %d", playerId, status);
		[game setStatus:status forPlayer:playerId];
	}
}

- (void)handlePowerupUsageResponse:(NSArray *)response {
	if ( [self active] ) {
		int powerupType = [[response objectAtIndex:BSMESSAGE_POWERUPUSAGE_TYPE_INDEX] intValue];
		[self applyPowerup:powerupType];
	}
}

- (void)handlePlayerJoinResponse:(NSArray *)response {
	int playerId = [[response objectAtIndex:BSMESSAGE_PLAYERJOIN_PLAYERID_INDEX] intValue];
	NSLog(@"Player %d joined game.", playerId);
		
	// Add player to opponents
	Player *p = [[PlayerFactory sharedSingleton] createPlayerWithPlayerId:playerId];
	[game addPlayer:p];
	
	// Reload opponent view
	[[(BallStackView *)self.view opponentsView] reload];
}

- (void)handlePlayerLeftResponse:(NSArray *)response {
	int playerId = [[response objectAtIndex:BSMESSAGE_PLAYERLEFT_PLAYERID_INDEX] intValue];
	NSLog(@"Player %d left game.", playerId);
	[game removePlayer:playerId];
	
	// Reload opponent view
	[[(BallStackView *)self.view opponentsView] reload];
}

- (void)handleStartGameResponse:(NSArray *)response {
	[self stopCountdown];
	[self startGame];
}

- (void)handleAddTimeResponse:(NSArray *)response {
	if ( ![self active] ) {
		int seconds = [[response objectAtIndex:BSMESSAGE_JOINGAME_ADDTIME_SECONDS_INDEX] intValue];
		if ( seconds == BSMESSAGE_FAILURE ) {
			NSLog(@"Failed to add time.");
		} else {
			NSLog(@"Successfully added time. New secondsUntilStart = %d", seconds);
			
			[game setSecondsUntilStart:seconds];
		}
	}
}

//- - - Alerts - - -
- (void)alertVictory {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awesome"
													message:@"Flawless Victory!"
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	
}

- (void)alertDeath {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Darn"
													message:@"Looks like you suck."
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];
	[alert release];

}

@end
