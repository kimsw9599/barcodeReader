//
//  ToastView.h
//  barcodeReader
//
//  Created by 선욱 김 on 2014. 1. 18..
//  Copyright (c) 2014년 Newbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) UILabel *textLabel;
+ (void)showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuaration:(float)duration;

@end
