//
//  ImageViewCell_routine1.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 06/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class ImageViewCell_routine1: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var innerRoutineCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UITextView! {
        didSet {
            titleLabel.centerVertically()
        }
    }
    
    @IBOutlet weak var sizeLabel: UILabel! {
        didSet {
            sizeLabel.isHidden = true
        }
    }
    
    @IBAction func upClicked(_ sender: UIButton) {
        let cellSize = self.innerRoutineCollectionView.frame.size
        let contentOffset = self.innerRoutineCollectionView.contentOffset
        let r = CGRect(x: 0, y: contentOffset.y-190, width: cellSize.width, height: 190)
        self.innerRoutineCollectionView.scrollRectToVisible(r, animated: true)
    }
    
    @IBAction func downClicked(_ sender: UIButton) {
        let cellSize = self.innerRoutineCollectionView.frame.size
        let contentOffset = self.innerRoutineCollectionView.contentOffset
        let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height+130)
        self.innerRoutineCollectionView.scrollRectToVisible(r, animated: true)
    }
    
    var imageNames = [String]()
    var images = [UIImage]()
    var count = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        innerRoutineCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            let layout = self.innerRoutineCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: 325, height: 425)
            let margin = (self.sizeLabel.bounds.width)/2
            layout.sectionInset = UIEdgeInsets.init(top: 10, left: margin, bottom: 10, right: margin)
            layout.sectionInsetReference = .fromLayoutMargins
        default:
            let layout = self.innerRoutineCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let margin = (innerRoutineCollectionView.bounds.width - 130 - 30)/2
            layout.sectionInset = UIEdgeInsets.init(top: 10, left: margin, bottom: 10, right: margin)
            layout.sectionInsetReference = .fromContentInset
        }
        
        innerRoutineCollectionView.delegate = self
        innerRoutineCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "innerCell", for: indexPath) as! InnerRoutine1ViewCell
        cell.imageView.image = images[indexPath.item]
        cell.imageLabel.text = imageNames[indexPath.item]
        
        
        return cell
    }
}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

