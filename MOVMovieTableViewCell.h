
//
//  MOVMovieTableViewCell.h
//
//
//  Created by Adis Cehajic on 05/02/16.
//
//

#import <UIKit/UIKit.h>
#import "MOVMovieCollectionViewCell.h"
#import "MOVMovie.h"

@class MOVMovieTableViewCell;

@protocol MovieCollectionCellDelegate <NSObject>
- (void)selectMovie:(MOVMovieTableViewCell *)view withItem:(MOVMovie *)item;
-(void)loadMoreMovies:(MOVMovieTableViewCell *)view type:(NSString *)type;
@end



@interface MOVMovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) id <MovieCollectionCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) NSMutableArray *movies;
@property (strong, nonatomic) MOVMovie *selectedMovie;
@property (strong, nonatomic) NSArray *photos;
@property (nonatomic, copy) NSString *imageFormatName;


//- (id)initWithMovie:(MOVMovie *)movie;


@end
