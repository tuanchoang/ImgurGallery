//
//  ImgurGalleryData.m
//  ImgurGallery
//
//  Created by tuhoang on 10/28/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import "ImgurGalleryData.h"

@implementation ImgurGalleryData

@synthesize parsedResponseData;

- (NSURL *)fullSizeImageURLAtIndex:(NSUInteger)index
{
    NSString *urlString = nil;
    
    if ([self isAlbumCoverNullAtIndex:index])
    {
        urlString = [NSString stringWithFormat:@"http://i.imgur.com/%@%@",
                                               [self imageHashAtIndex:index],
                                               [self imageExtensionAtIndex:index]];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"http://i.imgur.com/%@%@",
                                               [self imageAlbumCoverAtIndex:index],
                                               [self imageExtensionAtIndex:index]];
    }
    
    return [NSURL URLWithString:urlString];
}

- (NSString *)imageAlbumCoverAtIndex:(NSUInteger)index
{
    NSDictionary *image = [parsedResponseData objectAtIndex:index];
    return [image objectForKey:@"album_cover"];
}

- (NSString *)imageExtensionAtIndex:(NSUInteger)index
{
    NSDictionary *image = [parsedResponseData objectAtIndex:index];
    NSString *realExtension = [image objectForKey:@"ext"];
    return [realExtension substringToIndex:4];
}

- (NSString *)imageHashAtIndex:(NSUInteger)index
{
    NSDictionary *image = [parsedResponseData objectAtIndex:index];
    return [image objectForKey:@"hash"];
}

- (BOOL)isAlbumCoverNullAtIndex:(NSUInteger)index
{
    NSString *albumCover = [self imageAlbumCoverAtIndex:index];
    
    if ((NSNull *)albumCover == [NSNull null])
        return YES;
    else
        return NO;
}

- (NSUInteger)numberOfImages
{
    return [parsedResponseData count];
}

- (void)requestImgurGalleryData
{
    NSError *error = nil;
    NSData *responseData = [NSData dataWithContentsOfURL:kImgurGalleryURL
                                                 options:NSDataReadingUncached
                                                   error:&error];
    
    if (!error)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        parsedResponseData = [json objectForKey:@"data"];
        NSLog(@"%@", parsedResponseData);
    }
}

- (NSURL *)thumbnailImageURLAtIndex:(NSUInteger)index
{
    NSString *urlString = nil;
    
    if ([self isAlbumCoverNullAtIndex:index])
    {
        urlString = [NSString stringWithFormat:@"http://i.imgur.com/%@s%@",
                     [self imageHashAtIndex:index],
                     [self imageExtensionAtIndex:index]];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"http://i.imgur.com/%@s%@",
                     [self imageAlbumCoverAtIndex:index],
                     [self imageExtensionAtIndex:index]];
    }
    
    return [NSURL URLWithString:urlString];
}

@end
