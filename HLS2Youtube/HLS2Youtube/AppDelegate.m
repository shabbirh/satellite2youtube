//
//  AppDelegate.m
//  HLS2Youtube
//
//  Created by Shabbir Hassanally on 28/01/2015.
//  Copyright (c) 2015 Shabbir Hassanally. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textDidChange:) name:NSControlTextDidChangeNotification object:self.localHLSFeed];
    [center addObserver:self selector:@selector(textDidChange:) name:NSControlTextDidChangeNotification object:self.youtubeRTMPStreamName];
    [center addObserver:self selector:@selector(textDidChange:) name:NSControlTextDidChangeNotification object:self.youtubeRTMPServerURL];

    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)textDidChange:(NSNotification *)aNotification
{
    if (([[self.localHLSFeed stringValue]length]>0) && ([[self.youtubeRTMPServerURL stringValue]length]>0) && ([[self.youtubeRTMPStreamName stringValue]length]>0) ){
        [self.startStreamingYoutubeLiveEventButton setEnabled: YES];
    }
    else {
        [self.startStreamingYoutubeLiveEventButton setEnabled: NO];
    }
}



- (IBAction)clickedCreateYoutubeLiveEvent:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.youtube.com/my_live_events"]];
}

- (IBAction)startStreamingYoutubeLiveEvent:(id)sender
{
    
    // ffmpeg -i http://192.168.14.105/stream/PressTVHD -vcodec libx264 -preset medium -bufsize 6000k -vf "scale=1280:-1, format=yuv420p" -g 50 -acodec libmp3lame -b:a 128k -ac 2 -ar 44100 -f flv rtmp://a.rtmp.youtube.com/live2/shabbir.hassanally.z6m3-ksem-wka9-1476
    
    
    // check for nils
    
    NSString *hlsFeed = [self.localHLSFeed stringValue];
    NSString *youtubeUrl = [NSString stringWithFormat:@"%@/%@", [self.youtubeRTMPServerURL stringValue], [self.youtubeRTMPStreamName stringValue]];
    
    NSString *clumsyCommand = @"scale=1280:-1,format=yuv420p";
    
    int pid = [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/local/bin/ffmpeg";
    task.arguments = @[@"-i", hlsFeed,
                       @"-vcodec", @"copy",
                       @"-g", @"50",
                       @"-bsf:a", @"aac_adtstoasc",
                       @"-bufsize", @"6000k",
                       @"-acodec", @"copy",
                       @"-ac", @"2",
                       @"-ar", @"44100",
                       @"-f", @"flv",
                       youtubeUrl];
    task.standardOutput = pipe;
    
    [task launch];
    
    [task waitUntilExit];
    
    /*NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSString *grepOutput = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"grep returned:\n%@", grepOutput);*/
    
    NSLog(@"hlsfeed == %@", hlsFeed);
    NSLog(@"youtbe URL == %@", youtubeUrl);
    
    
}
@end
