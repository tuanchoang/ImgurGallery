//
//  GalleryViewController.h
//  ImgurGallery
//
//  Created by tuhoang on 10/28/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import "FullSizeImageViewController.h"
#import "GalleryCell.h"
#import "ImgurGalleryData.h"
#import "SDWebImage/SDWebImage/UIImageView+WebCache.h"
#import <UIKit/UIKit.h>

@interface GalleryViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) ImgurGalleryData *igd;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

// Makes a new request for Imgur gallery data then reloads the Gallery.
- (void)startRefresh;

@end
