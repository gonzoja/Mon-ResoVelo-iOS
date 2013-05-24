//
//  NewsViewController.h
//  Mon ResoVelo
//
//  Created by Stewart Jackson on 2013-05-24.
//
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController {

IBOutlet UIWebView *webView;
IBOutlet UINavigationController *navigationController;

}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;


@end
