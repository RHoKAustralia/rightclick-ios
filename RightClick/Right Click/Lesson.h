//
//  Lesson.h
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lesson : NSObject
@property(nonatomic, strong)NSString *lessonTitle;
@property(nonatomic, strong)NSString *tutorName;
@property(nonatomic, strong)NSString *tutorEmail;
@property(nonatomic, strong)NSString *studentName;
@property(nonatomic, strong)NSString *studentEmail;
@property(nonatomic, strong)NSString *deviceType;
@property(nonatomic, strong)NSMutableArray *notes;
@property(nonatomic, strong)NSDate *startDate;
@property(nonatomic, strong)NSDate *endDate;
@end