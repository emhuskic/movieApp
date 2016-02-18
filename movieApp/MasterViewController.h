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
#import "MOVMovieTableViewCell.h"
@class DetailViewController;
@class MasterViewController;

@protocol MasterDetailDelegate <NSObject>
- (void)refreshDetail:(MasterViewController *)view;
@end

@interface MasterViewController : UITableViewController <MovieCollectionCellDelegate>
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, weak) id <MasterDetailDelegate> delegate;
@property (strong, nonatomic) MOVMovie *movie;
@end

