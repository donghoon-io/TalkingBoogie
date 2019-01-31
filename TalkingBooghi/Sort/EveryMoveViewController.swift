//
//  EveryMoveViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 10/10/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class EveryMoveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSets.count + 1
    }
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardMoveCell", for: indexPath) as! EveryMoveViewCell
            cell.firstImage.image = loadImage(named: imageSets[indexPath.item - 1].imagePath)
            cell.firstImage.clipsToBounds = true
            cell.firstImage.layer.cornerRadius = 5
            cell.rotateWiggle()
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardMoveDefaultCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            cell.rotateWiggle()
        }
    }

    @IBOutlet weak var everyMoveCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        everyMoveCollectionView.delegate = self
        everyMoveCollectionView.dataSource = self
        
        switch viewLayout {
        case "threebythree":
            let layout = self.everyMoveCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        case "fourbyfour":
            let layout = self.everyMoveCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 60)/4
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        default:
            let layout = self.everyMoveCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        everyMoveCollectionView.addGestureRecognizer(longPressGesture)
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
            let item = imageSets.remove(at: sourceIndexPath.item - 1)
            imageSets.insert(item, at: destinationIndexPath.item - 1)
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
            guard let selectedIndexPath = everyMoveCollectionView.indexPathForItem(at: gesture.location(in: everyMoveCollectionView)) else {
                break
            }
            everyMoveCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            everyMoveCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            everyMoveCollectionView.endInteractiveMovement()
        default:
            everyMoveCollectionView.cancelInteractiveMovement()
        }
    }
}
