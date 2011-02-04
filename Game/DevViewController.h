//
//  DevViewController.h
//  BallStack
//
//  Created by Adam McDonald on 11/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEViewController.h"
#import "GENetworkProtocol.h"

@interface DevViewController : GEViewController <UITextFieldDelegate> {

@private
	UITextField *msgField;
	
}

@property (nonatomic, retain) IBOutlet UITextField *msgField;

- (IBAction)send:(id)sender;
- (IBAction)startTestGame:(id)sender;

@end
