//
//  Lesson.h
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lesson : NSObject
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *mentorEmail;
@property(nonatomic, strong)NSString *menteeEmail;
@property(nonatomic, strong)NSMutableArray *notes;
@property(nonatomic, strong)NSDate *startDate;
@property(nonatomic, strong)NSDate *endDate;
@end