//
//  PlayerView.h
//  BallStack
//
//  Created by Adam McDonald on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerView : UIImageView {

@private
	int playerId;
	int displayId;
	UIView *statusView;
	
}

@property (nonatomic, assign) int playerId;
@property (nonatomic, assign) int displayId;
@property (nonatomic, retain) UIView *statusView;

- (id)initWithFrame:(CGRect)frame withPlayerId:(int)pId withDisplayId:(int)dId;
- (void)updateStatusView:(int)status;

@end
