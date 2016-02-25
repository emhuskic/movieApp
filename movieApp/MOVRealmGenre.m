//
//  MOVRealmGenre.m
//  movieApp
//
//  Created by Adis Cehajic on 22/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVRealmGenre.h"

@implementation MOVRealmGenre

- (id) initWithMOVGenre:(NSNumber *)gen
{
    self=[super init];
    
       self.genreID=gen;
       return self;
}
@end
