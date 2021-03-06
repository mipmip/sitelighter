//
//  SLMainViewController.h
//  Site Lighter
//
//  Created by Pim Snel on 04-05-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface SLMainViewController : NSViewController <NSTableViewDelegate>

@property (retain) IBOutlet NSTableView* sitesTable;
@property (retain) IBOutlet NSImageView* screenshotView;
@property (retain) IBOutlet NSArrayController* sitesArrayController;
@property (retain) IBOutlet NSWindow * pdfWindow;

@property (retain) IBOutlet PDFView * pdfView;
@property BOOL showDebugMessages;



//@property (retain) IBOutlet NSView* mainView;

-(IBAction)testSettings:(id)sender;
-(IBAction)optimize:(id)sender;
-(IBAction)visitSite:(id)sender;
-(IBAction)openTutor:(id)sender;

@end
