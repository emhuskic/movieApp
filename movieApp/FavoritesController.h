//
//  FavoritesController.h
//  movieApp
//
//  Created by Adis Cehajic on 17/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//
/*
#import <UIKit/UIKit.h>
#import "MOVDetailController.h"
#import "MOVRealmMovie.h"
#import "MOVFavoritesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MOVDetailController.h"
RLM_ARRAY_TYPE(MOVRealmMovie)
@interface FavoritesController : UITableViewController <ControllerToFavoritesDelegate>

@property RLMArray<MOVRealmMovie*><MOVRealmMovie> *movies;
@property (strong, nonatomic) MOVDetailController *controller;
@property (strong, nonatomic) MOVMovie *selectedMovie;
@end
*/
//
//  FavoritesController.h
//  movieApp
//
//  Created by Adis Cehajic on 17/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVDetailController.h"
#import "MOVMovie.h"
#import "MOVRealmMovie.h"
#import "MOVFavoritesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MOVDetailController.h"
RLM_ARRAY_TYPE(MOVRealmMovie)
@interface FavoritesController : UITableViewController <ControllerToFavoritesDelegate>

@property RLMArray<MOVRealmMovie*><MOVRealmMovie> *movies;
@property (strong, nonatomic) MOVDetailController *controller;
@property (strong, nonatomic) MOVMovie *selectedMovie;
- (void) registerAsObserver;
@end
