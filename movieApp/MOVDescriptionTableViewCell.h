//
//  MOVDescriptionTableViewCell.h
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVDetailController.h"
@class MOVDescriptionTableViewCell;


@interface MOVDescriptionTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *videosButton;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *descriptionButton;
@property (weak, nonatomic) IBOutlet UIButton *smallVideosButton;
@property (weak, nonatomic) IBOutlet UIButton *facebook;

-(void) addSelector;
@end
