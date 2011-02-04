//
//  GESingleViewGame.h
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GELayer.h"

@class GEGameViewController;

@interface GESingleViewGame : UIView {

	GEGameViewController *gameViewController;
	
}

@property (nonatomic, retain) GEGameViewController *gameViewController;

- (id)initWithFrame:(CGRect)frame managedByGameViewController:(GEGameViewController *)aController;

@end
