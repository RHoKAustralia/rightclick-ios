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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "new-note.form.title".localized
        
        addNoteForm()
    }
    
    func addNoteForm() {
        let section = Section("new-note.form.section.note".localized)
        
        section.append(TextRow("Note Text") {
            $0.title = "new-note.form.noteText".localized })
        
        section.append(ButtonRow("Button Row") {
            $0.title = "new-note.form.noteImage".localized
            $0.presentationMode = .SegueName(segueName: "NewNoteImageSegue", completionCallback: nil)})
        
        form.append(section)
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
