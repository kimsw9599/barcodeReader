//
//  BCMainViewController.m
//  barcodeReader
//
//  Created by 선욱 김 on 2014. 1. 17..
//  Copyright (c) 2014년 Newbie. All rights reserved.
//

#import "BCMainViewController.h"
#import "ToastView.h"

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

        break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
