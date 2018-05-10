//
//  VTServerManager.m
//  LifeStream
//
//  Created by Vasily Timofeev on 08.05.2018.
//  Copyright © 2018 Vasily Timofeev. All rights reserved.
//

#import "VTServerManager.h"
#import "VTAPIConstants.h"
#import "AFNetworking.h"

//static const NSInteger amountOfCachedPages = 3;

@interface VTServerManager ()

@property (assign, nonatomic) NSInteger amountOfLoadedPages;
@property (strong, nonatomic) NSMutableArray *arrayOfCachedMoviePages;

@end


@implementation VTServerManager

+ (VTServerManager *) sharedManager {
    
    static VTServerManager * serverManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverManager = [[VTServerManager alloc] init];
    });
    
    return serverManager;
}

- (void) getMoviesWithPage: (NSInteger) page
                 onSuccess:(void(^)(NSArray *movies, NSInteger totalPages)) success
                 onFailure:(void(^)(NSError *error)) failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                SERVER_REQUEST_API_KEY_FIELD_VALUE,     SERVER_REQUEST_API_KEY_FIELD_NAME,
                                SERVER_REQUEST_LANGUAGE_FIELD_VALUE,    SERVER_REQUEST_LANGUAGE_FIELD_NAME,
                                SERVER_REQUEST_SORT_BY_FIELD_VALUE,     SERVER_REQUEST_SORT_BY_FIELD_NAME,
                                @(page),                                SERVER_REQUEST_PAGE_FIELD_NAME,
                                nil];
    
    [manager GET:GET_SERVER_REQUEST_MOVIES_DISCOVER
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog (@"JSON: %@", responseObject);
             if (responseObject && success) {
                
                 NSDictionary * responseDictionary = (NSDictionary *) responseObject;
                 
                 NSArray *moviesDictsArray = [responseDictionary objectForKey:SERVER_RESPONSE_RESULTS_FIELD_NAME];
                 
                 NSMutableArray *moviesArray = [NSMutableArray array];
                 
                 for (NSDictionary * dict in moviesDictsArray){
                     
                     VTMovie *movie = [[VTMovie alloc] initFromResponse:dict];
                     [moviesArray addObject:movie];
                 }
                 
                 NSInteger totalPages = [[responseDictionary objectForKey:SERVER_RESPONSE_TOTAL_PAGES_FIELD_NAME] integerValue];
                 success (moviesArray, totalPages);
                 
             } else if (!responseObject && success) {
                
                 success (nil, 0);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 failure (error);
             }
         }];
}

@end
