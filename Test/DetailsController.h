//
//  ViewController.h
//  Test
//
//  Created by Guest User on 16/12/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsController : UIViewController


@property (retain, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIImageView *textImage;
@property (nonatomic, retain) IBOutlet UIWebView *textContent;
@property(nonatomic) NSString * text_title;
@property(nonatomic) NSMutableString * text_url;
@property(nonatomic) NSMutableString * image_url;
@property(nonatomic) NSString * date;

@end

UIActivityIndicatorView *spinner;

