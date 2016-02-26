//
//  MOVCastMovieTableViewCell.h
//  movieApp
//
//  Created by Adis Cehajic on 16/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"
#import <SDWebImage/UIImageView+WebCache.h>
@class MOVCastMovieTableViewCell;

@protocol CastMovieCollectionCellDelegate <NSObject>
- (void)selectCastMovie:(MOVCastMovieTableViewCell *)view withItem:(MOVMovie *)item;
@end

@interface MOVCastMovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id <CastMovieCollectionCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) NSArray *movies;

-(void) refreshCollection;
@end
