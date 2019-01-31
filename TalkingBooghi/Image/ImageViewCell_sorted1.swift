//
//  ImageViewCell_sorted1.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 06/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class ImageViewCell_sorted1: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imageNames = [String]()
    var images = [UIImage]()
    var count = 0
    
    @IBOutlet weak var sizeLabel: UILabel! {
        didSet {
            sizeLabel.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        innerSortedCollectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let colWidth = UIScreen.main.bounds.width * 0.9
        var colHeight = UIScreen.main.bounds.height * 0.83 - 70
        if UIDevice.current.screenResolutionType == "iPhoneX" {
            colHeight = UIScreen.main.bounds.height * 0.76
        }
        
        print(count)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            let layout = self.innerSortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: 150, height: 196)
            let margin = (self.sizeLabel.bounds.width-450-30)/4
            layout.sectionInset = UIEdgeInsets.init(top: 10, left: margin, bottom: 10, right: margin)
            layout.sectionInsetReference = .fromLayoutMargins
        default:
            switch count {
            case 1:
                let layout = self.innerSortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let width = self.innerSortedCollectionView.frame.width * 2 / 3
                layout.itemSize = CGSize(width: width, height: width * 3 / 2)
                layout.sectionInset = UIEdgeInsets.init(top: (self.innerSortedCollectionView.frame.height - width * 3 / 2)/2, left: width/2, bottom: (self.innerSortedCollectionView.frame.height - width * 3 / 2)/2, right: width/2)
                layout.sectionInsetReference = .fromContentInset
            case 2:
                let layout = self.innerSortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let width = (self.innerSortedCollectionView.frame.height-45)/3
                layout.itemSize = CGSize(width: width, height: width * 3 / 2)
                layout.minimumLineSpacing = 15
                layout.sectionInset = UIEdgeInsets.init(top: 15, left: (self.innerSortedCollectionView.frame.width-width)/2, bottom: 15, right: (self.innerSortedCollectionView.frame.width-width)/2)
                layout.sectionInsetReference = .fromContentInset
            case 3:
                let layout = self.innerSortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let width = (self.innerSortedCollectionView.bounds.height - 60)*2/9
                layout.itemSize = CGSize(width: width, height: width * 3 / 2)
                layout.minimumLineSpacing = 15
                layout.sectionInset = UIEdgeInsets.init(top: 15, left: (self.innerSortedCollectionView.bounds.width-width)/2, bottom: 15, right: (self.innerSortedCollectionView.bounds.width-width)/2)
                layout.sectionInsetReference = .fromContentInset
            case 4:
                let layout = self.innerSortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let width = (self.innerSortedCollectionView.bounds.width - 60) / 2
                layout.itemSize = CGSize(width: width, height: width * 3/2)
                layout.sectionInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 10, right: 15)
                layout.sectionInsetReference = .fromContentInset
            case 5,6:
                let layout = self.innerSortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let width = (self.innerSortedCollectionView.bounds.width - 40) / 2.5
                layout.itemSize = CGSize(width: width, height: width * 3/2)
                layout.sectionInset = UIEdgeInsets.init(top: 15, left: 20, bottom: 10, right: 20)
                layout.sectionInsetReference = .fromContentInset
            default:
                let layout = self.innerSortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let width = (self.innerSortedCollectionView.bounds.width - 60) / 3
                layout.itemSize = CGSize(width: width, height: width * 3/2)
                layout.sectionInset = UIEdgeInsets.init(top: 10, left: 15, bottom: 10, right: 15)
                layout.sectionInsetReference = .fromContentInset
            }
        }
        
        innerSortedCollectionView.delegate = self
        innerSortedCollectionView.dataSource = self
    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "innerSortedCell", for: indexPath) as! InnerSorted1ViewCell
        cell.imageView.image = images[indexPath.item]
        cell.imageLabel.text = imageNames[indexPath.item]
        
        return cell
    }
    
    
    @IBOutlet weak var innerSortedCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
  
}
