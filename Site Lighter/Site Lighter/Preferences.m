//
//  Preferences.m
//  Site Lighter
//
//  Created by Pim Snel on 11-03-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "Preferences.h"

@interface Preferences ()

@end

@implementation Preferences

-(id)init{
    if (![super initWithWindowNibName:@"Preferences"]){
        return nil;
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
