//
//  GEViewController.h
//  BallStack
//
//  Created by Adam McDonald on 12/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GENetworkProtocol.h"

@interface GEViewController : UIViewController <GENetworkProtocol> {

}

- (void)parseServerMessage:(NSString *)msg;

@end
