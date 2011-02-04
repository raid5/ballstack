//
//  GECollisionHandler.h
//  BallStack
//
//  Created by Jason on 11/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEGameObject.h"

@class GELayer;

@interface GECollisionHandler : NSObject {
	
@private 
	GEGameObject *gameObject;
	GELayer *layer;	
}

@property (nonatomic, retain) GEGameObject *gameObject;	
@property (nonatomic, retain) GELayer *layer;

- (id)initWithGELayer:(GELayer *)l;
- (BOOL)collide;
- (void)findAndReconcileCollisions;

@end
