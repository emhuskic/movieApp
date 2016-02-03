//
//  MasterViewController.h
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "MOVMovie.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewCell *collectionViewCell;

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

