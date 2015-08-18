//
//  UploadViewController.h
//  ImgurGallery
//
//  Created by tuhoang on 11/6/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import "Base64/Base64/NSData+Base64.h"
#import <Social/Social.h>
#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController <NSURLConnectionDataDelegate, UIActionSheetDelegate, UIAlertViewDelegate,
                                                    UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSDictionary *parsedResponseData;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *uploadInProgressView;
@property (strong, nonatomic) IBOutlet UIView *progressBarView;

#define kImgurDeveloperAPIKey @"612d47062733777b3dcc89dec5f00324"
#define kImgurUploadURL [NSURL URLWithString:@"http://api.imgur.com/2/upload.json"]

// Displays the photo library to allow the user to select an image.
- (IBAction)cameraButtonPressed:(id)sender;

// Handles the Upload button press event.
- (IBAction)uploadButtonPressed:(id)sender;

// Uploads the selected image to Imgur.
- (void)uploadSelectedImage;

// Returns a URL-encoded NSString of the specified unencoded NSString.
- (NSString *)URLEncodeString:(NSString *)unencodedString;

// Sets whether the navigation bar button items are enabled.
- (void)setNavigationBarButtonItemsEnabled:(BOOL)enabled;

// Initializes the upload progress.
- (void)initUploadProgress;

// Updates the upload progress.
- (void)updateUploadProgressWithValue:(NSNumber *)progressValue;

// Resets the upload progress.
- (void)resetUploadProgress;

// Resets the selected image.
- (void)resetSelectedImage;

// Displays a UIAlertView on image upload success with share option.
- (void)showUploadSuccessAlert;

// Copies the image URL to the pasteboard.
- (void)copyImageURLToPasteboard;

// Allows the user to share the image URL on the specified social network
- (void)shareImageURLOnSocialNetwork:(NSString *)serviceType;

@end
