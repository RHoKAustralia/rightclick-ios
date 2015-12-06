//
//  Note.h
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Note : NSObject
@property(nonatomic, strong)NSString *instruction;
@property(nonatomic, strong)NSString *imagePath;
@property(nonatomic, strong)NSString *imageBase64;
@property(nonatomic, strong)UIImage *image;
@end
