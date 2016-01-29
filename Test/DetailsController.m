//
//  ViewController.m
//  Test
//
//  Created by Guest User on 16/12/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

#import "DetailsController.h"

@interface DetailsController ()

@end

@implementation DetailsController



- (void)viewDidLoad {
    [super viewDidLoad];
     [_label sizeToFit];
    _label.text = _text_title;
    
    _label.numberOfLines = 0; //will wrap text in new line
    _label.lineBreakMode = NSLineBreakByWordWrapping;

    // Set spinner
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
   
    // Set image
    NSURL * imageURL = [NSURL URLWithString:_image_url];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [_textImage setImage: image];
    
    // Set web view
    [_textContent setDelegate: self];
    _text_url = [_text_url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *encodedString=[_text_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *websiteUrl = [NSURL URLWithString:_text_url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [_textContent loadRequest:urlRequest];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //read your request here
    //before the webview will load your request
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
  
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // Stop spinner
    spinner.stopAnimating;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"could not load the website caused by error: %@", error);
}


@end