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
  
  //Play or Pause
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
  
  //Turn on Spotify
  if(![hotKeyCenter registerHotKeyWithKeyCode:37
                                modifierFlags:(NSShiftKeyMask | NSAlternateKeyMask | NSCommandKeyMask)
                                       target:self
                                       action:@selector(hotkeyWithEvent:object:)
                                       object:@"Turn On"]) {
    NSLog(@"failed to register hotkey.");
  }
  else {
    NSLog(@"registered hotkey - turn on");       
  }
  
  
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
  NSLog(@"%@ Hotkey Pressed",(NSString*)anObject);
  
  BOOL isPlaying = ([spotifyApp playerState] == SpotifyEPlSPlaying);
  BOOL isTurnOn = [(NSString*)anObject isEqualToString:@"Turn On"];
  BOOL isVolumeUp = [(NSString*)anObject isEqualToString:@"Volume Up"];
  BOOL isVolumeDown = [(NSString*)anObject isEqualToString:@"Volume Down"];
  BOOL isPlayCommand = [(NSString*)anObject isEqualToString:@"Play Pause"];
  BOOL isForwardCommand = [(NSString*)anObject isEqualToString:@"Forward"];
  BOOL isBackCommand = [(NSString*)anObject isEqualToString:@"Back"];
  BOOL isGrowlRunning = [GrowlApplicationBridge isGrowlRunning];
  BOOL isSpotifyRunning = [spotifyApp isRunning];
  
  if(!isSpotifyRunning && isTurnOn) {
    [spotifyApp playpause];
  }
  
  
  if(isSpotifyRunning) {
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
    
    if(isGrowlRunning) {
      if(!(isVolumeUp || isVolumeDown)) {
        NSInteger trackDuration = [[spotifyApp currentTrack] duration];
        NSInteger currentPosition = (NSInteger)[spotifyApp playerPosition];
        
        NSInteger trackDurationMinutes = trackDuration / 60;
        NSInteger trackDurationSeconds = trackDuration % 60;
        NSInteger currentPositionMinutes = currentPosition / 60;
        NSInteger currentPositionSeconds = currentPosition % 60;
        
        NSString *timeStamp = [NSString stringWithFormat:@"%d:%02d of %d:%02d",currentPositionMinutes,currentPositionSeconds,trackDurationMinutes,trackDurationSeconds];
        

        
        NSString *spotifySongInfo = [NSString stringWithString:[[spotifyApp currentTrack] name]];
        NSInteger oldLength = [spotifySongInfo length];
        NSRange stringRange = {0, MIN([spotifySongInfo length], 30)};
        stringRange = [spotifySongInfo rangeOfComposedCharacterSequencesForRange:stringRange];
        spotifySongInfo = [spotifySongInfo substringWithRange:stringRange];
        if(oldLength > [spotifySongInfo length])
          spotifySongInfo = [spotifySongInfo stringByAppendingString:@"..."];

        NSString *spotifyStringDescription = [NSString stringWithFormat:@"%@",[[spotifyApp currentTrack] artist]];
        oldLength = [spotifyStringDescription length];
        NSRange stringRangeDesc = {0, MIN([spotifyStringDescription length], 30)};
        stringRangeDesc = [spotifyStringDescription rangeOfComposedCharacterSequencesForRange:stringRangeDesc];
        spotifyStringDescription = [spotifyStringDescription substringWithRange:stringRangeDesc];
        if(oldLength > [spotifyStringDescription length])
          spotifyStringDescription = [spotifyStringDescription stringByAppendingFormat:@"..."];

        NSString *theInfo = timeStamp;
        if([spotifyApp playerState] == SpotifyEPlSPaused)
          theInfo = [theInfo stringByAppendingString:@" (Paused)"];
        else if([spotifyApp playerState] == SpotifyEPlSStopped)
          theInfo = [theInfo stringByAppendingString:@" (Stopped)"];
        
        [GrowlApplicationBridge notifyWithTitle:[NSString stringWithFormat:@"%@\n%@",spotifySongInfo,spotifyStringDescription]
                                    description:theInfo
                               notificationName:@"Song Info"
                                       iconData:[[[spotifyApp currentTrack] artwork] TIFFRepresentation]
                                       priority:0
                                       isSticky:NO
                                   clickContext:nil];
      }
      else if(isVolumeUp || isVolumeDown) {
        NSString *volumeDescription = [NSString stringWithFormat:@"%d%% Volume", [spotifyApp soundVolume]];
        if(isVolumeUp)
          [GrowlApplicationBridge notifyWithTitle:@"Increased Volume"
                                      description:volumeDescription
                                 notificationName:@"Volume Control"
                                         iconData:nil
                                         priority:0
                                         isSticky:NO
                                     clickContext:nil];
        else if(isVolumeDown)
          [GrowlApplicationBridge notifyWithTitle:@"Decreased Volume"
                                      description:volumeDescription
                                 notificationName:@"Volume Control"
                                         iconData:nil
                                         priority:0
                                         isSticky:NO
                                     clickContext:nil];
      }
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
