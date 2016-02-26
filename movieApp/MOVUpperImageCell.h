//
//  MOVUpperImageCell.h
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOVUpperImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *favorite;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end
