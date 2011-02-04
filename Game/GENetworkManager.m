//
//  GENetworkManager.m
//  BallStack
//
//  Created by Adam McDonald on 11/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
//  TCP/IP socket based network manager.
//  1. Sending Messages
//     - Sends a specified string over the socket connection.
//  2. Receiving Messages
//     - Delegates the message data received to the currently active (top) view controller.

#import "GENetworkManager.h"
#import "GENetworkProtocol.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define SOCKET_TIMEOUT 10

static void socketDataCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
	GENetworkManager *nm = (GENetworkManager *)info;
	
	if ( type == kCFSocketDataCallBack ) {
		if ( CFDataGetLength(data) <= 0 ) {
			NSLog(@"Invalid data received.");
			return;
		}
		
		NSString *msg = [NSString stringWithFormat:@"%s", CFDataGetBytePtr(data)];
		if ( msg ) {
			[nm delegateMessage:msg];
		} else {
			NSLog(@"Could not convert data to string");
		}
	} else {
		NSLog(@"Unknown callback type.");
	}
}

// A class extension to declare private methods
@interface GENetworkManager ()
- (void)destroySocket;
@end

@implementation GENetworkManager

- (id)init {
	if (self = [super init]) {
		// Setup
    }
    return self;
}

+ (GENetworkManager *)sharedSingleton {
	static GENetworkManager *sharedSingleton;
	
	if ( !sharedSingleton ) sharedSingleton = [[GENetworkManager alloc] init];
	
	return sharedSingleton;
}

- (void)initSocketWithIP:(NSString *)anIPAddress onPort:(int)aPort {
	CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};
	sock = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketDataCallBack, (CFSocketCallBack)&socketDataCallBack, &socketCtxt);
	
	int yes = 1;
    setsockopt( CFSocketGetNative(sock), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes) );
	
	struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
	addr4.sin_port = htons( aPort );
	inet_pton(AF_INET, [anIPAddress UTF8String] , &addr4.sin_addr);
	
    NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
	
	CFSocketError cError = CFSocketConnectToAddress(sock, (CFDataRef)address4, (CFTimeInterval)SOCKET_TIMEOUT);
	if ( cError == kCFSocketSuccess ) {
		NSData *addr = [(NSData *)CFSocketCopyAddress( sock ) autorelease];
		memcpy(&addr4, [addr bytes], [addr length]);
		NSLog(@"Successfully connected to server. [port] %d", ntohs( addr4.sin_port ));	
		
		// Set up the run loop sources for the sockets
		CFRunLoopRef cfrl = CFRunLoopGetCurrent();
		CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, sock, 0);
		CFRunLoopAddSource(cfrl, source4, kCFRunLoopCommonModes);
		CFRelease( source4 );
	} else {
		NSLog(@"Error connecting to server.");
		[self destroySocket];
	}
}

- (void)destroySocket {
	if ( sock ) CFRelease( sock );
	sock = NULL;
}

- (BOOL)sendMessage:(NSString *)msg {
	NSData *sendMe = [NSData dataWithBytes:[msg UTF8String] length:[msg length]];
	BOOL status = NO;
	if ( sock ) {
		CFSocketError sError = CFSocketSendData(sock, NULL, (CFDataRef)sendMe, (CFTimeInterval)SOCKET_TIMEOUT);
		if ( sError == kCFSocketSuccess ) {
			//NSLog(@"Message Sent.");
			status = YES;
		} else {
			NSLog(@"Send Failed.");
		}
	}
	return status;
}

- (void)delegateMessage:(NSString *)msg {
	id appDelegate = [[UIApplication sharedApplication] delegate];
	UIViewController *controller = [[appDelegate navigationController] topViewController];
	if ( [controller respondsToSelector:@selector(parseServerMessage:)] ) {
		UIViewController<GENetworkProtocol> *np = (UIViewController<GENetworkProtocol> *)controller;
		[np parseServerMessage:msg];
	} else {
		NSLog(@"does not respond");
	}
}

- (void)dealloc {
	[self destroySocket];
    [super dealloc];
}

@end
