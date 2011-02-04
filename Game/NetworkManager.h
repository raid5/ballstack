//
//  NetworkManager.h
//  BallStack
//
//  Created by Adam McDonald on 11/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkConstants.h"

@interface NetworkManager : NSObject {

@private
	CFSocketRef sock;
	
}

+ (NetworkManager *)sharedSingleton;
- (void)sendMessage:(NSString *)msg;
- (void)delegateMessage:(NSString *)msg;

@end
