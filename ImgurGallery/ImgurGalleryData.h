//
//  ImgurGalleryData.h
//  ImgurGallery
//
//  Created by tuhoang on 10/28/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurGalleryData : NSObject

@property (strong, nonatomic) NSArray *parsedResponseData;

#define kImgurGalleryURL [NSURL URLWithString:@"http://imgur.com/gallery.json"]

// Returns the full size image URL at the specified index.
- (NSURL *)fullSizeImageURLAtIndex:(NSUInteger)index;

// Returns the album cover (first image in an album) of the image at the specified index.
- (NSString *)imageAlbumCoverAtIndex:(NSUInteger)index;

// Returns the file extension of the image at the specified index.
- (NSString *)imageExtensionAtIndex:(NSUInteger)index;

// Returns the hash (filename) of the image at the specified index.
- (NSString *)imageHashAtIndex:(NSUInteger)index;

// Returns a Boolean value indicating whether the album cover is null at the specified index.
- (BOOL)isAlbumCoverNullAtIndex:(NSUInteger)index;

// Returns the number of images in the Imgur gallery data set.
- (NSUInteger)numberOfImages;

// Requests for Imgur gallery data and stores the parsed JSON response data.
- (void)requestImgurGalleryData;

// Returns the thumbnail image URL at the specified index.
- (NSURL *)thumbnailImageURLAtIndex:(NSUInteger)index;

@end
