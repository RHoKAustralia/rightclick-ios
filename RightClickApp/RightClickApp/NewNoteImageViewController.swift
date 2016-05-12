//
//  NewNoteImageViewController.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 2/04/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit
import Eureka

protocol NewNoteImageViewControllerDelegate: NSObjectProtocol {
    func didAddImage(imagePath: String)
    func didDismissImagePicker()
}

class NewNoteImageViewController: UIViewController, UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    weak var delegate: NewNoteImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.Camera) ? .Camera : .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}

extension NewNoteImageViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
        delegate?.didDismissImagePicker()
        navigationController?.popViewControllerAnimated(true)
    }
}

extension NewNoteImageViewController: AnnotationViewControllerDelegate {
    func didAnnotateImage(annotatedImage: UIImage) {
        delegate?.didAddImage(ImageUtils.saveImage(annotatedImage))
        navigationController?.popViewControllerAnimated(true)
    }
}
