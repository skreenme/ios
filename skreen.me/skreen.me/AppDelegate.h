//
//  AppDelegate.h
//  skreen.me
//
//  Created by Pankaj Hotwani on 30/09/13.
//  Copyright (c) 2013 GSLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <skreenmefrm/SkreenMe.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SkreenMe *skreenMe;
@property (getter = isScreenSharing, nonatomic) BOOL screenSharing;

-(void) startScreenSharing:(id<SkreenMeDelegate>) vc;
-(void) stopScreenSharing;

@end
