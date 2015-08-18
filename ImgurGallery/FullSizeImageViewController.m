//
//  FullSizeImageViewController.m
//  ImgurGallery
//
//  Created by tuhoang on 10/30/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import "FullSizeImageViewController.h"

@interface FullSizeImageViewController ()

@end

@implementation FullSizeImageViewController

@synthesize imageURL, webView;

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
    
    // Displays the full size image in a UIWebView.
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];
    [webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Copy Link",
                                                                      @"Save Image",
                                                                      @"Share on Facebook",
                                                                      @"Share on Twitter", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

// Handles the share and save options button click events.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self copyImageURLToPasteboard];
            break;
        case 1:
            [self saveImageToCameraRoll];
            break;
        case 2:
            [self shareImageOnSocialNetwork:SLServiceTypeFacebook];
            break;
        case 3:
            [self shareImageOnSocialNetwork:SLServiceTypeTwitter];
            break;
    }
}

- (void)copyImageURLToPasteboard
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.URL = imageURL;
}

- (void)saveImageToCameraRoll
{
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

- (void)shareImageOnSocialNetwork:(NSString *)serviceType
{
    SLComposeViewController *slcvc = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    [slcvc addImage:image];
    [self presentViewController:slcvc animated:YES completion:nil];
}

@end
