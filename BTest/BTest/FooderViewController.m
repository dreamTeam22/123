//
//  FooderViewController.m
//  BTest
//
//  Created by lanouhn on 16/1/29.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "FooderViewController.h"
#import "CustomeCollectionViewLayout.h"
#import "FooderCollectionCell.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface FooderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CustomeCollectionViewLayoutDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *foodCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionb;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sectionSegment;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@end

@implementation FooderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    customecollection
    ((CustomeCollectionViewLayout *)self.foodCollection.collectionViewLayout).layoutDelegate = self;
    self.foodCollection.delegate = self;

    
    [self.sectionSegment addTarget:self action:@selector(handleSegment:) forControlEvents:UIControlEventValueChanged];
    
    
    
}

- (void)handleSegment:(id)sender {

    UISegmentedControl *seg = (UISegmentedControl *)sender;
    NSInteger segIndex = (NSInteger)seg.selectedSegmentIndex;
    [self.ScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * segIndex * 1.0,0) animated:YES];

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 20;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FooderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    cell.titleLabel.text = @"test";
    
    return cell;

}


#pragma mark - CustomeCollectionViewLayoutDelegate -
- (NSInteger)numberOfColumnWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(CustomeCollectionViewLayout *)collectionViewLayout {
   
    return 3;

}

- (CGFloat)marginOfCellWithCollectionView:(UICollectionView *)collectionView
                     collectionViewLayout:( CustomeCollectionViewLayout *)collectionViewLayout {
    
    return 10;
}

- (CGFloat)minHeightOfCellWithCollectionView:(UICollectionView *)collectionView
                        collectionViewLayout:( CustomeCollectionViewLayout *)collectionViewLayout {
    return 80;
}

- (CGFloat)maxHeightOfCellWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(CustomeCollectionViewLayout *)collectionViewLayout {
    
    return  200;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
