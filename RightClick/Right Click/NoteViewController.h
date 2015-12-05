//
//  NoteViewController.h
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteViewControllerDelegate <NSObject>
@required
-(void)didEnterTextNote:(NSString *)text;
@end

@interface NoteViewController : UIViewController
@property(nonatomic, weak)id<NoteViewControllerDelegate> delegate;
@end
