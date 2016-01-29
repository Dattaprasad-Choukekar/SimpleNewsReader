//
//  ViewController.h
//  Test
//
//  Created by Guest User on 16/12/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>


//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorObject;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;

@end


NSMutableArray *feeds;
NSMutableDictionary *item;
NSMutableString *title;
NSMutableString *link_;
NSMutableString *date;
NSMutableString *img_url;
NSString * element;
UIActivityIndicatorView * spinnerRef;
// check if feeeds are parsed
BOOL isLoaded;


