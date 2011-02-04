//
//  GELayer.h
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//
#import <UIKit/UIKit.h>
#import "GEGameObject.h"

@interface GELayer : NSObject {

@private
	NSMutableArray *gameObjects;
	
}

@property (nonatomic, retain) NSMutableArray *gameObjects;

- (void)addGameObject:(GEGameObject *)obj;
- (void)removeGameObject:(GEGameObject *)obj;
- (void)removeAllGameObjects;

@end	