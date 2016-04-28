//
//  NewNoteImageViewController.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 2/04/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit
import Eureka

class NewNoteImageViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var noteImageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.Camera) ? .Camera : .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension NewNoteImageViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            noteImageView.image = chosenImage
            
            // Annotate the image
            let annotationViewController = storyboard?.instantiateViewControllerWithIdentifier(
                "AnnotationViewController") as? AnnotationViewController
            annotationViewController?.imageToAnnotate = chosenImage
            annotationViewController?.delegate = self
            navigationController?.pushViewController(annotationViewController!, animated: true)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension NewNoteImageViewController: AnnotationViewControllerDelegate {
    
    func didAnnotateImage(annotatedImage: UIImage) {
        ImageUtils.saveImage(annotatedImage)
        self.noteImageView.image = annotatedImage
    }
}
