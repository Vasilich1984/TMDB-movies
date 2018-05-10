//
//  VTServerManager.h
//  LifeStream
//
//  Created by Vasily Timofeev on 08.05.2018.
//  Copyright © 2018 Vasily Timofeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTMovie.h"

@interface VTServerManager : NSObject

+ (VTServerManager *) sharedManager;

- (void) getMoviesWithPage: (NSInteger) page
                onSuccess:(void(^)(NSArray *movies, NSInteger totalPages)) success
                onFailure:(void(^)(NSError *error)) failure;

@end
