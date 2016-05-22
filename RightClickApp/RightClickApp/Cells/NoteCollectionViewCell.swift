//
//  NoteCollectionViewCell.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 22/05/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import Foundation

class NoteCollectionViewCell : UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var reusueString = "NoteCollectionViewCellReuseIdentifier"
    
    override var reuseIdentifier: String? {
        return NoteCollectionViewCell.reusueString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0.0
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.cancelsTouchesInView = false
        
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func onLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .CurveEaseOut, animations: {
                self.transform = CGAffineTransformMakeScale(0.9, 0.9)
                self.overlayView.alpha = 0.35
                }, completion: nil)
        default:
            UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .CurveEaseOut, animations: {
                self.transform = CGAffineTransformIdentity
                self.overlayView.alpha =  0.0
                }, completion: nil)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}