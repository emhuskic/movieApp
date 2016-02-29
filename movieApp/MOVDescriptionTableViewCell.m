//
//  MOVDescriptionTableViewCell.m
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVDescriptionTableViewCell.h"

@implementation MOVDescriptionTableViewCell

- (void) addSelector
{
    [self.descriptionButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)layoutSubviews
{
  //  CGRect labelFrame = self.descriptionLabel.frame;
    //labelFrame.size.height = 135.0f;//self.frame.size.height - 55.0f;
    //self.descriptionLabel.frame = labelFrame;
    
 //   CGRect buttonFrame = self.descriptionButton.frame;
//    buttonFrame.origin.y = labelFrame.origin.y+labelFrame.size.height+10.0f;
  //  self.descriptionButton.frame = buttonFrame;
}
- (void)infoButtonTapped:(UIButton *)sender
{
//     NSLog(@"Pressed");
    // Assuming there is only one constraint. If not, assign it to another property
    // I put 500, but, again, real size rounded to line height should be here
//    self.descriptionLabel.constraints[0].constant = 500;
//    [UIView animateWithDuration:1 animations:^{
        // Layouting superview, as its frame can be updated because of a new size
//        [self.descriptionLabel.superview layoutIfNeeded];
//    }];
}
@end
