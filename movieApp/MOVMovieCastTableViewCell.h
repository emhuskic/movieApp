//
//  MOVMovieCastTableViewCell.h
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVPerson.h"
@class MOVMovieCastTableViewCell;

@protocol MovieCastCollectionCellDelegate <NSObject>
- (void)selectCast:(MOVMovieCastTableViewCell *)view withItem:(MOVPerson *)item;
@end

@interface MOVMovieCastTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MovieCastCollectionCellDelegate> delegate;
@property (strong, nonatomic) NSArray *cast;
@property (strong, nonatomic) MOVPerson *selectedPerson;

-(void) refreshCollection;

@end
