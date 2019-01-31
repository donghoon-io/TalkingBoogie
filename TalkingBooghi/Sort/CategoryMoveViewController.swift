//
//  CategoryMoveViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 10/10/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Localize_Swift

class CategoryMoveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count + 1
    }
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumMoveCell", for: indexPath) as! CategoryMoveViewCell
            
            cell.rotateWiggle()
            
            cell.categoryName.text = category[indexPath.item - 1]
            if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count != 0 {
                cell.howManyLabel.text = "+ \(setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count - 1)"+"장".localized()
            } else {
                cell.howManyLabel.text = "카드 없음".localized()
            }
            
            if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count != 0 {
                cell.firstImage.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1])[0].imagePath)
                if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count > 1 {
                    cell.secondImage.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1])[1].imagePath)
                } else {
                    cell.secondImage.image = nil
                }
            } else {
                cell.firstImage.image = loadImage(named: "defaultImage")
                cell.secondImage.image = loadImage(named: "defaultImage")
            }
            cell.firstImage.clipsToBounds = true
            cell.firstImage.layer.cornerRadius = 5
            cell.secondImage.clipsToBounds = true
            cell.secondImage.layer.cornerRadius = 5
            cell.alphaView.layer.cornerRadius = 5
            cell.alphaView.clipsToBounds = true
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumMoveDefaultCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            cell.rotateWiggle()
        }
    }
    
    @IBOutlet weak var categoryMoveCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryMoveCollectionView.delegate = self
        categoryMoveCollectionView.dataSource = self
        
        let layout = self.categoryMoveCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
        layout.minimumInteritemSpacing = 5
        let itemWidth: CGFloat = (self.view.frame.size.width - 50)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 157.38 / 162.88)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        categoryMoveCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.item != 0 {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.item != 0 {
            let item = category.remove(at: sourceIndexPath.item - 1)
            category.insert(item, at: destinationIndexPath.item - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.item == 0 {
            return originalIndexPath
        } else {
            return proposedIndexPath
        }
    }
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = categoryMoveCollectionView.indexPathForItem(at: gesture.location(in: categoryMoveCollectionView)) else {
                break
            }
            categoryMoveCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            categoryMoveCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            categoryMoveCollectionView.endInteractiveMovement()
        default:
            categoryMoveCollectionView.cancelInteractiveMovement()
        }
    }
}
