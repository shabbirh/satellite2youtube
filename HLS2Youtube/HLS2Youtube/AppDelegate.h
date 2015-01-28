//
//  AppDelegate.h
//  HLS2Youtube
//
//  Created by Shabbir Hassanally on 28/01/2015.
//  Copyright (c) 2015 Shabbir Hassanally. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *localHLSFeed;
@property (weak) IBOutlet NSTextField *youtubeRTMPServerURL;
@property (weak) IBOutlet NSTextField *youtubeRTMPStreamName;

@property (weak) IBOutlet NSButton *createYoutubeLIveEventButton;
@property (weak) IBOutlet NSButton *startStreamingYoutubeLiveEventButton;

- (IBAction)clickedCreateYoutubeLiveEvent:(id)sender;
- (IBAction)startStreamingYoutubeLiveEvent:(id)sender;


@end

