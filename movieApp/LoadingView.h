//
//  LoadingView.h
//  movieApp
//
//  Created by Adis Cehajic on 25/03/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIImageView

+ (void)rotateLayerInfinite:(CALayer *)layer;
+ (void)stopRotateLayerInfinite:(CALayer *)layer;
@end
