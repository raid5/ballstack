//
//  PowerupQueue.m
//  BallStack
//
//  Created by Peter Beck on 12/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PowerupQueue.h"
#import "PowerupView.h"
#import "PowerupFactory.h"

#define PU_WIDTH 20.0
#define PU_HEIGHT 20.0
#define PU_PADDING 5.0

@implementation PowerupQueue

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		queue = [[NSMutableArray alloc] initWithCapacity:INITIAL_QUEUE_SIZE];
    }
    return self;
}

- (void)dealloc {
	[queue release];
    [super dealloc];
}

- (void)enqueue:(Powerup*)powerup {
	if (powerup == nil) {
		NSLog(@"[Error] Trying to enqueue nil in powerupQueue\n");
		return;
	}
	
	[powerup retain];
	
	// Add to queue
	[queue addObject:powerup];
	//[powerup release];
	
	// Refresh queue view
	[self refresh];
}

- (Powerup*)dequeue {
	if ([queue count] == 0) {
		NSLog(@"[Error] Trying to dequeue from powerupQueue when size is 0.\n");
		return nil;
	}

	Powerup *p = [queue objectAtIndex:0];
	[queue removeObject:p];
	
	//[p release];
	
	// Refresh queue view
	[self refresh];
	
	return p;
}

- (void)clear {
	[queue removeAllObjects];
}

- (BOOL)available {
	return ( [queue count] > 0 ) ? YES : NO;
}

- (void)refresh {	
	// Clear powerups
	for ( UIView *view in [self subviews] ) {
		[view removeFromSuperview];
	}
	
	// Load powerups
	int pCount = [queue count];
	for ( int i = 0; i < pCount; i++ ) {
		Powerup *p = (Powerup *)[queue objectAtIndex:i];
		
		int xOffset = (i * (PU_WIDTH + PU_PADDING)) + PU_PADDING;
		PowerupView *pView = [[PowerupView alloc] initWithFrame:CGRectMake(xOffset, PU_PADDING, PU_WIDTH, PU_HEIGHT) withPowerupType:[p pType]];
		//[pView setBackgroundColor:[UIColor yellowColor]];
		[self addSubview:pView];
		
		
		// Assign view for powerup
		[p setPView:pView];
	}
}

@end
