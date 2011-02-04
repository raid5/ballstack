/*
 *  GENetworkProtocol.h
 *  BallStack
 *
 *  Created by Adam McDonald on 11/26/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 *  Protocol adopted by View Controllers that would like to receive
 *    messages from the server.
 */

@protocol GENetworkProtocol

- (void)parseServerMessage:(NSString *)msg;

@end