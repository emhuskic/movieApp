//
//  MOVCastController.h
//  movieApp
//
//  Created by Adis Cehajic on 16/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MOVPerson.h"
#import <Restkit/Restkit.h>
#import "MOVMovie.h"
#import "MOVCastMovieTableViewCell.h"
@interface MOVCastController : UITableViewController <CastMovieCollectionCellDelegate>
@property (nonatomic) NSNumber *persID;
@property (strong, nonatomic) MOVPerson *person;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *movies;
- (void) loadMovie;
@end
