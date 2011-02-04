//
//  GEGameViewController.h
//  BallStack
//
//  Created by Adam McDonald on 12/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GENetworkProtocol.h"

@class GELayer, GECollisionHandler;

@interface GEGameViewController : UIViewController <GENetworkProtocol> {

@private
	NSTimer *animationTimer;
	NSMutableArray *layers;
	NSMutableArray *collisionHandlers;
	NSMutableArray *removeList;			// List of items to be removed from the layer
	BOOL active;

}

@property (nonatomic, retain) NSMutableArray *layers;
@property (nonatomic, retain) NSMutableArray *collisionHandlers;
@property (nonatomic, retain) NSMutableArray *removeList;
@property (nonatomic, assign) BOOL active;

- (void)startGameLoop;
- (void)stopGameLoop;
- (void)addLayer:(GELayer *)layer;
- (void)registerCollisionHandler:(GECollisionHandler *)handler;
- (void)parseServerMessage:(NSString *)msg;
- (void)update;

@end
