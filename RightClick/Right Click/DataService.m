//
//  DataService.m
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import "DataService.h"
#import "Lesson.h"
#import "Note.h"

@implementation DataService

+ (instancetype)sharedManager {
    static DataService *sharedDataService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataService = [[self alloc] init];
    });
    return sharedDataService;
}

-(void)addNoteWithText:(NSString *)text
              andImage:(UIImage *)image
             mediaInfo:(NSDictionary *)mediaInfo
                lesson:(Lesson *)lesson {
    
    Note *note = [Note new];
    
    if (text) {
        note.instruction = text;
    }
    
    if (image) {
        note.imagePath = [self saveImage:image mediaInfo:mediaInfo];
        NSLog(@"Image Path %@", note.imagePath);
    }
    
    NSLog(@"Added note to lesson");
    [lesson.notes addObject:note];
}

-(NSString *)saveImage:(UIImage *)imageToSave mediaInfo:(NSDictionary *)mediaInfo {
    
    imageToSave = [self scaleImage:imageToSave toSize:CGSizeMake(640, 480)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *imageName = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:@".png"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    //extracting image from the picker and saving it
    NSString *mediaType = [mediaInfo objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *editedImage = [mediaInfo objectForKey:UIImagePickerControllerEditedImage];
        NSData *webData = UIImagePNGRepresentation(editedImage);
        [webData writeToFile:imagePath atomically:YES];
    }
    
    return imagePath;
}

- (UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
