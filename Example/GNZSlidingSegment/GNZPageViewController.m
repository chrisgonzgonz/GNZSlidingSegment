//
//  GNZPageViewController.m
//  GNZSlidingSegment
//
//  Created by Chris Gonzales on 11/18/15.
//  Copyright © 2015 Chris Gonzales. All rights reserved.
//

#import "GNZPageViewController.h"

@interface GNZPageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;

@end

@implementation GNZPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pageNumberLabel.text = [NSString stringWithFormat:@"Page Number: %lu", self.pageNumber];
}

- (void)setPageNumber:(NSUInteger)pageNumber {
    _pageNumber = pageNumber;
    self.pageNumberLabel.text = [NSString stringWithFormat:@"Page Number: %lu", _pageNumber];
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
