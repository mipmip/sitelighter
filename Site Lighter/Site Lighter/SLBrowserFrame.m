//
//  SLBrowserFrame.m
//  Site Lighter
//
//  Created by Pim Snel on 28-09-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "SLBrowserFrame.h"

@implementation SLBrowserFrame

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
}

@end
