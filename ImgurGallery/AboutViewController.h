//
//  AboutViewController.h
//  ImgurGallery
//
//  Created by tuhoang on 11/14/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textView;

// Dismisses the AboutViewController.
- (IBAction)doneButtonPressed:(id)sender;

@end
