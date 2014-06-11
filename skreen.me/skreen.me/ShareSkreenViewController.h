//
//  ViewController.h
//  skreen.me
//
//  Created by Pankaj Hotwani on 30/09/13.
//  Copyright (c) 2013 GSLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface ShareSkreenViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate, SkreenMeDelegate, UIActivityItemSource>

@end
