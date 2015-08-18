//
//  GalleryCell.h
//  ImgurGallery
//
//  Created by tuhoang on 10/28/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *cellHighlight;

@end
