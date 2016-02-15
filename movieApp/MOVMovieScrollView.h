//
//  MOVMovieScrollView.h
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOVMovieScrollView : UIScrollView<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *cast;
@end
