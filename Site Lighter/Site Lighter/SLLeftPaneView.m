//
//  SLLeftPaneView.m
//  Site Lighter
//
//  Created by Pim Snel on 28-09-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "SLLeftPaneView.h"

@implementation SLLeftPaneView

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
    [super drawRect:dirtyRect];
    //NSColor *myColor = [NSColor colorWithCalibratedRed:redValue green:greenValue blue:blueValue alpha:1.0f];
    [[NSColor colorWithDeviceRed: 225.0/255.0 green: 229.0/255.0 blue: 234.0/255.0 alpha: 1.0] setFill];
    //[[NSColor blackColor] setFill];
    NSRectFill(dirtyRect); // Drawing code here.
}

@end
