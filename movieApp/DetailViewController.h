//
//  DetailViewController.h
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"
@interface DetailViewController : UIViewController

@property (strong, nonatomic) MOVMovie *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

