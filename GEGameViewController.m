//
//  GEGameViewController.m
//  BallStack
//
//  Created by Adam McDonald on 12/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
//  Base class for View Controllers that manage the game view (gameplay).
//    Network communication from a server is supported through the GENetworkProtocol.

#import "GEGameViewController.h"
#import "GELayer.h"
#import "GEGameObject.h"
#import "GECollisionHandler.h"
#import "BallCollisionHandler.h"

#define FPS 60.0
#define INITIAL_LAYERS 3
#define INITIAL_HANDLERS 3
#define ITEMS_TO_REMOVE 10

// A class extension to declare private methods
@interface GEGameViewController ()

@property (nonatomic, assign) NSTimer *animationTimer;

- (void)threadedGameLoop;
- (void)doGameLoop;
- (void)redisplayView;

@end

@implementation GEGameViewController

@synthesize layers, collisionHandlers, removeList, active, animationTimer;

- (id)init {
    if (self = [super init]) {
        // Initialization code
		active = NO;
		layers = [[NSMutableArray alloc] initWithCapacity:INITIAL_LAYERS];
		collisionHandlers = [[NSMutableArray alloc] initWithCapacity:INITIAL_HANDLERS];
		removeList = [[NSMutableArray alloc] initWithCapacity:ITEMS_TO_REMOVE];
		
    }
    return self;
}

- (void)loadView {
	[super loadView];
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
	[layers release];
	[collisionHandlers release];
	[removeList release];
    [super dealloc];
}

- (void)update {
	if ( active ) {
		// Iterate layers
		for (GELayer *layer in layers) {
			
			// Iterate contents of layers
			NSMutableArray *contents = [layer gameObjects];
			for (GEGameObject *go in contents) {
				if ( [go active] ) {
					[go update];
				} else {
					[removeList addObject:go];
				}
			}
			
			// Remove inactive objects in current layer
			for ( GEGameObject *go in removeList ) {
				[[layer gameObjects] removeObject:go];
			}
		}
		
	}
}

- (void)startGameLoop {
	NSLog(@"GEGameViewController startGameLoop");
	
	active = YES;
	
	[NSThread detachNewThreadSelector:@selector(doGameLoop) toTarget:self withObject:nil];
	
//	NSTimeInterval animationInterval = 1.0 / FPS;
//	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval
//														   target:self
//														 selector:@selector(threadedGameLoop)
//														 userInfo:nil
//														  repeats:YES];
//	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval
//														   target:self
//														 selector:@selector(doGameLoop)
//														 userInfo:nil
//														  repeats:YES];
}

- (void)threadedGameLoop {
	[NSThread detachNewThreadSelector:@selector(doGameLoop) toTarget:self withObject:nil];
}

- (void)doGameLoop {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSDate *date = nil;
	while ( YES ) {
		//NSLog(@"GEGameViewController doGameLoop");
		
		// Update state of active objects
		[self update];
		
		for ( GECollisionHandler *handler in collisionHandlers ) {
			[(BallCollisionHandler *)handler findAndReconcileCollisions];
		}

		[self performSelectorOnMainThread:@selector(redisplayView) withObject:nil waitUntilDone:YES]; // wait for redisplay
		//[self.view setNeedsDisplay];
		
		if ( date != nil ) [date release];
		NSTimeInterval animationInterval = 1.0 / FPS;
		date = [NSDate dateWithTimeIntervalSinceNow:animationInterval];
		[NSThread sleepUntilDate:date];
	}
	
	[pool release];
}

- (void)redisplayView {
	[self.view setNeedsDisplay];	
}

- (void)stopGameLoop {
	active = NO;
	[self.animationTimer invalidate];
    self.animationTimer = nil;
}

- (void)addLayer:(GELayer *)layer {
	[layers addObject:layer];
}

- (void)registerCollisionHandler:(GECollisionHandler *)handler {
	[collisionHandlers addObject:handler];
}

//- - - Networking - - -
// Required to conform to GENetworkProtocol
- (void)parseServerMessage:(NSString *)msg {

}

@end
