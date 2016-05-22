//
//  NoteCollectionViewHeader.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 22/05/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit

class NoteCollectionViewHeader: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    static var reuseString = "NoteCollectionViewHeaderReuseIdentifier"

    override var reuseIdentifier: String? {
        return NoteCollectionViewHeader.reuseString
    }
}