//
//  MOVRealmGenre.h
//  movieApp
//
//  Created by Adis Cehajic on 22/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <Realm/Realm.h>
#import "MOVGenre.h"
@class MOVGenre;
@interface MOVRealmGenre : RLMObject

@property NSNumber<RLMDouble> *genreID;
@property  NSString *name;

- (id) initWithMOVGenre:(NSNumber *)gen;

@end
