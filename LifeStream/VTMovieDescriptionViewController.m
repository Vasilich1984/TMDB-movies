//
//  VTMovieDescriptionViewController.m
//  LifeStream
//
//  Created by Vasily Timofeev on 08.05.2018.
//  Copyright © 2018 Vasily Timofeev. All rights reserved.
//

#import "VTMovieDescriptionViewController.h"
#import "UIImageView+AFNetworking.h"

@interface VTMovieDescriptionViewController ()

@end

@implementation VTMovieDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieTitlelabel.text = self.movie.movieTitle;
    self.movieDescriptionLabel.text = self.movie.movieDescription;
    
    [self loadMovieBigPosterImage];
}

- (void) loadMovieBigPosterImage {
    
    [self.activityIndicator startAnimating];
    
    NSURL *imageURL = [NSURL URLWithString:self.movie.movieBigPosterPath];
    NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
    UIImage *placeHolderImage = [UIImage imageNamed:@"No_image.png"];
    
    __weak VTMovieDescriptionViewController *weakSelf = self;
    [self.movieBigPosterImageView setImageWithURLRequest:imageURLRequest
                                          placeholderImage:placeHolderImage
                                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                       
                                                       weakSelf.movieBigPosterImageView.image = image;
                                                       [weakSelf.activityIndicator stopAnimating];
                                                   }
                                                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                       
                                                       weakSelf.movieBigPosterImageView.image = placeHolderImage;
                                                       [weakSelf.activityIndicator stopAnimating];
                                                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
