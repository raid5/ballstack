//
//  Ball.m
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#import "BallStackView.h"
#import "Powerup.h"
#import "BallCollisionHandler.h"

@interface Ball (Private)
- (void)drawBall;
@end

@implementation Ball

@synthesize ready, isDud, powerup, color, children, parents, siblings, isRoot, isSmall;

/*
 * New balls will default to the "original" location. If you wish to change the balls initial
 *	position call the setBallPositionX:andY: method after ball creation. In addition, a ball
 *	will possibily have a Powerup associated with it. Pass in nil for aPowerup if the ball does
 *	not have an associated Powerup.
 */
- (id)initWithIdentifier:(int)ident withImage:(UIImage *)img withPowerup:(Powerup *)aPowerup withColor:(Color)c withSmallSize:(BOOL)small {
	if (self = [super init]) {
		[self setIdentifier:ident];
		[self setImage:img];
		[self setPowerup:aPowerup];
		
		if (small)	[self setRadius:SMALL_BALL_WIDTH/2];
		else [self setRadius:BALL_WIDTH/2];
		
		[self setMoving:YES];
		[self setReady:NO];
		//[self setBallPositionX:ORG_X andY:ORG_Y];
		[self setColor:c];
		[self setIsSmall:small];
		
		parents = [[NSMutableArray alloc] init];
		children = [[NSMutableArray alloc] init];
		siblings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setBallPositionX:(double)x andY:(double)y {
	[self setFrame:CGRectMake(x, y, BALL_WIDTH, BALL_HEIGHT)];
	[self setPosition:self.frame.origin];
}

- (BOOL)hasPowerup {
	return ( powerup != nil ) ? YES : NO;
}

- (void)update {
	//CGPoint org = self.frame.origin;
	double newX, newY;
	//NSMutableArray *p = [[NSMutableArray alloc] initWithCapacity:4];
	//NSMutableArray *c = [[NSMutableArray alloc] initWithCapacity:4];
	//NSMutableArray *s = [[NSMutableArray alloc] initWithCapacity:4];
	
	/*
	for (Ball* parent in [self parents]) {
		if (![parent active]) {
			NSLog(@"[warning] removed inactive parent during update loop!\n");
			[p addObject:parent];
		}
	}
	for (Ball* child in [self children]) {
		if (![child active]) {
			NSLog(@"[warning] removed inactive child during update loop!\n");
			[c addObject:child];
		}
	}
	for (Ball* sibling in [self siblings]) {
		if (![sibling active]) {
			NSLog(@"[warning] removed inactive sibling during update loop!\n");
			[s addObject:sibling];
		}
	}
	
	while ([s count] > 0) {
		[siblings removeObject:[s objectAtIndex:0]];
		[s removeObjectAtIndex:0];
	}
	
	while ([c count] > 0) {
		[children removeObject:[c objectAtIndex:0]];
		[c removeObjectAtIndex:0];
	}
	
	while ([p count] > 0) {
		[parents removeObject:[p objectAtIndex:0]];
		[p removeObjectAtIndex:0];
	}
	*/
	
	if ([self moving]) {
		if (![self ready]) {
			newX = position.x + direction.x * SLOW_SPEED;
			newY = position.y + direction.y * SLOW_SPEED;	
		} else {
			newX = position.x + direction.x * SPEED;
			newY = position.y + direction.y * SPEED;			
		}
		
		int stackHeight = [[BallStackViewController sharedSingleton] stackHeight];
		//Need to make sure newX is within bounds before we set position

	

		if (newX >= 0 && newX <= SCREEN_WIDTH - BALL_WIDTH) {
			if (newY > [[BallStackViewController sharedSingleton] stackHeight]  && newY < 450) {
				if (newY-ORG_Y < LOAD_ADJUSTEMENT && newY - ORG_Y > 0 && abs(newX-ORG_X) < LOAD_ADJUSTEMENT) {
					[self setDirection:CGPointMake(0, 0)];
					[[BallFactory sharedSingleton] enlargeBall:self];					
					[self setReady:YES];
				}
				[self setPosition:CGPointMake(newX, newY)];
			} else {
				newY = (newY < stackHeight ) ? stackHeight : 449;
				[self setPosition:CGPointMake(newX, newY)];
				[self setMoving:NO];
				// snap to grid
				[[[BallStackViewController sharedSingleton] ballHandler] handlePostCollisionEvents:self];
				
			}
		} else {
			direction.x *= -1;
			newY = (newY < stackHeight ) ? stackHeight : newY;
			newX = (newX < 0 ) ? 0 : newX;
			newX = (newX > SCREEN_WIDTH - BALL_WIDTH) ? SCREEN_WIDTH - BALL_WIDTH : newX;
			[self setPosition:CGPointMake(newX, newY)];
		}
	}	
}

- (void)addParent:(Ball*) parent {
	if ([[self parents] count] == 2) {
		NSLog(@"[Warning] Trying to add parent to ball that already has 2 parents!");
		return;
	}
	[[self parents] addObject:parent];
}


- (void)addChild:(Ball*) child {
	if ([[self children] count] == 2) {
		NSLog(@"[Warning] Trying to add child to ball that already has 2 children!");
		return;
	}
	[[self children] addObject:child];
}

- (BOOL)hasChildren {
	return ( [children count] > 0 ) ? YES : NO;
}

- (BOOL)hasSiblings {
	return ( [siblings count] > 0 ) ? YES : NO;
}

- (void)addSibling:(Ball*) sibling {
	if ([[self siblings] count] == 2) {
		NSLog(@"[Warning] Trying to add sibling to ball that already has 2 siblings!");
		return;
	}
	[[self siblings] addObject:sibling];
}

- (CGPoint)centerPosition {
	return CGPointMake([self position].x + BALL_WIDTH/2, [self position].y + BALL_HEIGHT/2);
}

- (void)dud {
	isDud = YES;
	if ([self isSmall]) {
		[self setImage:[UIImage imageNamed:@"ball-black-small.png"]];
	} else {
		// Update Ball properties
		[self setImage:[UIImage imageNamed:@"ball-black.png"]];
	}
	[self setPowerup:nil];
	[self setColor:Black];
}

- (void)undud {
	Ball *temp;
	isDud = NO;
	if ([self isSmall]) {
		temp = [[BallFactory sharedSingleton] createSmallBall];	
	} else {
		temp = [[BallFactory sharedSingleton] createBall];
	}
	[self setImage:[temp image]];
	[self setPowerup:[temp powerup]];
	[self setColor:[temp color]];
}

//This method sets the ball's ballgrid cell pointer to nil,
//	removes the balls reference from all children/parents and siblings,
//	sets the ball active:NO and visible:NO
- (void)pop {
	NSLog(@"! POP !");
	BallStackViewController *bsvc = [BallStackViewController sharedSingleton];
	//Pop myself
	BallGrid *bg = [bsvc ballGrid];
	CGPoint center = [self centerPosition];
	CGPoint adjustedCenter = CGPointMake(center.x, center.y/* - [bsvc stackHeight]*/);
	int col = [bg calculateCol:adjustedCenter];
	int row = [bg calculateRow:adjustedCenter];
	
	//remove from ballgrid
	[[[[bg rows] objectAtIndex:row] objectAtIndex:col] setCellBall:nil];
	
	//play popping sound
	[[(BallStackView*)[bsvc view] popSound] play];

	[self setVisible:NO];
	[self setActive:NO];
	
	//Remove other balls references to this ball
	for (Ball *parent in [self parents]) {
		[parent removeChild:self];
	}
		
	for (Ball *sibling in [self siblings]) {
		[sibling removeSibling:self];
	}
	
	for (Ball *child in [self children]) {
		[child removeParent:self];
	}
	
	[children removeAllObjects];
	[parents removeAllObjects];
	[siblings removeAllObjects];

	
	// Adjust stack height
	[bsvc setStackMoveAmount:([bsvc stackMoveAmount] - (int)STACK_MOVE_AMOUNT_SHOT/2)];
	
	// Add powerup to queue (if one exists)
	if ( [self hasPowerup] ) [[(BallStackView *)[bsvc view] powerupQueue] enqueue:[self powerup]];
}


- (void)dealloc {
	[children release];
	[parents release];
	[siblings release];
	[super dealloc];
}

- (BOOL)removeChild:(Ball*)child {
	int r = [[self children] indexOfObjectIdenticalTo:child];
	if (r == NSNotFound) {
		NSLog(@"[warning] Tried to remove child that was not in children list!");
		return NO;
	}
	
	[[self children] removeObjectAtIndex:r];
	return YES;
}
		
- (BOOL)removeParent:(Ball*)parent {
	int r = [[self parents] indexOfObjectIdenticalTo:parent];
	if (r == NSNotFound) {
		NSLog(@"[warning] Tried to remove parent that was not in parents list!");
		return NO;
	}
	
	[[self parents] removeObjectAtIndex:r];
	return YES;
}


- (BOOL)removeSibling:(Ball*)sibling {
	int i = [[self siblings] indexOfObjectIdenticalTo:sibling];
	if (i == NSNotFound) {
		NSLog(@"[warning] Tried to remove sibling that was not in siblings list!"); 
		return NO;
	}
	
	[[self siblings] removeObjectAtIndex:i];
	return YES;
}


//Performs a breadth-first search on all the neighbors of a ball.
//If a ball is found that is  root then this ball is rooted as
//	well.
//This is primarly used to detemrine when to pop dangling balls with
//	no parents.
- (NSMutableArray*)isRooted {
	NSMutableArray *Q = [[NSMutableArray alloc] initWithCapacity:50];
	NSMutableArray *S = [[NSMutableArray alloc] initWithCapacity:50];
	[Q addObject:self];
	[S addObject:self];
	
	Ball *b;
	BOOL rooted = NO;
	while ([Q count] > 0) {
		b = [Q objectAtIndex:0];
		[Q removeObjectAtIndex:0];
		
		if ([b isRoot]) {
			rooted = YES;
		}
		else {
			for (Ball* parent in [b parents]) {
				if (![S containsObject:parent]) {
					[Q addObject:parent];
					[S addObject:parent];
				}
			}
			for (Ball* child in [b children]) {
				if (![S containsObject:child]) {
					[Q addObject:child];
					[S addObject:child];					
				}
			}
			for (Ball* sibling in [b siblings]) {
				if (![S containsObject:sibling]) {
					[Q addObject:sibling];
					[S addObject:sibling];
				}
			}
		}
	}
	
	[Q release];
	if (!rooted) {
		return S;
	}
	[S removeAllObjects];
	[S release];
	return nil;
}

- (void)draw {
	//NSLog(@"DRAW BALL");
	if ( [NSThread isMainThread] ) {
		[self drawBall];
	} else {
		[self performSelectorOnMainThread:@selector(drawBall) withObject:nil waitUntilDone:NO];		
	}
}

- (void)drawBall {
	[super draw];
	[self setFrame:CGRectMake(position.x, position.y, BALL_WIDTH, BALL_HEIGHT)];
}

@end
