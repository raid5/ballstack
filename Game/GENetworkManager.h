//
//  GENetworkManager.h
//  BallStack
//
//  Created by Adam McDonald on 11/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GENetworkManager : NSObject {

@private
	CFSocketRef sock;
	
}

+ (GENetworkManager *)sharedSingleton;
- (void)initSocketWithIP:(NSString *)anIPAddress onPort:(int)aPort;
- (BOOL)sendMessage:(NSString *)msg;
- (void)delegateMessage:(NSString *)msg;

@end
