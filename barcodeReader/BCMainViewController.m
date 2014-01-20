//
//  BCMainViewController.m
//  barcodeReader
//
//  Created by 선욱 김 on 2014. 1. 17..
//  Copyright (c) 2014년 Newbie. All rights reserved.
//

#import "BCMainViewController.h"
#import "ToastView.h"
#import "BCAppDelegate.h"

@interface BCMainViewController ()

@end

@implementation BCMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.readerView.tracksSymbols=YES;
    self.readerView.readerDelegate = self;
    
    self.overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
    [self.overlayImageView setFrame:CGRectMake(30, 100, 260, 200)];
    [[self view] addSubview:self.overlayImageView];
    
    if(TARGET_IPHONE_SIMULATOR) {
        self.cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        self.cameraSim.readerView = self.readerView;
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    // auto-rotation is supported
    return(YES);
}

- (void) cleanup
{
    self.cameraSim = nil;
    self.readerView.readerDelegate = nil;
    self.readerView = nil;
}

- (void) viewDidUnload
{
    [self cleanup];
    [super viewDidUnload];
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // compensate for view rotation so camera preview is not rotated
    [self.readerView willRotateToInterfaceOrientation: orient
                                        duration: duration];
    
    CGRect rect=self.overlayImageView.frame;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if(orient==UIInterfaceOrientationLandscapeLeft || orient==UIInterfaceOrientationLandscapeRight){
        rect.origin.x = (screenBounds.size.height/2)-130;
        rect.origin.y = (screenBounds.size.width/2)-100;
    }
    else{
        rect.origin.x = (screenBounds.size.width/2)-130;
        rect.origin.y = (screenBounds.size.height/2)-100;
    }
    self.overlayImageView.frame=rect;
}

- (void) viewDidAppear: (BOOL) animated
{
    // run the reader when the view is visible
    [self.readerView start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [self.readerView stop];
}


- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        self.resultText.text = sym.data;
        
        [ToastView showToastInParentView:self.view withText:sym.data withDuaration:5.0];
        
        BCAppDelegate *appDelegate = (BCAppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.returnScheme!=nil){
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"call message"
                                                               message:appDelegate.returnScheme
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView  show];
            
            NSString *schemeURI=[appDelegate.returnScheme stringByReplacingOccurrencesOfString:@"swbarcode://" withString:@""];
            
            NSArray *stringArray = [schemeURI componentsSeparatedByString: @"?"];
            
            if([stringArray count]==2){
                NSString *command=[stringArray objectAtIndex:0];
                NSString *params=[stringArray objectAtIndex:1];
                
                if([command isEqualToString:@"return_scheme"]){
                    NSString *returnScheme=nil;
                    NSString *returnCommand=nil;
                    NSString *returnParam=nil;
                    
                    NSArray *returnSchemeParam=[params componentsSeparatedByString:@"&"];
                    for(int i=0; i < [returnSchemeParam count]; i++){
                        NSArray *elemArr=[[returnSchemeParam objectAtIndex:i] componentsSeparatedByString:@"="];
                        if([elemArr count]==2){
                            if([[elemArr objectAtIndex:0] isEqualToString:@"scheme"]){
                                returnScheme=[elemArr objectAtIndex:1];
                            }else if([[elemArr objectAtIndex:0] isEqualToString:@"command"]){
                                returnCommand=[elemArr objectAtIndex:1];
                            }else if([[elemArr objectAtIndex:0] isEqualToString:@"param"]){
                                returnParam=[elemArr objectAtIndex:1];
                            }
                        }
                    }
                    
                    if(returnScheme!=nil && returnCommand!=nil && returnParam!=nil){
                        NSString *openScheme=[NSString stringWithFormat:@"%@://%@?%@=%@", returnScheme, returnCommand, returnParam, sym.data];
                        
                        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:openScheme]];
                    }
                }
            };
        }
        
        break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
