//
//  SLMainViewController.m
//  Site Lighter
//
//  Created by Pim Snel on 04-05-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "SLMainViewController.h"
#import "SLSite.h"
#import "WebToPng.h"
#import "AppDelegate.h"

@interface SLMainViewController ()

@end

@implementation SLMainViewController

@synthesize sitesTable;
@synthesize sitesArrayController;
@synthesize showDebugMessages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    
    return self;
}

- (void) loadView{
    [super loadView];
  
    [SLSite defaultSite];
    self.sitesTable.delegate = self;
    showDebugMessages = NO;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"showDebugMessages"])
    {
        showDebugMessages = YES;
    }

}

- (void) tableViewSelectionDidChange:(NSNotification *)notification{
    NSTableView* table = [notification object];
    NSInteger selection = table.selectedRow;
    NSArray* sites = [self.sitesArrayController arrangedObjects];
    
    SLSite * site = [sites objectAtIndex:selection];
    [[NSApp delegate] setValue:site forKey: @"selectedSite"];
    
    NSLog(@"%@",site);
}

#pragma mark IBActions

-(IBAction)testSettings:(id)sender{
   [self testFTPSettings];
    [self setSiteSceenShot];
}

-(void)setSiteSceenShot {
    SLSite * site = sitesArrayController.selectedObjects.lastObject;
    
    NSString * filename = [self genRandStringLength:5];
    NSString * newimagefilename = [NSString stringWithFormat:@"%@%@.png",[[[NSApp delegate] applicationFilesDirectory]absoluteString],filename];
    NSString * newimagepath = [NSString stringWithFormat:@"%@",[[[NSApp delegate] applicationFilesDirectory]absoluteString],filename];
    newimagefilename = [newimagefilename substringFromIndex:NSMaxRange([newimagefilename rangeOfString:@"file://localhost"])];
    newimagepath = [newimagepath substringFromIndex:NSMaxRange([newimagepath rangeOfString:@"file://localhost"])];
    
    NSLog(@"fil:%@",filename);
    NSLog(@"fil:%@",newimagefilename);
    NSLog(@"fil:%@",newimagepath);
    NSURL * url = [NSURL URLWithString:[site valueForKey:@"url"]];
    
    [[[WebToPng alloc] init] takeSnapshotOfURL:url   
                                        toPath:@"/tmp"
                                          name:@"hallo"  
                                      original:YES 
                                         thumb:NO 
                                       clipped:NO
                                         scale:0.25 
                                         width:200 
                                        height:150];
    
    [site setValue: @"/tmp/hallo-original.png" forKey:@"screenshot"];
    
    
    
}




-(NSString *) genRandStringLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

-(IBAction)optimize:(id)sender{
    SLSite * site = sitesArrayController.selectedObjects.lastObject;

    if([[NSUserDefaults standardUserDefaults] boolForKey:@"doDownload"])
    {
        [self refreshAndDownloadTree];
    }
    
    if([[site valueForKey:@"applyLightifyPlugin"] boolValue])
    {
//        NSLog("Lightify:%@",[site valueForKey:@"applyLightifyPlugin"]);
        [self applyLightify];    
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"doFilter"])
    {
        [self textReplaceAllHTMLFiles];
    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"doUpload"])
    {
        [self uploadTree];
    }
}

-(IBAction)visitSite:(id)sender{
    SLSite * site = sitesArrayController.selectedObjects.lastObject;    
    
    NSURL * url = [NSURL URLWithString:[site valueForKey:@"url"]];
    
    [[NSWorkspace sharedWorkspace] openURL:url];

    

}

#pragma mark ruby wrapper stuff

-(void)testFTPSettings{
    if(showDebugMessages) NSLog(@"test ftp:");    

    SLSite * site = sitesArrayController.selectedObjects.lastObject;
    NSString * wrapperPath = [NSString stringWithFormat:@"%@/Contents/Resources",[[NSBundle mainBundle] bundlePath]];
    NSString * rubyExec = @"/usr/bin/ruby";
    NSString * rubyScriptPath = [NSString stringWithFormat:@"%@/sitelighterlibwrapper.rb",wrapperPath];
    
    NSTask *rubyProcess = [[NSTask alloc] init];    
    [rubyProcess setCurrentDirectoryPath:wrapperPath];
    [rubyProcess setLaunchPath: rubyExec];
    [rubyProcess setArguments: [NSArray arrayWithObjects:
                                rubyScriptPath,
                                @"--action",@"test",
                                @"--localdir",[self getLocalDir],
                                @"--server",[site valueForKey:@"ftpServer"],
                                @"--user",[site valueForKey:@"ftpUser"],
                                @"--pass",[site valueForKey:@"ftpPass"],
                                @"--path",[site valueForKey:@"ftpPath"],                                
                                nil]];    
    [rubyProcess launch];        
    
    [rubyProcess waitUntilExit];
    int status = [rubyProcess terminationStatus];
    
    if (status == 0){
        NSLog(@"Task test succeeded.");
    }
    else if (status == 1) {
        NSLog(@"Task failed connection error. %i",status);
    }
    else if (status == 2) {
        NSLog(@"Task failed path error. %i",status);
    }
    
    [rubyProcess release];
}

-(void)refreshAndDownloadTree{
    if(showDebugMessages) NSLog(@"refresh and download:");    

    SLSite * site = sitesArrayController.selectedObjects.lastObject;
    
    NSString * wrapperPath = [NSString stringWithFormat:@"%@/Contents/Resources",[[NSBundle mainBundle] bundlePath]];
    NSString * rubyExec = @"/usr/bin/ruby";
    NSString * rubyScriptPath = [NSString stringWithFormat:@"%@/sitelighterlibwrapper.rb",wrapperPath];
    
    
    NSTask *rubyProcess = [[NSTask alloc] init];    
    [rubyProcess setCurrentDirectoryPath:wrapperPath];
    [rubyProcess setLaunchPath: rubyExec];
    [rubyProcess setArguments: [NSArray arrayWithObjects:
                                rubyScriptPath,
                                @"--action",@"download",
                                @"--localdir",[self getLocalDir],                                
                                @"--server",[site valueForKey:@"ftpServer"],
                                @"--user",[site valueForKey:@"ftpUser"],
                                @"--pass",[site valueForKey:@"ftpPass"],
                                @"--path",[site valueForKey:@"ftpPath"],                                
                                nil]];    
    [rubyProcess launch];        
    
    [rubyProcess waitUntilExit];
    int status = [rubyProcess terminationStatus];
    
    if (status == 0){
        NSLog(@"Task download and refresh localsite succeeded.");
    }
    else if (status == 1) {
        NSLog(@"Task failed refresh local site error. %i",status);
    }
    else if (status == 2) {
        NSLog(@"Task failed download error. %i",status);
    }
    
    [rubyProcess release];
}

-(void)applyLightify{
    if(showDebugMessages) NSLog(@"applyLightify:");    

    SLSite * site = sitesArrayController.selectedObjects.lastObject;
    
    NSString * wrapperPath = [NSString stringWithFormat:@"%@/Contents/Resources",[[NSBundle mainBundle] bundlePath]];
    NSString * rubyExec = @"/usr/bin/ruby";
    NSString * rubyScriptPath = [NSString stringWithFormat:@"%@/sitelighterlibwrapper.rb",wrapperPath];
    NSTask *rubyProcess = [[NSTask alloc] init];    
    [rubyProcess setCurrentDirectoryPath:wrapperPath];
    [rubyProcess setLaunchPath: rubyExec];
    [rubyProcess setArguments: [NSArray arrayWithObjects:
                                rubyScriptPath,
                                @"--action",@"applylightify",
                                @"--localdir",[self getLocalDir],                                
                                @"--server",[site valueForKey:@"ftpServer"],
                                @"--user",[site valueForKey:@"ftpUser"],
                                @"--pass",[site valueForKey:@"ftpPass"],
                                @"--path",[site valueForKey:@"ftpPath"],                                
                                nil]];    
    [rubyProcess launch];        
    
    [rubyProcess waitUntilExit];
    int status = [rubyProcess terminationStatus];
    
    if (status == 0){
        NSLog(@"Task applylightify succeeded.");
    }
    else if (status == 1) {
        NSLog(@"Task failed applylightify error. %i",status);
    }
    
    [rubyProcess release];
}

-(void)uploadTree{
    if(showDebugMessages) NSLog(@"uploadTree:");    

    SLSite * site = sitesArrayController.selectedObjects.lastObject;
    
    NSString * wrapperPath = [NSString stringWithFormat:@"%@/Contents/Resources",[[NSBundle mainBundle] bundlePath]];
    NSString * rubyExec = @"/usr/bin/ruby";
    NSString * rubyScriptPath = [NSString stringWithFormat:@"%@/sitelighterlibwrapper.rb",wrapperPath];
    
    
    NSTask *rubyProcess = [[NSTask alloc] init];    
    [rubyProcess setCurrentDirectoryPath:wrapperPath];
    [rubyProcess setLaunchPath: rubyExec];
    [rubyProcess setArguments: [NSArray arrayWithObjects:
                                rubyScriptPath,
                                @"--action",@"upload",
                                @"--localdir",[self getLocalDir],                                
                                @"--server",[site valueForKey:@"ftpServer"],
                                @"--user",[site valueForKey:@"ftpUser"],
                                @"--pass",[site valueForKey:@"ftpPass"],
                                @"--path",[site valueForKey:@"ftpPath"],                                
                                nil]];    
    [rubyProcess launch];        
    
    [rubyProcess waitUntilExit];
    int status = [rubyProcess terminationStatus];
    
    if (status == 0){
        NSLog(@"Task upload succeeded.");
    }
    else if (status == 1) {
        NSLog(@"Task failed upload error. %i",status);
    }
    
    [rubyProcess release];
}


#pragma mark main filter loop

-(NSString *)getLocalDir{
    NSString * localDir = @"/tmp/sitelighter";
    return localDir;
}

-(void)textReplaceAllHTMLFiles{
    SLSite * site = sitesArrayController.selectedObjects.lastObject;
    
    NSString* file;
    NSDirectoryEnumerator* enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self getLocalDir]];
    while (file = [enumerator nextObject])
    {
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath: [NSString stringWithFormat:@"%@/%@",[self getLocalDir],file]
                                             isDirectory: &isDirectory];
        if (!isDirectory)
        {
            if ([file rangeOfString:@"/"].location == NSNotFound) {
                //THESE ARE THE ONES
                NSLog(@"file: %@",file);            
                NSString *filePath = [[self getLocalDir] stringByAppendingPathComponent:file];
                NSError *anError;
                NSString *fileContents = [NSString stringWithContentsOfFile:filePath
                                                                   encoding:NSUTF8StringEncoding
                                                                      error:&anError];
                if (!fileContents) {
                    NSLog(@"%@", [anError localizedDescription]);
                } else {
    
                    NSString *replacedString = [self replaceHeader:fileContents 
                                                                  :[site valueForKey:@"codeHeader"] 
                                                                  :[site valueForKey:@"metaKeywords"] 
                                                                  :[site valueForKey:@"metaDescription"]];
                    
                    replacedString = [self replaceFooter:replacedString 
                                                        :[site valueForKey:@"codeFooter"] 
                                                        :[site valueForKey:@"googleAnalyticsCode"]];
                    
                    replacedString = [self replaceTitle:replacedString 
                                                       :[site valueForKey:@"titlePrefix"] 
                                                       :[site valueForKey:@"titlePostfix"]];

                    [replacedString writeToFile:filePath
                                     atomically:YES 
                                       encoding:NSUTF8StringEncoding
                                          error:&anError];                    
                }
            }
            else {
                //NSLog(@"ignored file: %@",file);
            }
        }        
    }
}

#pragma mark string replace magic

-(NSString *)replaceHeader:(NSString*)fileText :(NSString*)headerCode :(NSString*)keywords :(NSString*)description{
    
    if(showDebugMessages) NSLog(@"replaceHeader:");
    
    NSString *metakeywords =@"";
    NSString *metadescription =@"";
 
    if ([[keywords stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] > 0){
        metakeywords = [NSString stringWithFormat:@"<meta name=\"keywords\" content=\"%@\" />",keywords];
    }

    if ([[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] > 0){
        metadescription = [NSString stringWithFormat:@"<meta name=\"description\" content=\"%@\" />",description];    
    }
    
    NSString *replacedString;
    NSString *search = @"<!-- START SiteLighter HeaderCode -->";
    NSString *search2 = @"<!-- END SiteLighter HeaderCode -->";
    
    if([fileText rangeOfString:search].location == NSNotFound)
    {
        NSString *headerBlock = [[NSString alloc] initWithFormat:                                 
                                 @"<!-- START SiteLighter HeaderCode -->%@%@%@<!-- END SiteLighter HeaderCode --></head>", metadescription,metakeywords,headerCode];

        replacedString = [fileText stringByReplacingOccurrencesOfString:@"</head>" withString:headerBlock];
    }
    else {
        NSString *sub1 = [fileText substringToIndex:[fileText rangeOfString:search].location];
        NSString *sub2 = [fileText substringFromIndex:NSMaxRange([fileText rangeOfString:search2])];

        replacedString = [[NSString alloc] initWithFormat:                                 
                                 @"%@<!-- START SiteLighter HeaderCode -->%@%@%@<!-- END SiteLighter HeaderCode -->%@", sub1, metadescription,metakeywords,headerCode,sub2];
    }
    
    return replacedString;
}

-(NSString *)replaceFooter:(NSString*)fileText :(NSString*)footerCode :(NSString*)googleCode{
        if(showDebugMessages) NSLog(@"replaceFooter:");    
    NSString *replacedString;
    NSString *search = @"<!-- START SiteLighter FooterCode -->";
    NSString *search2 = @"<!-- END SiteLighter FooterCode -->";
    NSString * googleCodeBlock =@"";
    if ([[googleCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] > 0)
    {
        googleCodeBlock= @"<script type=\"text/javascript\">\
        \
        var _gaq = _gaq || [];\
        _gaq.push(['_setAccount', 'GOOGLECODE']);\
        _gaq.push(['_trackPageview']);\
        \
        (function() {\
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;\
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';\
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);\
        })();\
        \
        </script>";
        googleCodeBlock = [googleCodeBlock stringByReplacingOccurrencesOfString:@"GOOGLECODE" withString:googleCode];
        //NSLog(@"googleCode: %@",googleCodeBlock);
    }
    
    if([fileText rangeOfString:search].location == NSNotFound)
    {
        NSString *footerBlock = [[NSString alloc] initWithFormat:                                 
                                 @"<!-- START SiteLighter FooterCode -->%@%@<!-- END SiteLighter FooterCode --></body>", footerCode,googleCodeBlock];
        
        replacedString = [fileText stringByReplacingOccurrencesOfString:@"</body>" withString:footerBlock];
    }
    else {
        NSString *sub1 = [fileText substringToIndex:[fileText rangeOfString:search].location];
        NSString *sub2 = [fileText substringFromIndex:NSMaxRange([fileText rangeOfString:search2])];

        replacedString = [[NSString alloc] initWithFormat:                                 
                          @"%@<!-- START SiteLighter FooterCode -->%@%@<!-- END SiteLighter FooterCode -->%@", sub1,footerCode,googleCodeBlock,sub2];        
    }
    
    return replacedString;
}

-(NSString *)replaceTitle:(NSString*)fileText :(NSString*)prefix :(NSString *)postfix{
    if(showDebugMessages) NSLog(@"replaceTitle:");    

    NSString *replacedString;
    NSString *search = @"<!-- START SiteLighter TitleCode -->";
    NSString *search2 = @"<!-- END SiteLighter TitleCode -->";

    if([fileText rangeOfString:search].location == NSNotFound)
    {
        NSString *sub1 = [fileText substringToIndex:[fileText rangeOfString:@"<title>"].location];
        NSString *sub2 = [fileText substringFromIndex:NSMaxRange([fileText rangeOfString:@"</title>"])];    

        NSString *title = nil;
        NSScanner *theScanner = [NSScanner scannerWithString:fileText];
        // find start of IMG tag
        [theScanner scanUpToString:@"<title>" intoString:nil];
        if (![theScanner isAtEnd]) {
            [theScanner scanUpToString:@"</title>" intoString:&title];
            title = [title substringFromIndex:NSMaxRange([title rangeOfString:@"<title>"])];
        }

        
        replacedString = [NSString stringWithFormat:                                 
                          @"%@<!-- START SiteLighter TitleCode --><title>%@%@%@</title><meta origtitle=\"%@\" /><!-- END SiteLighter TitleCode -->%@",sub1,prefix,title,postfix,title,sub2];   
    }
    else {

      //  NSLog(@"title exists");
        NSString *title = nil;
       
        NSScanner *theScanner = [NSScanner scannerWithString:fileText];
        [theScanner scanUpToString:@"<meta origtitle" intoString:nil];
        if (![theScanner isAtEnd]) {
            NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
            [theScanner scanUpToCharactersFromSet:charset intoString:nil];
            [theScanner scanCharactersFromSet:charset intoString:nil];
            [theScanner scanUpToString:@"\" />" intoString:&title];
        }
        //NSLog(@"title exists %@",title);        

        
        NSString *sub1 = [fileText substringToIndex:[fileText rangeOfString:search].location];
        NSString *sub2 = [fileText substringFromIndex:NSMaxRange([fileText rangeOfString:search2])];    
        
        replacedString = [[NSString alloc] initWithFormat:                                 
                          @"%@<!-- START SiteLighter TitleCode --><title>%@%@%@</title><meta origtitle=\"%@\" /><!-- END SiteLighter TitleCode -->%@",sub1,prefix,title,postfix,title,sub2];

    }
    
    return replacedString;
    
    
}





@end
