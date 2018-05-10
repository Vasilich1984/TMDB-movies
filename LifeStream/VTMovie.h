//
//  VTMovie.h
//  LifeStream
//
//  Created by Vasily Timofeev on 08.05.2018.
//  Copyright © 2018 Vasily Timofeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTMovie : NSObject

@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *movieDescription;
@property (strong, nonatomic) NSString *movieSmallPosterPath;
@property (strong, nonatomic) NSString *movieBigPosterPath;

@property (assign, nonatomic) BOOL isEmptyMovie;

- (instancetype)initFromResponse: (NSDictionary *) response;

@end
