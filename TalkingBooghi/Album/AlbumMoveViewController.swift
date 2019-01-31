//
//  AlbumMoveViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 24/11/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class AlbumMoveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var titleString = String()
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setCategoryArray(Array: imageSets, CategoryName: titleString).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "willBeMovedCell", for: indexPath) as! AlbumMoveViewCell
            cell.imageView.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: titleString)[indexPath.item - 1].imagePath)
            cell.imageView.clipsToBounds = true
            cell.layer.cornerRadius = 5
            cell.rotateWiggle()
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardDefaultCell", for: indexPath)
            return cell
        }
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
            let firstIndex = imageSets.firstIndex {
                $0.imagePath == setCategoryArray(Array: imageSets, CategoryName: titleString)[sourceIndexPath.item - 1].imagePath
            }
            let tempFirst = imageSets.filter {
                $0.imagePath == setCategoryArray(Array: imageSets, CategoryName: titleString)[sourceIndexPath.item - 1].imagePath
            }[0]
            let secondIndex = imageSets.firstIndex {
                $0.imagePath == setCategoryArray(Array: imageSets, CategoryName: titleString)[destinationIndexPath.item - 1].imagePath
            }
            imageSets.remove(at: firstIndex!)
            imageSets.insert(tempFirst, at: secondIndex!)
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
            guard let selectedIndexPath = moveCollectionView.indexPathForItem(at: gesture.location(in: moveCollectionView)) else {
                break
            }
            moveCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            moveCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            moveCollectionView.endInteractiveMovement()
        default:
            moveCollectionView.cancelInteractiveMovement()
        }
    }
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var moveCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveCollectionView.delegate = self
        moveCollectionView.dataSource = self
        
        switch viewLayout {
        case "threebythree":
            let layout = self.moveCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        case "fourbyfour":
            let layout = self.moveCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 60)/4
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        default:
            let layout = self.moveCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        moveCollectionView.addGestureRecognizer(longPressGesture)
    }
}
