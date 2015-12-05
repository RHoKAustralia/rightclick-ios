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
#import "JLPDFGenerator.h"
#import "Config.h"

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
        // Scale Image
        image = [self scaleImage:image toSize:CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT)];
        
        // Save Scaled Image
        note.imagePath = [self saveImage:image mediaInfo:mediaInfo];
        note.image = image;
        NSLog(@"Image Path %@", note.imagePath);
    }
    
    NSLog(@"Added note to lesson");
    
    [lesson.notes addObject:note];
}

-(NSString *)saveImage:(UIImage *)imageToSave mediaInfo:(NSDictionary *)mediaInfo {
    
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

-(void)generatePDFWithLesson:(Lesson *)lesson {
    
    UIFont *font = [UIFont systemFontOfSize:16];
    UIColor *fontColor = [UIColor blackColor];
    
    JLPDFGenerator *generator = [JLPDFGenerator new];
    [generator setupPDFDocumentNamed:DOCUMENT_NAME withSize:kSizeA4Portrait];
    [generator beginPDFPage];
    
    int yAxix = 100;
    
    @autoreleasepool {
        
        for (int i = 0; i < lesson.notes.count; i++) {
            
            Note *note = [lesson.notes objectAtIndex:i];
            
            if ([note.instruction length] != 0) {
                
                // Add index number
                NSString *instruction = [NSString stringWithFormat:@"%d. %@", i + 1, note.instruction];
                
                CGRect textRect = CGRectMake(100, yAxix, 100, 100);
                [generator addText:instruction
                         withFrame:textRect
                          withFont:font
                         withColor:fontColor
                     textAlignment:NSTextAlignmentLeft
                 verticalAlignment:NSVerticalAlignmentTop];
                yAxix += 20;
            }else if (note.image != nil){
                CGRect imageRect = CGRectMake(100, yAxix, IMAGE_WIDTH / 2, IMAGE_HEIGHT / 2);
                [generator addImage:note.image inRect:imageRect];
                yAxix += 20 + IMAGE_HEIGHT / 2;
            }
            
            // Reset Y Axis and start a new page
            if (yAxix >= 820) {
                [generator addPageToPDF];
                yAxix = 100;
            }
        }
        
    }
    
    [generator finishPDF];
}

- (NSString *)getPDFPath {
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", DOCUMENT_NAME];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return  [documentsDirectory stringByAppendingPathComponent:newPDFName];
}

@end
