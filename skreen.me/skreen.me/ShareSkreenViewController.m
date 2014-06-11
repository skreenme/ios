//
//  ViewController.m
//  skreen.me
//
//  Created by Pankaj Hotwani on 30/09/13.
//  Copyright (c) 2013 GSLab. All rights reserved.
//

#import "ShareSkreenViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define GOOGLE_SEARCH_URL @"https://www.google.com/search?q="
#define DROPBOX_URL @"http://www.dropbox.com"
#define GOOGLE_DRIVE_URL @"http://drive.google.com"
#define FACEBOOK_URL @"http://www.facebook.com"
#define TWITTER_URL @"http://www.twitter.com"
#define LINKEDIN_URL @"http://www.linkedin.com"
#define FLICKR_URL @"http://www.flickr.com"
#define PICASA_URL @"http://picasaweb.google.com"
#define EMAIL_URL @"contact@skreen.me"
#define EMAIL_SUBJECT @"skreen.me: Need help"
#define EMAIL_BODY @"Hi, I would like to get in touch with you..."
#define HOME_URL @"http://go.skreen.me/mobile"
#define SKREEN_ME_SHARE_URL @"http://go.skreen.me/view/"
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface ShareSkreenViewController ()
@property (strong, nonatomic) IBOutlet UITextField *urlField;
@property (strong, nonatomic) IBOutlet UILabel *skreenmeIdLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareIdButton;
@property (strong, nonatomic) NSString *skreenmeId;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndictor;

@property (assign, nonatomic) int currentPageNavCount;
@property (retain, nonatomic) UIPopoverController *shareIdPopoverController;
@property (retain, nonatomic) NSString *currentUserURLString;
@property (retain, nonatomic) IBOutlet UISwitch *skreenSwitch;

- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)openURL:(id)sender;
- (IBAction)dropboxTapped:(id)sender;
- (IBAction)googleDriveTapped:(id)sender;
- (IBAction)facebookTapped:(id)sender;
- (IBAction)twitterTapped:(id)sender;
- (IBAction)linkedInTapped:(id)sender;
- (IBAction)flickrTapped:(id)sender;
- (IBAction)picasaTapped:(id)sender;
- (IBAction)backTapped:(id)sender;
- (IBAction)toggleScreenSharing:(id)sender;
- (IBAction)contactUsClicked:(id)sender;
- (IBAction)shareIdButtonClicked:(id)sender;
- (BOOL) canWebViewGoBack;
- (void) openMailClientWithSubject:(NSString *) subject to:(NSString *) to body:(NSString *) body;
@end

@implementation ShareSkreenViewController

#pragma mark - View Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Share my screen";
    self.urlField.text = HOME_URL;
    
    // Round corners using CALayer property
    [[self.webview layer] setCornerRadius:3];
    [self.webview setClipsToBounds:YES];
    
    // Create colored border using CALayer property
    [[self.webview layer] setBorderColor: [[UIColor grayColor] CGColor]];
    [[self.webview layer] setBorderWidth:1];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:HOME_URL]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenShareStoppedUiUpdate) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
#if DEBUG
    NSLog(@"dealloc#called");
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Others

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void) openURLWithString:(NSString *) urlString {
    self.currentUserURLString = urlString;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}
- (IBAction)openURL:(id)sender {
    [self.urlField resignFirstResponder];
    NSString *urlText = self.urlField.text;

    [self openURLWithString:urlText];
    
//    if([urlText rangeOfString:@"http://"].location != NSNotFound || [urlText rangeOfString:@"https://"].location != NSNotFound) {
//        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlText]]];
//    } else {
//        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlText]]]];
//    }
}

- (IBAction)dropboxTapped:(id)sender {
    self.urlField.text = DROPBOX_URL;
    [self openURL:nil];
}

- (IBAction)googleDriveTapped:(id)sender {
    self.urlField.text = GOOGLE_DRIVE_URL;
    [self openURL:nil];
}

- (IBAction)facebookTapped:(id)sender {
    self.urlField.text = FACEBOOK_URL;
    [self openURL:nil];
}

- (IBAction)twitterTapped:(id)sender {
    self.urlField.text = TWITTER_URL;
    [self openURL:nil];
}

- (IBAction)linkedInTapped:(id)sender {
    self.urlField.text = LINKEDIN_URL;
    [self openURL:nil];
}

- (IBAction)flickrTapped:(id)sender {
    self.urlField.text = FLICKR_URL;
    [self openURL:nil];
}

- (IBAction)picasaTapped:(id)sender {
    self.urlField.text = PICASA_URL;
    [self openURL:nil];
}

- (IBAction)backTapped:(id)sender {
    if(self.canWebViewGoBack) {
        [self.webview goBack];
        self.currentPageNavCount--;
    }
}

- (IBAction)toggleScreenSharing:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UISwitch *toggleSwitch = (UISwitch *) sender;
    
    if(toggleSwitch.on) {
        [appDelegate startScreenSharing:self];
    } else {
        [appDelegate stopScreenSharing];
        [self updateUIForScreenShare];
    }
}

- (IBAction)contactUsClicked:(id)sender {
    [self openMailClientWithSubject:EMAIL_SUBJECT to:EMAIL_URL body:EMAIL_BODY];
}

- (IBAction)shareIdButtonClicked:(id)sender {
    [self shareSkreenMe];
}

- (void) openMailClientWithSubject:(NSString *) subject to:(NSString *) to body:(NSString *) body {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:subject];
    [controller setMessageBody:body isHTML:NO];
    [controller setToRecipients:[NSArray arrayWithObjects:to, nil]];
    if (controller) [self presentModalViewController:controller animated:YES];
    
}

- (IBAction)homeButtonClicked:(id)sender {
    self.urlField.text = HOME_URL;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:HOME_URL]]];
    self.currentPageNavCount = 0;
}

- (BOOL) canWebViewGoBack {
    if(self.currentPageNavCount > 0 && self.webview.canGoBack)
        return YES;
    else
        return NO;
}

- (NSString *) shareSkreenSubject {
    NSString *subject = NSLocalizedString(@"SHARE_SKREEN_ME_TEXT", @"View my application's screen at");
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        subject = NSLocalizedString(@"SHARE_SKREEN_ME_TEXT_IPHONE", @"View my iPhone app screen at");
    } else if ([deviceType isEqualToString:@"iPad"]) {
        subject = NSLocalizedString(@"SHARE_SKREEN_ME_TEXT_IPAD",@"View my iPad app screen at");
    } else if ([deviceType isEqualToString:@"iPod"]) {
        subject = NSLocalizedString(@"SHARE_SKREEN_ME_TEXT_IPOD",@"View my iPod app screen at");
    }
    
    NSString *skreenMeUrl = [NSString stringWithFormat:@"http://skreen.me/view/%@", self.skreenmeId];
    return [NSString stringWithFormat:@"%@ %@", subject, skreenMeUrl];
}

- (NSString *) shareSkreenBodyText {
    return [NSString stringWithFormat:@"Hi, %@", [self shareSkreenSubject]];
}

- (void) shareSkreenMe {
    if (NSClassFromString(@"UIActivityViewController") != nil) {
        
        NSArray *sharingArray = @[self];
        UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:sharingArray applicationActivities:nil];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (self.shareIdPopoverController == nil) {
                self.shareIdPopoverController = [[UIPopoverController alloc] initWithContentViewController:shareViewController];
            } else {
                self.shareIdPopoverController.contentViewController = shareViewController;
            }
            
            [self.shareIdPopoverController presentPopoverFromRect:[self.shareIdButton convertRect:self.shareIdButton.bounds toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [self presentViewController:shareViewController animated:YES completion:nil];
        }
        
    } else {
        
        [self openMailClientWithSubject:[self shareSkreenSubject]
                                     to:nil
                                   body:[self shareSkreenBodyText]];
    }
}

- (void) updateUIForScreenShare{
#if DEBUG
    NSLog(@"updateUIForScreenShare#called");
#endif
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isScreenSharing) {
        NSString *msg = NSLocalizedString(@"SKREEN_ME_SUCCESS_TEXT", @"View my application's screen at");
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Info"
                                  message:msg
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"INVITE", @"Invite")
                                  otherButtonTitles:NSLocalizedString(@"CANCEL", @"Cancel"), nil];
        self.skreenmeIdLabel.text = [NSString stringWithFormat:@"Skreen.me Id: %@", self.skreenmeId];
        self.shareIdButton.hidden = NO;
        self.skreenmeIdLabel.hidden = NO;
        [alertView show];
    } else {
        [self screenShareStoppedUiUpdate];
    }
}

- (void) screenShareStoppedUiUpdate {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![appDelegate isScreenSharing]) {
        self.skreenmeIdLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SKREEN_ME", @"skreen.me"), NSLocalizedString(@"ID", @"id")];
        self.shareIdButton.hidden = YES;
        self.skreenmeIdLabel.hidden = YES;
        [self.skreenSwitch setOn:NO];
    }
    
}

#pragma mark - UIWebViewDelegate methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndictor stopAnimating];
    NSLog(@"error: %@", error);
    HideNetworkActivityIndicator();
    if (error.code == 101 || error.code == 102) { //error code for Malformed URL: WebKitErrorCannotShowURL
        if (self.currentUserURLString != nil && [self.currentUserURLString rangeOfString:GOOGLE_SEARCH_URL].location == NSNotFound) {
            
            NSString *urlString = [self.currentUserURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            urlString = [NSString stringWithFormat:@"%@%@", GOOGLE_SEARCH_URL, urlString];
            
#if DEBUG
            NSLog(@"didFailLoadWithError#urlString: %@", urlString);
#endif
            [self.urlField setText:urlString];
            [self openURLWithString:urlString];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndictor startAnimating];
    self.currentPageNavCount++;
    ShowNetworkActivityIndicator();
    [self.urlField setText:webView.request.URL.absoluteString];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndictor stopAnimating];
    self.urlField.text = [NSString stringWithFormat:@"%@", webView.request.URL];
    HideNetworkActivityIndicator();
    

}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self openURL:nil];
    return YES;
}


#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"Email sent");
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SkreenMeDelegate methods
- (void)onOpenScreenStatus:(NSString *)skreenmeId {
    self.skreenmeId = skreenmeId;
    
    [self updateUIForScreenShare];
}


#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"INVITE", @"Invite")]) {
        [self shareSkreenMe];
        
    }
}

#pragma mark - UIActivityItemSource methods

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}

- (id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return [self shareSkreenBodyText];
}


- (NSString *) activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    
#if DEBUG
    NSLog(@"UIActivityItemSource#called");
#endif
    return NSLocalizedString(@"SHARE_SKREEN_ME_SUBJECT", @"skreen.me: View my application's screen");
}

@end
