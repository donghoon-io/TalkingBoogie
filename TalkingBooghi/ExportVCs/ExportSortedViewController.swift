//
//  ExportSortedViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 14/11/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class ExportSortedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var images = [UIImage]()
    var imageNames = [String]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExportViewCell", for: indexPath) as! ExportViewCell
        cell.imageView.image = images[indexPath.item]
        cell.imageLabel.text = imageNames[indexPath.item]
        
        return cell
    }
    
    func reloadLayout() {
        switch imageNames.count {
        case 1:
            let layout = self.exportCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let itemWidth: CGFloat = self.exportCollectionView.frame.size.width*2/3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 3/2)
            layout.sectionInset = UIEdgeInsets.init(top: (exportCollectionView.frame.height - itemWidth*3/2)/2,left: exportCollectionView.frame.width/6, bottom: (exportCollectionView.frame.height - itemWidth*3/2)/2, right: exportCollectionView.frame.width/6)
            layout.sectionInsetReference = .fromContentInset
        case 2:
            let layout = self.exportCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let itemHeight: CGFloat = self.exportCollectionView.frame.size.height*2/5
            layout.itemSize = CGSize(width: itemHeight*3/4, height: itemHeight)
            layout.sectionInset = UIEdgeInsets.init(top: (exportCollectionView.frame.height - itemHeight*2)/3,left: (exportCollectionView.frame.width-itemHeight*3/4)/2, bottom: (exportCollectionView.frame.height - itemHeight*2)/3, right: (exportCollectionView.frame.width-itemHeight*3/4)/2)
            layout.sectionInsetReference = .fromContentInset
        case 3:
            let layout = self.exportCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let itemHeight: CGFloat = self.exportCollectionView.frame.size.height*2/7
            layout.itemSize = CGSize(width: itemHeight*3/4, height: itemHeight)
            layout.sectionInset = UIEdgeInsets.init(top: (exportCollectionView.frame.height - itemHeight*2)/4,left: (exportCollectionView.frame.width-itemHeight*3/4)/2, bottom: (exportCollectionView.frame.height - itemHeight*2)/4, right: (exportCollectionView.frame.width-itemHeight*3/4)/2)
            layout.sectionInsetReference = .fromContentInset
        case 4:
            let layout = self.exportCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let itemWidth: CGFloat = self.exportCollectionView.frame.size.width*2/5
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth*4/3)
            layout.sectionInset = UIEdgeInsets.init(top: (self.exportCollectionView.frame.size.height-itemWidth*8/3)/3, left: itemWidth/6, bottom: (self.exportCollectionView.frame.size.height-itemWidth*8/3)/3, right: itemWidth/6)
            layout.sectionInsetReference = .fromContentInset
        case 5, 6:
            let layout = self.exportCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let itemWidth: CGFloat = self.exportCollectionView.frame.size.width/3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth*4/3)
            layout.sectionInset = UIEdgeInsets.init(top: (self.exportCollectionView.frame.size.height-itemWidth*4)/3, left: itemWidth/3, bottom: (self.exportCollectionView.frame.size.height-itemWidth*4)/3, right: itemWidth/3)
            layout.sectionInsetReference = .fromContentInset
        case 7, 8, 9:
            let layout = self.exportCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let itemWidth: CGFloat = self.exportCollectionView.frame.size.width/4
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth*4/3)
            layout.sectionInset = UIEdgeInsets.init(top: (self.exportCollectionView.frame.size.height-itemWidth*4)/2, left: itemWidth/4, bottom: (self.exportCollectionView.frame.size.height-itemWidth*4)/2, right: itemWidth/4)
            layout.sectionInsetReference = .fromContentInset
        default:
            let layout = self.exportCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let itemWidth: CGFloat = self.exportCollectionView.frame.size.width/4
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth*4/3)
            layout.sectionInset = UIEdgeInsets.init(top: (self.exportCollectionView.frame.size.height-itemWidth*4)/9, left: itemWidth/4, bottom: (self.exportCollectionView.frame.size.height-itemWidth*4)/4, right: itemWidth/4)
            layout.sectionInsetReference = .fromContentInset
        }
    }
    
    @IBOutlet weak var captureView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var exportCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exportCollectionView.delegate = self
        exportCollectionView.dataSource = self
    }
}
