//
//  NoteViewController.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 27/03/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit
import FMMosaicLayout

class NotesViewController: UIViewController {
    
    let numberOfColumns = 1
    let footerHeight: CGFloat = 44.0
    var notes = [Note]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "notes.form.title".localized
        
//        collectionView.registerNib(UINib(nibName: "NoteCollectionViewHeaderView", bundle: nil),
//                                   forCellWithReuseIdentifier: NoteCollectionViewHeader.reuseString)
//        
//        collectionView.registerNib(UINib(nibName: "NoteCollectionViewFooterView", bundle: nil),
//                                   forCellWithReuseIdentifier: NoteCollectionViewFooter.reuseString)
        adjustContentInsets()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let lessonNotes = DataService.sharedInstance.lesson?.notes {
            notes = lessonNotes
            collectionView.reloadData()
        }
    }
    
    func adjustContentInsets() {
        let insets = UIEdgeInsetsMake(UIApplication.sharedApplication().statusBarFrame.size.height, 0, 0, 0)
        self.collectionView.contentInset = insets
        self.collectionView.scrollIndicatorInsets = insets
    }
    
    @IBAction func prepareForUnwind(segue :UIStoryboardSegue) {}
}

//MARK: FMMosaicLayoutDelegate

extension NotesViewController: FMMosaicLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView!,
                        layout collectionViewLayout: FMMosaicLayout!, numberOfColumnsInSection section: Int) -> Int {
        return numberOfColumns
    }
    
    func collectionView(collectionView: UICollectionView!, layout
        collectionViewLayout: FMMosaicLayout!, mosaicCellSizeForItemAtIndexPath indexPath: NSIndexPath!) -> FMMosaicCellSize {
        return (indexPath.item % 12 == 0) ? FMMosaicCellSize.Big : FMMosaicCellSize.Small
    }
    
    func collectionView(collectionView: UICollectionView!, layout
        collectionViewLayout: FMMosaicLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }
    
    func collectionView(collectionView: UICollectionView!, layout
        collectionViewLayout: FMMosaicLayout!, interitemSpacingForSectionAtIndex section: Int) -> CGFloat {
         return 2.0
    }
    
    func collectionView(collectionView: UICollectionView!, layout
        collectionViewLayout: FMMosaicLayout!, heightForHeaderInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    func collectionView(collectionView: UICollectionView!, layout
        collectionViewLayout: FMMosaicLayout!, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    func headerShouldOverlayContentInCollectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        return true
    }
    
    func footerShouldOverlayContentInCollectionView(collectionView: UICollectionView!, layout collectionViewLayout: FMMosaicLayout!) -> Bool {
        return true
    }
}

// MARK: UICollectionViewDataSource

extension NotesViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let noteCell = collectionView.dequeueReusableCellWithReuseIdentifier(
            NoteCollectionViewCell.reusueString, forIndexPath: indexPath) as? NoteCollectionViewCell {
            let note = notes[indexPath.row]
            noteCell.titleLabel.text = note.noteText
            noteCell.imageView.image = ImageUtils.imageWithPath(note.noteImageName)
            
            cell = noteCell
        }
        
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var reusuableView = UICollectionReusableView()
//        
//        if kind == UICollectionElementKindSectionHeader {
//            let reuseString = NoteCollectionViewHeader.reuseString
//            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
//                                                                                   withReuseIdentifier: reuseString,
//                                                                                   forIndexPath: indexPath) as? NoteCollectionViewHeader
//            //headerView?.titleLabel.text = "Header"
//            reusuableView = headerView!
//        }
////        else if kind == UICollectionElementKindSectionFooter {
////            let reuseString = NoteCollectionViewFooter.reuseString
////            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
////                                                                                   withReuseIdentifier:reuseString,
////                                                                                   forIndexPath: indexPath) as? NoteCollectionViewFooter
////            //footerView?.titleLabel.text = "Footer"
////            reusuableView = footerView!
////        }
//        
//        return reusuableView
//    }
}

