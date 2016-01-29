//
//  ViewController.m
//  Test
//
//  Created by Guest User on 16/12/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

#import "ViewController.h"
#import "DetailsController.h"

@interface ViewController ()

@end


@implementation ViewController


/*
   Recieves notification and reloads UI Table viewÒ
 
 */
- (void) receiveTestNotification:(NSNotification *) notification
{
    [spinnerRef stopAnimating];
    isLoaded = true;
    [_feedTableView reloadData];
    // NSLog(@"Received notification");
}

- (void)viewDidLoad {
    [self setTitle:@"Simple News Reader"];
    [super viewDidLoad];
   
    [_feedTableView setDelegate: self];
    [_feedTableView setDataSource:self];
    
    
    __block  NSXMLParser * parser;
    __block  UIActivityIndicatorView *spinner;

    
    // Setting up parser
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"myxml" withExtension:@"xml"];
    NSURL *url = [NSURL URLWithString:@"http://feeds.bbci.co.uk/news/rss.xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    parser = [[ NSXMLParser alloc] initWithData:data];
    feeds = [[NSMutableArray alloc] init];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    //[parser parse];
    
    // Setting up Navigation bar
    
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:navbar];
    
    // Add spinner
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    spinnerRef = spinner;
    
    // set oberver to listen to Loaded event
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"Loaded"
                                               object:nil];
   
    
    
    // Parse asynchronously
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [parser parse];

        dispatch_async( dispatch_get_main_queue(), ^{
            // Parsing completed
             [[NSNotificationCenter defaultCenter] postNotificationName:@"Loaded" object:self];
        });
        
    });
    
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    element = elementName;
    if([element isEqualToString:@"item"])
    {
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link_ = [[NSMutableString alloc] init];
        date = [[NSMutableString alloc] init];
        // default image
        img_url = @"http://news.bbcimg.co.uk/nol/shared/img/bbc_news_120x60.gif";
        
    }
    
    if([element isEqualToString:@"media:thumbnail"])
    {
        // get thumbnil URL
         img_url =[[attributeDict objectForKey: @"url"] mutableCopy];

    }
 
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([element isEqualToString:@"title"])
    {
        [title appendString:string];
        
    }else if([element isEqualToString:@"link"])
        {
            [link_ appendString:string];
        }
    else if([element isEqualToString:@"pubDate"])
    {
        [date appendString:string];
    }

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"item"])
        {
      
            [ item setObject:title forKey:@"title"];
            [ item setObject:link_ forKey:@"link"];
            [ item setObject:date forKey:@"date"];
            [ item setObject:img_url forKey:@"img_url"];
            [feeds addObject:[item copy]];
          
        }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"%@", feeds);
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error %li, Description: %@, Line: %li, Column: %li", (long)[parseError code],
          [[parser parserError] localizedDescription], (long)[parser lineNumber],
          (long)[parser columnNumber]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-    (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Initially return zero after receiving notification return 20
     if (isLoaded){
        return 20;
    } else {
        return 0;
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableIdentifier = @"Simple Table Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: tableIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:tableIdentifier];
        
    }

    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    
    
    
     cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [ [feeds objectAtIndex:indexPath.row] objectForKey:@"date"] ;
    
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    NSString * tempImgURL =  [ [feeds objectAtIndex:indexPath.row] objectForKey:@"img_url"];
   
    if (   [tempImgURL containsString:@"bbc_news_default.gif" ]){
        cell.imageView.image = [UIImage imageNamed: @"bbc_news_default.gif"];
    } else{
        
         NSURL * imageURL = [NSURL URLWithString: [ [feeds objectAtIndex:indexPath.row] objectForKey:@"img_url"] ];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return  (44.0 + (2 - 1) * 19.0);
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath* )indexPath{
    
         [self performSegueWithIdentifier:@"MySG" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath* )indexPath

{
    DetailsController * transferViewController = segue.destinationViewController;
    transferViewController.text_title = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    transferViewController.text_url = [[feeds objectAtIndex:indexPath.row] objectForKey:@"link"];
    transferViewController.date = [[feeds objectAtIndex:indexPath.row] objectForKey:@"date"];
    transferViewController.image_url = [[feeds objectAtIndex:indexPath.row] objectForKey:@"img_url"];
    
}


@end
