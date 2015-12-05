//
//  DataService.h
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Lesson;

@interface DataService : NSObject

+ (instancetype)sharedManager;

-(void)addNoteWithText:(NSString *)text
              andImage:(UIImage *)image
             mediaInfo:(NSDictionary *)mediaInfo
                lesson:(Lesson *)lesson;

-(void)generatePDFWithLesson:(Lesson *)lesson;
- (NSString *)getPDFPath;
@end
