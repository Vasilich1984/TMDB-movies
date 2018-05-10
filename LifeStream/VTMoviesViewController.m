//
//  ViewController.m
//  LifeStream
//
//  Created by Vasily Timofeev on 04.05.2018.
//  Copyright © 2018 Vasily Timofeev. All rights reserved.
//

#import "VTMoviesViewController.h"
#import "VTMoviesCollectionViewCell.h"
#import "VTMovieDescriptionViewController.h"
#import "VTServerManager.h"
#import "UIImageView+AFNetworking.h"

@interface VTMoviesViewController ()

@property (strong, nonatomic) NSMutableArray *listOfMovies;
@property (assign, nonatomic) NSInteger currentMoviesPage;
@property (assign, nonatomic) NSInteger totalMoviesPages;
@property (assign, nonatomic) NSInteger amountOfCellsInRow;

@end

static const CGFloat cellWidth = 400.f;
static const CGFloat cellHeight = 360.f;


@implementation VTMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.currentMoviesPage = 1;
    self.amountOfCellsInRow = self.collectionView.frame.size.width / cellWidth;
    
    [self getListOfMoviesFromServerOnPage:self.currentMoviesPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API

- (void) getListOfMoviesFromServerOnPage: (NSInteger) page{
    
    [[VTServerManager sharedManager] getMoviesWithPage:page
                                            onSuccess:^(NSArray *movies, NSInteger totalPages) {
                                                
                                                NSArray *moviesArray = [self extendListOfMoviesWithEmptyCells:movies forPage:self.currentMoviesPage];
                                                self.listOfMovies = [NSMutableArray arrayWithArray:moviesArray];
                                                
                                                self.totalMoviesPages = totalPages;
                                                
                                                [self.collectionView reloadData];
                                                
                                            } onFailure:^(NSError *error) {
                                                NSLog (@"Request failed with error: %@", [error localizedDescription]);
                                            }];
}

- (NSArray *) extendListOfMoviesWithEmptyCells: (NSArray *) listOfMovies forPage: (NSInteger) page{
    
    VTMovie *movie = [[VTMovie alloc] init];
    movie.isEmptyMovie = YES;
    
    NSMutableArray *arrayOfEmptyMovies = [NSMutableArray array];
    for (int i=0; i<self.amountOfCellsInRow; i++){
        [arrayOfEmptyMovies addObject:movie];
    };
    
    //on the first page we add empty cells at the end
    if (page == 1){
        return [listOfMovies arrayByAddingObjectsFromArray:arrayOfEmptyMovies];
    }
    //on the last page we add empty cells at the beggining
     else if (page == self.totalMoviesPages){
         return [arrayOfEmptyMovies arrayByAddingObjectsFromArray:listOfMovies];
    }
    //for middle cells
     else {
         NSArray *array = [arrayOfEmptyMovies arrayByAddingObjectsFromArray:listOfMovies];
         return [array arrayByAddingObjectsFromArray:arrayOfEmptyMovies];
     }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"amount of movies in collection is %li", [self.listOfMovies count]);
    return [self.listOfMovies count];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"moviesCollectionViewCell";
    VTMoviesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    VTMovie *movie = [self.listOfMovies objectAtIndex:indexPath.row];
    
    //load image into movie cell
    if (!movie.isEmptyMovie){
        NSURL *imageURL = [NSURL URLWithString:movie.movieSmallPosterPath];
        NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
        UIImage *placeHolderImage = [UIImage imageNamed:@"No_image.png"];
    
        __weak VTMoviesCollectionViewCell *weakCell = cell;
        [cell.movieSmallPosterImageView setImageWithURLRequest:imageURLRequest
                                              placeholderImage:placeHolderImage
                                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                      
                                                           weakCell.movieSmallPosterImageView.image = image;
                                                       }
                                                       failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           //Do nothing
                                                       }];
    } else {
       cell.movieSmallPosterImageView.image = [UIImage imageNamed:@"No_image.png"];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

//cell selection
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VTMovie *selectedMovie = [self.listOfMovies objectAtIndex:indexPath.row];
    
    //check for an empty cell
    if (!selectedMovie.isEmptyMovie){
        VTMovieDescriptionViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VTMovieDescriptionViewController"];
        vc.movie = [self.listOfMovies objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//focus
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView {
    
    if (self.currentMoviesPage == 1){
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else {
        return [NSIndexPath indexPathForRow:self.amountOfCellsInRow inSection:0];
    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context {
    VTMovie *nextFocusMovie = [self.listOfMovies objectAtIndex:context.nextFocusedIndexPath.row];
    
    if (!nextFocusMovie.isEmptyMovie){
        return YES;
    } else {
        
        if (context.nextFocusedIndexPath.row < self.amountOfCellsInRow){
            self.currentMoviesPage  = self.currentMoviesPage -1;
        } else {
            self.currentMoviesPage  = self.currentMoviesPage +1;
        }
        
        if (self.currentMoviesPage >0 && self.currentMoviesPage <= self.totalMoviesPages){
            
            [self getListOfMoviesFromServerOnPage:self.currentMoviesPage];
        }
        return NO;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator{
    
    if (context.nextFocusedView) {
        [coordinator addCoordinatedAnimations:^{
            context.nextFocusedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:nil];
    }
    if (context.previouslyFocusedView) {
        [coordinator addCoordinatedAnimations:^{
            context.previouslyFocusedView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(cellWidth, cellHeight);
}

@end
