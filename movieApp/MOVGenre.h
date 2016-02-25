//
//  MOVGenre.h
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOVRealmGenre.h"
@class MOVRealmGenre;
@interface MOVGenre :NSObject
@property (nonatomic) NSNumber *genreID;
@property (strong, nonatomic) NSString *name;
- (id) initWithRLMGenre:(MOVRealmGenre *)RLMgen;
@end
