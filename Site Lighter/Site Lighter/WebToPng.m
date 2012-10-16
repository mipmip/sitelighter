//
//  WebToPng.m
//  Site Lighter
//
//  Created by Pim Snel on 07-05-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "WebToPng.h"

@implementation WebToPng

@synthesize myWebView, path, name, original, thumb, clipped, scale, width, height,updateImageView;

- (void)takeSnapshotOfURL:(NSURL *)url  
                   toPath:(NSString *)thePath   
                     name:(NSString *)theName
             viewToUpdate:(NSImageView *)myImageView

                 original:(BOOL)theOriginal   
                    thumb:(BOOL)theThumb   
                  clipped:(BOOL)theClipped   
                    scale:(float)theScale  
                    width:(float)theWidth   
                   height:(float)theHeight  
{  
    path = thePath;  
    name = theName;
    updateImageView = myImageView;
    original = theOriginal;  
    thumb = theThumb;  
    clipped = theClipped;  
    scale = theScale;  
    width = theWidth;
    height = theHeight;  
    
    [name retain];
    [path retain];
    
    NSRect rect = NSMakeRect(0,0,600,600);
    
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
    
    NSLog(@"name: %@",name);
    NSLog(@"path: %@",path);

    NSView *view = [[[myWebView mainFrame] frameView] documentView];
    
    // Resize  
    [[view window] setContentSize:[view bounds].size];  
    
    [view lockFocus];  
    NSBitmapImageRep *bitmapData = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[view bounds]];  
    [view unlockFocus];  
    
    if (original) {  
        [[bitmapData representationUsingType:NSPNGFileType properties:nil]  writeToFile:[NSString stringWithFormat:@"%@/%@-original.png", path, name] atomically:YES];
    }  
    
    // If neither thumb nor clipped are requested, we return  
    
    if (!(thumb || clipped))  
        return;  
    
    NSInteger aWidth = [bitmapData pixelsWide];
    NSInteger aHeight = [bitmapData pixelsHigh];  
    
    //float newscale = width/aWidth;
    //float thumbWidth = aWidth * scale;
    //float thumbHeight = aHeight * scale;
    float calcHeight = width / aWidth * aHeight;
    
    NSImage *scratch = [[NSImage alloc] initWithSize:NSMakeSize(width, calcHeight)];
    [scratch lockFocus];  
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];  
    
    NSRect thumbRect = NSMakeRect(0.0, 0.0, width, calcHeight);
    NSRect clipRect = NSMakeRect(0.0, height, width, height);  
    
    [bitmapData drawInRect:thumbRect];  
    NSBitmapImageRep *thumbOutput = [[NSBitmapImageRep alloc] initWithFocusedViewRect:thumbRect];  
    NSBitmapImageRep *clipOutput = [[NSBitmapImageRep alloc] initWithFocusedViewRect:clipRect];  
    
    [scratch unlockFocus];  
    
    // save thumb  
    if (thumb) {  
        [[thumbOutput representationUsingType:NSPNGFileType properties:nil]  
         writeToFile:[NSString stringWithFormat:@"%@/%@-thumb.png", path, name] atomically:YES];
        NSImage * newScreenshot =[[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@-thumb.png", path, name]];
        [updateImageView setImage:newScreenshot];
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
    
    
    if(aWidth<=width || aHeight <= height){
        NSLog(@": w%d h%d: destination size larger then original", aWidth,aHeight);
    }
    
    float tmpH = (float) aWidth / (float) aWidth * (float) aHeight;
    aHeight = (int) tmpH;
//    NSLog(@"new calculated height %d/%d =  %f:%d",_width, myImageWidth, tmpH, _height);
    
    
    
    //THE SCALING MAGIC
  //  CGImageRef outImage = [p3imglib resizeCGImage:myImage toWidth:_width andHeight:_height];
    
    //[p3imglib CGImageWriteToFile:outImage withPath:_out];
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
