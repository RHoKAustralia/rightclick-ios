//
//  ImageUtils.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 17/04/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import Foundation

@objc class ImageUtils: NSObject {
    
    class func resizeImage(imageToResize image: UIImage, targetImageSize: CGSize) -> UIImage {
        let size = CGSizeApplyAffineTransform(targetImageSize, CGAffineTransformMakeScale(0.5, 0.5))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    class func saveImage(image: UIImage) -> String {
        let filePath =  fileInDocumentsDirectory(getFileName())
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(filePath, atomically: true)
        print("Saved file at path \(filePath) \(result)")
        return filePath
    }
    
    class func fileInDocumentsDirectory(filename: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    class func getFileName() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return "\(dateFormatter.stringFromDate(NSDate())).png"
    }
}
