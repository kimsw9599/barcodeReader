//
//  BCMainViewController.h
//  barcodeReader
//
//  Created by 선욱 김 on 2014. 1. 17..
//  Copyright (c) 2014년 Newbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCMainViewController : UIViewController <ZBarReaderViewDelegate>

@property (nonatomic, strong) IBOutlet ZBarReaderView *readerView;
@property (nonatomic, strong) ZBarCameraSimulator *cameraSim;
@property (nonatomic, retain) IBOutlet UITextField *resultText;

@end
