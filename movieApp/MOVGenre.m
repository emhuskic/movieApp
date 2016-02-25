//
//  MOVGenre.m
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVGenre.h"

@implementation MOVGenre


- (id) initWithRLMGenre:(MOVRealmGenre *)RLMgen
{
    self=[super init];
    self.genreID=RLMgen.genreID;
    self.name=RLMgen.name;
    return self;
}
@end
