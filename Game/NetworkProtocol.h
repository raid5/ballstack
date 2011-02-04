/*
 *  NetworkProtocol.h
 *  BallStack
 *
 *  Created by Adam McDonald on 11/26/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

@protocol NetworkProtocol

- (void)parseServerMessage:(NSString *)msg;

@end