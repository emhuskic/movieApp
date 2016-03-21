

#import <UIKit/UIKit.h>
#import "MOVMovieStarRateView.h"
#import "MOVMovie.h"
#import "MOVMovieCastTableViewCell.h"
#import "MasterViewController.h"
#import "MOVDescriptionTableViewCell.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
@class MOVDetailController;

@protocol ControllerToFavoritesDelegate <NSObject>
- (void)updateFavorites:(MOVDetailController *)view;
@end




@interface MOVDetailController : UITableViewController <MovieCastCollectionCellDelegate, UITabBarControllerDelegate, MasterDetailDelegate>


@property (nonatomic, weak) id <ControllerToFavoritesDelegate> delegate;
@property (strong, nonatomic) MOVMovie *detailItem;
@property (strong, nonatomic) MOVMovie *movie;
@property SLComposeViewController *mySLComposerSheet;
@property (strong, nonatomic) NSArray *genres;
- (void)setMovie:(MOVMovie *)movie;

@end
