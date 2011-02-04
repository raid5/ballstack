//
//  GESingleViewGame.m
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
//  Class for games that only need to manage a single game view.

#import "GESingleViewGame.h"
#import "GEGameViewController.h"

@implementation GESingleViewGame

@synthesize gameViewController;

- (id)initWithFrame:(CGRect)frame managedByGameViewController:(GEGameViewController *)aController {
    if (self = [super initWithFrame:frame]) {
		// Setup
		self.gameViewController = aController;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	// Iterate layers
	NSMutableArray *layers = [gameViewController layers];
	for (id layer in layers) {
		// Iterate contents of layers
		NSMutableArray *contents = [(GELayer *)layer gameObjects];
		for (GEGameObject *gObj in contents) {
			if ( [gObj visible] ) [gObj draw];
		}
	}
}

- (void)dealloc {
    [super dealloc];
}

@end
