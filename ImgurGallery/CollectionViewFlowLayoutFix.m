//
//  CollectionViewFlowLayoutFix.m
//  ImgurGallery
//
//  Created by tuhoang on 11/19/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import "CollectionViewFlowLayoutFix.h"

@implementation CollectionViewFlowLayoutFix

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *unfilteredPoses = [super layoutAttributesForElementsInRect:rect];
    id filteredPoses[unfilteredPoses.count];
    NSUInteger filteredPosesCount = 0;
    
    for (UICollectionViewLayoutAttributes *pose in unfilteredPoses)
    {
        CGRect frame = pose.frame;
        
        if (frame.origin.x + frame.size.width <= rect.size.width)
            filteredPoses[filteredPosesCount++] = pose;
    }
    
    return [NSArray arrayWithObjects:filteredPoses count:filteredPosesCount];
}

@end
