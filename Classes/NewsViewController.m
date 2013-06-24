//
//  NewsViewController.m
//  Mon ResoVelo
//
//  Created by Stewart Jackson on 2013-05-24.
//
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize webView;

@synthesize navigationController;

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
    // Do any additional setup after loading the view from its nib.
    [navigationController setNavigationBarHidden: YES animated:NO];
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ville.montreal.qc.ca/velo"]]]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
