//
//  FullSizeImageViewController.h
//  ImgurGallery
//
//  Created by tuhoang on 10/30/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import <Social/Social.h>
#import <UIKit/UIKit.h>

@interface FullSizeImageViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

// Displays options to allow the user to share or save the image.
- (IBAction)actionButtonPressed:(id)sender;

// Copies the image URL to the pasteboard.
- (void)copyImageURLToPasteboard;

// Saves the image to the Camera Roll.
- (void)saveImageToCameraRoll;

// Allows the user to share the image on the specified social network.
- (void)shareImageOnSocialNetwork:(NSString *)serviceType;

@end
