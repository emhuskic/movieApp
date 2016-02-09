//
//  MOVMovieEntity.h
//  movieApp
//
//  Created by Adis Cehajic on 08/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "FICEntity.h"
@interface MOVMovieEntity : NSObject <FICEntity>

@property (nonatomic, copy) NSURL *sourceImageURL;
@property (nonatomic, strong, readonly) UIImage *sourceImage;
@property (nonatomic, strong, readonly) UIImage *thumbnailImage;
@property (nonatomic, assign, readonly) BOOL thumbnailImageExists;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;

// Methods for demonstrating more conventional caching techniques
- (void)generateThumbnail;
- (void)deleteThumbnail;

@end
