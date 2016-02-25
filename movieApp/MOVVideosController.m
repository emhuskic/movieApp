//
//  MOVVideosController.m
//  movieApp
//
//  Created by Adis Cehajic on 22/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVVideosController.h"

@implementation MOVVideosController

- (void) viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    self.nameLabel.text=self.video.name;
    if(self.path)
    [self.playerView loadWithVideoId:self.path];
}
@end
