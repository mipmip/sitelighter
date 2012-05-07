//
//  WebToPng.h
//  Site Lighter
//
//  Created by Pim Snel on 07-05-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WebToPng : NSObject{
    
    WebView *myWebView;  
    NSString *path;  
    NSString *name;  
    BOOL original;  
    BOOL thumb;  
    BOOL clipped;  
    float scale;  
    float width;  
    float height;  
}  

@property (retain) WebView *myWebView;  
@property (retain) NSString *path;  
@property (retain) NSString *name;  
@property (assign) BOOL original;  
@property (assign) BOOL thumb;  
@property (assign) BOOL clipped;  
@property (assign) float scale;  
@property (assign) float width;  
@property (assign) float height;  

- (void)takeSnapshotOfURL:(NSURL*)url  
                   toPath:(NSString *)thePath   
                     name:(NSString *)theName  
                 original:(BOOL)theOriginal   
                    thumb:(BOOL)theThumb   
                  clipped:(BOOL)theClipped   
                    scale:(float)theScale  
                    width:(float)theWidth   
                   height:(float)theHeight;  


@end
