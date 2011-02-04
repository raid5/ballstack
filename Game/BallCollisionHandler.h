//
//  BallCollisionHandler.h
//  BallStack
//
//  Created by Jason on 11/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>
#import "Ball.h"
#import "GELayer.h"
#import "GEGameObject.h"
#import "GECollisionHandler.h"
#import "BallStackViewController.h"

@interface BallCollisionHandler : GECollisionHandler {

}

-(void)handlePostCollisionEvents:(Ball*)actor;
- (void)rewind:(Ball*)b;

@end
