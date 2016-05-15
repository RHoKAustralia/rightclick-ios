//
//  NoteViewController.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 27/03/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "notes.form.title".localized
    }
    
    @IBAction func prepareForUnwind(segue :UIStoryboardSegue) {
    
    }
}
