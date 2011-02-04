//
//  GEViewController.m
//  BallStack
//
//  Created by Adam McDonald on 12/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
//  Base class for View Controllers that manage non-gameplay related views.
//    Network communication from a server is supported through the GENetworkProtocol.

#import "GEViewController.h"

@implementation GEViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

//- - - Networking - - -
// Required to conform to GENetworkProtocol
- (void)parseServerMessage:(NSString *)msg {
	
}

@end
