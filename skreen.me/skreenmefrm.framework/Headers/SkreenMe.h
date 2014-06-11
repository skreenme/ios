//
//  skreenme.h
//  skreenme
//
//  Created by Pratik Pradhan on 18/01/13.
//  Copyright (c) 2013 kPoint Technologies Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIImage.h>

#import "HTTPService.h"

typedef enum {
    INIT_SKREENME,
    CONNECTING_SKREENME,
    CONNECTED_SKREENME,
    DISCONNECTING_SKREENME,
    DISCONNECTED_SKREENME
} SessionState;

@protocol SkreenMeDelegate <NSObject>

@required

-(void)onOpenScreenStatus:(NSString *)skreenmeId; // skreenmeId is nil if currently no session else session-id

@end

@interface SkreenMe : NSObject <HTTPServiceDelegate> {
    NSString *skreenMeAppKey;
    NSString *skreenMeAppSecret;
    id<SkreenMeDelegate> skreenMeDelegate;
    id screenShare;
    NSString *rotation;
}

@property (readonly, strong) NSString *serverUrl;
@property (readonly, strong) NSString *skreenMeId;
@property (readonly) SessionState sessionState;
@property (readonly, strong) id<SkreenMeDelegate> skreenMeDelegate;
@property (readonly, strong) NSTimer *timer;

-(UIImage*)kaptureScreen;

-(id)initSkreenMeWithDelegate:(id<SkreenMeDelegate>)delegate
           withSkreenMeAppkey:(NSString*)appKey
         AndSkreenMeAppSecret:(NSString*)appSecret;

-(BOOL)openSkreenWithName:(NSString*)name
                  ofWidth:(int)screenWidth
                 ofHeight:(int)screenHeight;

-(void)closeSkreen;

@end
