//
//  GalleryViewController.m
//  ImgurGallery
//
//  Created by tuhoang on 10/28/12.
//  Copyright (c) 2012 tuanhoang. All rights reserved.
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

@synthesize igd, refreshControl;

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
    
    // Register the GalleryCell class for use in creating new collection view cells.
    [self.collectionView registerClass:[GalleryCell class] forCellWithReuseIdentifier:@"GalleryCellId"];
    
    // Add a UIRefreshControl to the collection view.
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to refresh..."];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    // Create an ImgurGalleryData object and fetch the Imgur gallery data.
    igd = [[ImgurGalleryData alloc] init];
    [igd requestImgurGalleryData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRefresh
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    
    // Initialize an operation queue.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // Imgur gallery data request block operation.
    NSBlockOperation *getImgurGalleryDataOp = [NSBlockOperation blockOperationWithBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [igd requestImgurGalleryData];
    }];
    
    // Add the getImgurGalleryDataOp block operation to the operation queue.
    [queue addOperation:getImgurGalleryDataOp];
    
    // Collection view update block operation.
    NSBlockOperation *updateCollectionView = [NSBlockOperation blockOperationWithBlock:^{
        [self.collectionView reloadData];
        [refreshControl endRefreshing];
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to refresh..."];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    // Update the collection view only after the Imgur gallery data request finishes.
    [updateCollectionView addDependency:getImgurGalleryDataOp];
    
    // Add the updateCollectionView block operation to the main queue.
    [[NSOperationQueue mainQueue] addOperation:updateCollectionView];
}

// Returns the number of items in the section in the Collection View.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [igd numberOfImages];
}

// Returns a GalleryCell object with the thumbnail image at the indexPath node.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a GalleryCell with a black border.
    GalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_frame.png"]];
    
    // Create and add the thumbnail image subview to the GalleryCell.
    cell.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 92, 92)];
    [cell.imageView setImageWithURL:[igd thumbnailImageURLAtIndex:indexPath.item] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [cell.contentView addSubview:cell.imageView];
    
    // Create and add the cell highlight subview to the GalleryCell.
    cell.cellHighlight = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 92, 92)];
    cell.cellHighlight.backgroundColor = [UIColor blackColor];
    cell.cellHighlight.alpha = 0.0f;
    [cell.contentView addSubview:cell.cellHighlight];
    
    return cell;
}

// Highlights the GalleryCell.
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCell *cell = (GalleryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.cellHighlight.alpha = 0.5f;
}

// Unhighlights the GalleryCell.
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCell *cell = (GalleryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.5 animations:^{
        cell.cellHighlight.alpha = 0.0f;
    }];
}

// Pushes the FullSizeImageViewController to the navigation controller on the GalleryCell selection.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Highlight the selected GalleryCell.
    GalleryCell *cell = (GalleryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.cellHighlight.alpha = 0.5f;
    
    // Get the FullSizeImageViewController.
    FullSizeImageViewController *fsivc = [self.storyboard instantiateViewControllerWithIdentifier:@"fsivcStoryboardId"];
    
    // Set the FullSizeImageViewController imageURL property to the full size image URL.
    fsivc.imageURL = [igd fullSizeImageURLAtIndex:indexPath.item];
    
    // Set the FullSizeImageViewController title to the image filename.
    NSString *imageFilename = nil;
    NSString *imageExt = [igd imageExtensionAtIndex:indexPath.item];
    
    if ([igd isAlbumCoverNullAtIndex:indexPath.item])
        imageFilename = [igd imageHashAtIndex:indexPath.item];
    else
        imageFilename = [igd imageAlbumCoverAtIndex:indexPath.item];
    
    fsivc.title = [NSString stringWithFormat:@"%@%@", imageFilename, imageExt];
    
    // Push the FullSizeImageViewController on the navigation controller stack.
    [self.navigationController pushViewController:fsivc animated:YES];
    
    // Unhighlight the selected GalleryCell.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        cell.cellHighlight.alpha = 0.0f;
    });
}

@end
