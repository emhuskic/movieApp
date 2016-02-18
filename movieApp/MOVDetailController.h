//
//  MOVDetailController.h
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovieStarRateView.h"
#import "MOVMovie.h"
#import "MOVMovieCastTableViewCell.h"
#import "MasterViewController.h"
@class MOVDetailController;

@protocol ControllerToFavoritesDelegate <NSObject>
- (void)updateFavorites:(MOVDetailController *)view;
@end


@interface MOVDetailController : UITableViewController <MovieCastCollectionCellDelegate, UITabBarControllerDelegate, MasterDetailDelegate>


@property (nonatomic, weak) id <ControllerToFavoritesDelegate> delegate;
@property (strong, nonatomic) MOVMovie *detailItem;
@property (strong, nonatomic) MOVMovie *movie;

@end
