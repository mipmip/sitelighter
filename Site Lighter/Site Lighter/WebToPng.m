//
//  WebToPng.m
//  Site Lighter
//
//  Created by Pim Snel on 07-05-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "WebToPng.h"

@implementation WebToPng

@synthesize myWebView, path, name, original, thumb, clipped, scale, width, height;  

- (void)takeSnapshotOfURL:(NSURL *)url  
                   toPath:(NSString *)thePath   
                     name:(NSString *)theName  
                 original:(BOOL)theOriginal   
                    thumb:(BOOL)theThumb   
                  clipped:(BOOL)theClipped   
                    scale:(float)theScale  
                    width:(float)theWidth   
                   height:(float)theHeight  
{  
    path = thePath;  
    name = theName;  
    original = theOriginal;  
    thumb = theThumb;  
    clipped = theClipped;  
    scale = theScale;  
    width = theWidth;  
    height = theHeight;  
    
    NSRect rect = NSMakeRect(0,0,100,100);  
    
    NSWindow *window = [[NSWindow alloc]  
                        initWithContentRect:rect  
                        styleMask:NSBorderlessWindowMask   
                        backing:NSBackingStoreBuffered   
                        defer:NO];  
    
    myWebView = [[WebView alloc] initWithFrame:rect];  
    
    [window setContentView:myWebView];  
    
    [myWebView setFrameLoadDelegate:self];  
    
    [[myWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];  
}  


// Delegate Methods  

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {  
    
    NSView *view = [[[myWebView mainFrame] frameView] documentView];  
    
    // Resize  
    [[view window] setContentSize:[view bounds].size];  
    
    [view lockFocus];  
    NSBitmapImageRep *bitmapData = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[view bounds]];  
    [view unlockFocus];  
    
    if (original) {  
        [[bitmapData representationUsingType:NSPNGFileType properties:nil]  
         writeToFile:[NSString stringWithFormat:@"%@/%@-original.png", path, name] atomically:YES];  
    }  
    
    // If neither thumb nor clipped are requested, we return  
    
    if (!(thumb || clipped))  
        return;  
    
    NSInteger aWidth = [bitmapData pixelsWide];  
    NSInteger aHeight = [bitmapData pixelsHigh];  
    
    float thumbWidth = aWidth * scale;  
    float thumbHeight = aHeight * scale;  
    
    NSImage *scratch = [[NSImage alloc] initWithSize:NSMakeSize(thumbWidth, thumbHeight)];  
    [scratch lockFocus];  
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];  
    
    NSRect thumbRect = NSMakeRect(0.0, 0.0, thumbWidth, thumbHeight);  
    NSRect clipRect = NSMakeRect(0.0, height, width, height);  
    
    [bitmapData drawInRect:thumbRect];  
    NSBitmapImageRep *thumbOutput = [[NSBitmapImageRep alloc] initWithFocusedViewRect:thumbRect];  
    NSBitmapImageRep *clipOutput = [[NSBitmapImageRep alloc] initWithFocusedViewRect:clipRect];  
    
    [scratch unlockFocus];  
    
    // save thumb  
    if (thumb) {  
        [[thumbOutput representationUsingType:NSPNGFileType properties:nil]  
         writeToFile:[NSString stringWithFormat:@"%@/%@-thumb.png", path, name] atomically:YES];  
    }  
    
    // save clipped  
    if (clipped) {  
        [[clipOutput representationUsingType:NSPNGFileType properties:nil]  
         writeToFile:[NSString stringWithFormat:@"%@/%@-clipped.png", path, name] atomically:YES];  
    }  
    
    [scratch release];  
    [bitmapData release];  
    [thumbOutput release];  
    [clipOutput release];  
}  

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {  
    NSLog(@"Error: %@", [error localizedDescription]);  
}  

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {  
    NSLog(@"Error: %@", [error localizedDescription]);  
}  

- (void)dealloc {  
    [myWebView release];  
    [path release];  
    [name release];  
    [super dealloc];  
}  

@end
