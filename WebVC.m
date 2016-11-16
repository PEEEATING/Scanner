//
//  WebVC.m
//  Scanner
//
//  Created by EATING on 2016/11/16.
//  Copyright © 2016年 EATING. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()


@property (nonatomic,strong) UIWebView *webView;

@end

@implementation WebVC

-(UIWebView *) webView {

    if(_webView == nil){
        _webView = [[UIWebView alloc]init];
        _webView.frame = self.view.bounds;
        [self.view addSubview:_webView];
    }
    return _webView;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString: self.urlString];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest: urlReq];
}

@end
