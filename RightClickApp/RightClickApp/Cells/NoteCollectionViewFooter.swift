//
//  NoteCollectionViewFooter.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 22/05/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit

class NoteCollectionViewFooter: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseString = "NoteCollectionViewFooterReuseIdentifier"
    
    override var reuseIdentifier: String? {
        return NoteCollectionViewFooter.reuseString
    }
}