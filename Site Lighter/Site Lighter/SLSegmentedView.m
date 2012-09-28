//
//  SLSegmentedView.m
//  Site Lighter
//
//  Created by Pim Snel on 28-09-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "SLSegmentedView.h"

@implementation SLSegmentedView

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
    
    //[[NSColor redColor] setFill];
    //NSRectFill(dirtyRect);
}

@end
