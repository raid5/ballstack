//
//  NetworkManager.m
//  BallStack
//
//  Created by Adam McDonald on 11/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkProtocol.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

static void ballStackDataCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
	//NSLog(@"ballStackDataCallBack");
	
	NetworkManager *nm = (NetworkManager *)info;
	
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
@interface NetworkManager ()
- (void)initSocket;
- (void)destroySocket;
@end

@implementation NetworkManager

- (id)init {
	if (self = [super init]) {
		[self initSocket];
    }
    return self;
}

+ (NetworkManager *)sharedSingleton {
	static NetworkManager *sharedSingleton;
	
	if (!sharedSingleton)
		sharedSingleton = [[NetworkManager alloc] init];
	
	return sharedSingleton;
}

- (void)initSocket {
	CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};
	sock = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketDataCallBack, (CFSocketCallBack)&ballStackDataCallBack, &socketCtxt);
	
	int yes = 1;
    setsockopt( CFSocketGetNative(sock), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes) );
	
	struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
	addr4.sin_port = htons( SERVER_PORT );
	inet_pton(AF_INET, SERVER_IP, &addr4.sin_addr);
	
    NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
	
	CFSocketError cError = CFSocketConnectToAddress(sock, (CFDataRef)address4, (CFTimeInterval)SOCKET_TIMEOUT);
	if ( cError == kCFSocketSuccess ) {
		NSLog(@"Successfully connected to server.");
		NSData *addr = [(NSData *)CFSocketCopyAddress( sock ) autorelease];
		memcpy(&addr4, [addr bytes], [addr length]);
		NSLog(@"[port] %d", ntohs( addr4.sin_port ));	
		
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


- (void)sendMessage:(NSString *)msg {
	NSData *sendMe = [NSData dataWithBytes:[msg UTF8String] length:[msg length]];
	if ( sock ) {
		CFSocketError sError = CFSocketSendData(sock, NULL, (CFDataRef)sendMe, (CFTimeInterval)SOCKET_TIMEOUT);
		if ( sError == kCFSocketSuccess ) {
			NSLog(@"Message Sent.");	 
		} else {
			NSLog(@"Send Failed.");
		}
	}
}


- (void)delegateMessage:(NSString *)msg {
	//NSLog(@"delegateMessage => %@", msg);
	
	id appDelegate = [[UIApplication sharedApplication] delegate];
	UIViewController *controller = [[appDelegate navigationController] topViewController];
	if ( [controller respondsToSelector:@selector(parseServerMessage:)] ) {
		//NSLog(@"responds");
		
		//id<NetworkProtocol> np = (id<NetworkProtocol>)controller;
		UIViewController<NetworkProtocol> *np = (UIViewController<NetworkProtocol> *)controller;
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
