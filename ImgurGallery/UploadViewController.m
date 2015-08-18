//
//  UploadViewController.m
//  ImgurGallery
//
//  Created by tuhoang on 11/6/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

@synthesize parsedResponseData, receivedData, imageURL, activityIndicator, selectedImage,
            imageView, progressView, textView, uploadInProgressView, progressBarView;

#define kUploadSuccessAlert 1

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
    
    // Display navigation bar title.
    self.navigationItem.titleView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButtonPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"The Photo Library is unavailable\non this device."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// Sets the image view as the selected image.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageView.image = selectedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadButtonPressed:(id)sender
{
    if (selectedImage != nil)
        [self uploadSelectedImage];
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Select an image from the\nPhoto Library."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)uploadSelectedImage
{
    // Get the data of the selected image in JPEG format.
    NSData *imageData = UIImageJPEGRepresentation(selectedImage, 1.0);
    
    // Get the Base64 encoded string of imageData.
    NSString *imageBase64 = [imageData base64EncodedString];
    
    // Get the URL-encoded string of imageBase64.
    NSString *encodedImageB64 = [self URLEncodeString:imageBase64];
    
    // Get the Imgur upload call.
    NSString *uploadCall = [NSString stringWithFormat:@"key=%@&image=%@", kImgurDeveloperAPIKey, encodedImageB64];
    
    // Get the Imgur upload request URL.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kImgurUploadURL];
    
    // Set the HTTP request method to POST.
    [request setHTTPMethod:@"POST"];
    
    // Set the HTTP Content-Length header field value to the length of the upload call.
    [request setValue:[NSString stringWithFormat:@"%d", [uploadCall length]] forHTTPHeaderField:@"Content-length"];
    
    // Set the HTTP request body to the UTF-8 encoded upload call.
    [request setHTTPBody:[uploadCall dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Initiate the asynchronous upload request.
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    // Initialize upload response data to zero.
    receivedData = [[NSMutableData alloc] initWithLength:0];
    
    // Initialize the upload progress.
    [self initUploadProgress];
}

- (NSString *)URLEncodeString:(NSString *)unencodedString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)unencodedString,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

// Handles the connection failure event.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self resetUploadProgress];
    [self setNavigationBarButtonItemsEnabled:YES];
}

// Resets the received data to zero.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

// Stores the upload response data.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

// Calculates the upload progress.
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    float progress = [[NSNumber numberWithInteger:totalBytesWritten] floatValue];
    float total = [[NSNumber numberWithInteger:totalBytesExpectedToWrite] floatValue];
    NSNumber *progressValue = [NSNumber numberWithFloat:progress/total * 100];
    [self performSelectorOnMainThread:@selector(updateUploadProgressWithValue:) withObject:progressValue waitUntilDone:NO];
}

// Handles the post-upload event.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Store the parsed JSON response data.
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
    parsedResponseData = [json objectForKey:@"upload"];
    NSLog(@"%@", parsedResponseData);
    
    // Store the uploaded image URL.
    NSDictionary *links = [parsedResponseData objectForKey:@"links"];
    imageURL = [NSURL URLWithString:[links objectForKey:@"original"]];
    
    // Hide and reset the upload progress.
    [self performSelectorOnMainThread:@selector(resetUploadProgress) withObject:nil waitUntilDone:NO];
    
    // Show upload success alert.
    [self performSelectorOnMainThread:@selector(showUploadSuccessAlert) withObject:nil waitUntilDone:NO];
}

- (void)setNavigationBarButtonItemsEnabled:(BOOL)enabled
{
    self.navigationItem.leftBarButtonItem.enabled = enabled;
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

- (void)initUploadProgress
{
    // Show network activity indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Show upload progress and activity indicator.
    self.navigationItem.titleView = progressBarView;
    uploadInProgressView.hidden = NO;
    [activityIndicator startAnimating];
    
    // Disable Camera and Upload buttons.
    [self setNavigationBarButtonItemsEnabled:NO];
}

- (void)updateUploadProgressWithValue:(NSNumber *)progressValue
{
    [progressView setProgress:[progressValue floatValue]/100 animated:YES];
}

- (void)resetUploadProgress
{
    // Hide network activity indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Hide upload progress and activity indicator.
    [activityIndicator stopAnimating];
    uploadInProgressView.hidden = YES;
    self.navigationItem.titleView = nil;
    
    // Reset progress bar to zero.
    [progressView setProgress:0.0 animated:NO];
}

- (void)resetSelectedImage
{
    selectedImage = nil;
    imageView.image = selectedImage;
}

- (void)showUploadSuccessAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Finished"
                                                    message:[NSString stringWithFormat:@"Link: %@", imageURL]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Share", nil];
    alert.tag = kUploadSuccessAlert;
    [alert show];
}

// Handles the upload success alert button click event.
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kUploadSuccessAlert && buttonIndex == 0)
    {
        [self resetSelectedImage];
        [self setNavigationBarButtonItemsEnabled:YES];
    }
    else if (alertView.tag == kUploadSuccessAlert && buttonIndex == 1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Copy Link",
                                                                          @"Share on Facebook",
                                                                          @"Share on Twitter", nil];
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

// Handles the uploaded image URL sharing options button click event.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self copyImageURLToPasteboard];
            break;
        case 1:
            [self shareImageURLOnSocialNetwork:SLServiceTypeFacebook];
            break;
        case 2:
            [self shareImageURLOnSocialNetwork:SLServiceTypeTwitter];
            break;
    }
}

- (void)copyImageURLToPasteboard
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.URL = imageURL;
    [self resetSelectedImage];
    [self setNavigationBarButtonItemsEnabled:YES];
}

- (void)shareImageURLOnSocialNetwork:(NSString *)serviceType
{
    SLComposeViewController *slcvc = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    slcvc.completionHandler = ^(SLComposeViewControllerResult result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetSelectedImage];
            [self setNavigationBarButtonItemsEnabled:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    };
    [slcvc addURL:imageURL];
    [self presentViewController:slcvc animated:YES completion:nil];
}

@end
