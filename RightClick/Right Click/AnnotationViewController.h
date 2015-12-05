//
//  JotViewController.h
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnnotationViewControllerDelegate <NSObject>
@required
-(void)didAnnotateImage:(UIImage *)uiImage;
@end

@interface AnnotationViewController : UIViewController
@property(nonatomic, strong)UIImage *imageToAnnotate;
@property(nonatomic, weak)id<AnnotationViewControllerDelegate> delegate;
@end
