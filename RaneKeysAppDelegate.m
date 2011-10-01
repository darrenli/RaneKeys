//
//  RaneKeysAppDelegate.m
//  RaneKeys
//
//  Created by Darren Cheng on 9/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RaneKeysAppDelegate.h"

@implementation RaneKeysAppDelegate

//@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
  
  DDHotKeyCenter *hotKeyCenter = [[DDHotKeyCenter alloc] init];
  if(![hotKeyCenter registerHotKeyWithKeyCode:0
                                modifierFlags:(NSShiftKeyMask | NSAlternateKeyMask | NSCommandKeyMask)
                                       target:self
                                       action:@selector(hotkeyWithEvent:object:)
                                       object:@"Show Info"]) {
    NSLog(@"failed to register hotkey.");
  }
  else {
    NSLog(@"registered hotkey - show info");       
  }
  
  if(![hotKeyCenter registerHotKeyWithKeyCode:49
                                modifierFlags:NSControlKeyMask
                                       target:self
                                       action:@selector(hotkeyWithEvent:object:)
                                       object:@"Play Pause"]) {
    NSLog(@"failed to register hotkey.");
  }
  else {
    NSLog(@"registered hotkey - play pause");       
  }
  
  //
  if(![hotKeyCenter registerHotKeyWithKeyCode:123
                                modifierFlags:(NSAlternateKeyMask | NSCommandKeyMask)
                                       target:self
                                       action:@selector(hotkeyWithEvent:object:)
                                       object:@"Back"]) {
    NSLog(@"failed to register hotkey.");
  }
  else {
    NSLog(@"registered hotkey - back");       
  }
  
  if(![hotKeyCenter registerHotKeyWithKeyCode:124
                                modifierFlags:(NSAlternateKeyMask | NSCommandKeyMask)
                                       target:self
                                       action:@selector(hotkeyWithEvent:object:)
                                       object:@"Forward"]) {
    NSLog(@"failed to register hotkey.");
  }
  else {
    NSLog(@"registered hotkey - forward");       
  }
  
  //Volume Up
  if(![hotKeyCenter registerHotKeyWithKeyCode:126
                                modifierFlags:(NSAlternateKeyMask | NSCommandKeyMask)
                                       target:self
                                       action:@selector(hotkeyWithEvent:object:)
                                       object:@"Volume Up"]) {
    NSLog(@"failed to register hotkey.");
  }
  else {
    NSLog(@"registered hotkey - forward");       
  }
  
  //Volume Down
  if(![hotKeyCenter registerHotKeyWithKeyCode:125
                                modifierFlags:(NSAlternateKeyMask | NSCommandKeyMask)
                                       target:self
                                       action:@selector(hotkeyWithEvent:object:)
                                       object:@"Volume Down"]) {
    NSLog(@"failed to register hotkey.");
  }
  else {
    NSLog(@"registered hotkey - forward");       
  }
  
  
  
  [hotKeyCenter release];
  
  spotifyApp = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
  
  [GrowlApplicationBridge setGrowlDelegate:@""];
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent object:(id)anObject {
//  NSLog(@"hotkey win!!");
//  NSLog(@"%@",[[spotifyApp currentTrack] name]);
//  NSLog(@"%@",[[spotifyApp currentTrack] artist]);
//  NSLog(@"%@",[[spotifyApp currentTrack] artwork]);
//  //NSLog(@"Event: %@", hkEvent);
//  
//  /*
//  NSLog(@"%d",[spotifyApp playerState]);
//  if([spotifyApp playerState] == SpotifyEPlSStopped)
//    NSLog(@"stopped");
//  else if([spotifyApp playerState] == SpotifyEPlSPaused)
//    NSLog(@"paused");
//  else if([spotifyApp playerState] == SpotifyEPlSPlaying)
//    NSLog(@"playing");
//  */
  
  BOOL isPlaying = ([spotifyApp playerState] == SpotifyEPlSPlaying);
  BOOL isVolumeUp = [(NSString*)anObject isEqualToString:@"Volume Up"];
  BOOL isVolumeDown = [(NSString*)anObject isEqualToString:@"Volume Down"];
  BOOL isPlayCommand = [(NSString*)anObject isEqualToString:@"Play Pause"];
  BOOL isForwardCommand = [(NSString*)anObject isEqualToString:@"Forward"];
  BOOL isBackCommand = [(NSString*)anObject isEqualToString:@"Back"];
  BOOL isGrowlRunning = [GrowlApplicationBridge isGrowlRunning];
  BOOL isSpotifyRunning = [spotifyApp isRunning];
  
  if(isGrowlRunning && isSpotifyRunning) {    
    
    //Play or Pause
    if(isPlayCommand) {
      [spotifyApp playpause];
    }
    
    //Next Song
    else if(isForwardCommand) {
      [spotifyApp nextTrack];
      if(!isPlaying)
        [spotifyApp playpause];
    }
    
    //Previous Song
    else if(isBackCommand) {
      NSLog(@"Back");
      [spotifyApp previousTrack];
      if(!isPlaying)
        [spotifyApp playpause];
    }
    
    //Volume Control
    if(isVolumeDown || isVolumeUp) {
      NSInteger volume = [spotifyApp soundVolume];
      if(isVolumeDown)
        volume -= VOLUME_INC;
      else
        volume += VOLUME_INC;
      if(volume > 100)
        volume = 100;
      if(volume < 0)
        volume = 0;
      spotifyApp.soundVolume = volume;
    }
    
    
    if(isPlaying && !(isVolumeUp || isVolumeDown)) {
      [GrowlApplicationBridge notifyWithTitle:[[spotifyApp currentTrack] name]
                                  description:[[spotifyApp currentTrack] artist]
                             notificationName:@"Song Info"
                                     iconData:[[[spotifyApp currentTrack] artwork] TIFFRepresentation]
                                     priority:0
                                     isSticky:NO
                                 clickContext:nil];
    }
  }
  else {
    NSLog(@"Growl is not running");
  }
}

-(void)dealloc {
  NSLog(@"dealloc");
  DDHotKeyCenter *hotKeyCenter = [[DDHotKeyCenter alloc] init];
  [hotKeyCenter unregisterHotKeyWithKeyCode:0 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)];
  [hotKeyCenter release];
  [super dealloc];
}

-(void)growlAlert:(NSString *)message title:(NSString *)title {
  NSLog(@"%@ %@", message, title);
}

@end
