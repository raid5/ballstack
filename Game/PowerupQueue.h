//
//  PowerupQueue.h
//  BallStack
//
//  Created by Peter Beck on 12/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Powerup.h"

#define INITIAL_QUEUE_SIZE 6

@interface PowerupQueue : UIView {

@private
	NSMutableArray *queue;
	
}

- (void)enqueue:(Powerup*)powerup;
- (Powerup*)dequeue;
- (void)clear;
- (BOOL)available;
- (void)refresh;

@end
