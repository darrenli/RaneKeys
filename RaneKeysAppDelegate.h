//
//  RaneKeysAppDelegate.h
//  RaneKeys
//
//  Created by Darren Cheng on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DDHotKeyCenter.h"
#import "Spotify.h"
#import <Growl-WithInstaller/GrowlApplicationBridge.h>

#define VOLUME_INC 8


@interface RaneKeysAppDelegate : NSObject <NSApplicationDelegate, GrowlApplicationBridgeDelegate> {
//  NSWindow *window;
  SpotifyApplication *spotifyApp;
}

-(void) growlAlert:(NSString *)message title:(NSString *)title;
//@property (assign) IBOutlet NSWindow *window;

@end
