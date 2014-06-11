//
//  HttpService.h
//  Plunk
//
//  Created by GS LAB on 21/05/12.
//  Copyright (c) 2012 developer.gslab@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPServiceDelegate
- (void) responseCode:(int)code;
- (void) storeResponse:(NSData *)data forIdentifier:(NSString *) identifier;

@required
- (void)didReceiveResponse :(NSData *)data forIdentifier:(NSString *) identifier;
@required
- (void)serviceDidFailWithError : (NSError *)error forIdentifier:(NSString *) identifier;

@end

#define TIMEOUT_INTERVAL 45

typedef enum {
    kRequestMethodGET,
    kRequestMethodPOST,
    kRequestMethodNone,
    kRequestMethodPUT,
    
} RequestMethod;

typedef enum {
    kNetworkConnectionError = -1009,
    kHostUnreachableError = -1004,
    kServerTimeOutError = -1001,
    kServerConnectionError
}ConnectionError;

@interface HTTPService : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLConnection *connection;
//retaining the delegate instead of assigning it.
@property (nonatomic, strong) id<HTTPServiceDelegate> delegate;
@property (nonatomic, strong) NSString *serviceURLString;
@property (nonatomic, strong) NSMutableDictionary *headersDictionary;
@property (nonatomic, strong) NSString *bodyString;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSString *identifier;

//the bodyString when converted to NSData is stored here.
//The dev can also set the data directly
@property (nonatomic, strong) NSData *bodyData;

@property(nonatomic) BOOL isPOST;
@property(nonatomic) RequestMethod serviceRequestMethod;

- (id)initWithURLString : (NSString *)urlString headers : (NSDictionary *)headers body : (NSString *)body
               delegate : (id<HTTPServiceDelegate>)serviceDelegate requestMethod : (RequestMethod)requestMethod;

- (id)initWithURLString : (NSString *)urlString headers : (NSDictionary *)headers body : (NSString *)body 
               delegate : (id<HTTPServiceDelegate>)serviceDelegate requestMethod : (RequestMethod)requestMethod identifier:(NSString *)iden;

- (id)initWithURLString : (NSString *)urlString
          havingHeaders : (NSDictionary *)headers
               withBody : (NSData *)body
               delegate : (id<HTTPServiceDelegate>)serviceDelegate
          requestMethod : (RequestMethod)requestMethod
              identifier:(NSString *)iden;

- (void)startService;
- (void)cancelHTTPService ;

@end
