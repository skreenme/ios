//
//  ViewSkreenViewController.m
//  skreen.me
//
//  Created by Pratik Pradhan on 25/04/14.
//  Copyright (c) 2014 GSLab. All rights reserved.
//

#import "ViewSkreenViewController.h"

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

@interface ViewSkreenViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewSkreenViewController

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
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"View a shared screen";
    NSString* urlString = @"http://go.skreen.me/view/mobile";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webViewDidStartLoad:(UIWebView *)webView {
    ShowNetworkActivityIndicator();
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    HideNetworkActivityIndicator();
}


@end
