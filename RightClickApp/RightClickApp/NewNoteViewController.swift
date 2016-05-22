//
//  NewNoteViewController.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 2/04/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit
import Eureka

class NewNoteViewController: FormViewController {
    
    static let newNoteImageSegue = "NewNoteImageSegue"
    var imageAdded = false
    var addNoteImageRow: ButtonRow!
    
    var removeNoteImageRow: ButtonRow!
    var noteImageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "new-note.form.title".localized
        
        addNoteForm()
    }
    
    @IBAction func saveNote(sender: AnyObject) {
        let formValues = form.values(includeHidden: true)
        let noteText = formValues["Note Text"] as? String ?? ""
        
        if valid(noteText, noteImagePath: noteImageName) {
            // Save Note
            DataService.sharedInstance.createNote(noteText, noteImageName: noteImageName)
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func valid(noteText: String, noteImagePath: String) -> Bool {
        var valid = true
        
        if noteText.isEmpty && noteImagePath.isEmpty {
            let validationMessage = "\("new-note.form.validation".localized)"
            let validationAlert = UIAlertController(title: "alert.error.title".localized,
                                                    message: validationMessage, preferredStyle: .Alert)
            validationAlert.addAction(UIAlertAction(title: "alert.ok".localized,
                style: .Default, handler: nil))
            
            presentViewController(validationAlert, animated: true, completion: nil)
            
            valid = false
        }
        
        return valid
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
    }
    
    func addNoteForm() {
        let section = Section("new-note.form.section.note".localized)
        
        section.append(TextRow("Note Text") {
            $0.title = "new-note.form.noteText".localized })
        
        addNoteImageRow = ButtonRow("Note Image") {
            $0.title = "new-note.form.noteImage".localized
            $0.hidden = Condition.Function(["RemoveImage"]) { form in
                return self.imageAdded
            }
            $0.presentationMode = .SegueName(segueName: NewNoteViewController.newNoteImageSegue, completionCallback: nil)}
        
        section.append(addNoteImageRow)
        
        removeNoteImageRow = ButtonRow("Remove Image") {
            $0.title = "new-note.form.removeImage".localized
            $0.onCellSelection { cell, row in
                self.removeNoteImage()
            }
            $0.hidden = Condition.Function(["RemoveImage"]) { form in
                return !self.imageAdded
            }}
        
        // Show this row only if an Image is added
        section.append(removeNoteImageRow)
        
        form.append(section)
    }
    
    func removeNoteImage() {
        imageAdded = false
        noteImageName = ""
        evaluvateFormCondtions()
    }
    
    func evaluvateFormCondtions() {
        addNoteImageRow.evaluateHidden()
        removeNoteImageRow.evaluateHidden()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == NewNoteViewController.newNoteImageSegue {
            let imageVc = segue.destinationViewController as? NewNoteImageViewController
            imageVc?.delegate = self
        }
    }
}

extension NewNoteViewController: NewNoteImageViewControllerDelegate {
    
    func didAddImage(fileName: String) {
        noteImageName = fileName
        imageAdded = true
        evaluvateFormCondtions()
    }
    
    func didDismissImagePicker() {
        removeNoteImage()
    }
}