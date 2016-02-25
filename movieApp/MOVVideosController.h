//
//  MOVVideosController.h
//  movieApp
//
//  Created by Adis Cehajic on 22/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YTPlayerView.h>
#import "MOVVideo.h"
@interface MOVVideosController : UIViewController
@property (nonatomic, strong) NSString *path;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (strong, nonatomic) MOVVideo *video;
@end
