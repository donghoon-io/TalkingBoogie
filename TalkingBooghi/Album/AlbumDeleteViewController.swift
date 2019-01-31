//
//  AlbumDeleteViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 24/11/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class AlbumDeleteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var titleString = String()
    
    var selectedInt = [Int]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setCategoryArray(Array: imageSets, CategoryName: titleString).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "removeCardCell", for: indexPath) as! AlbumDeleteViewCell
            
            cell.imageView.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: titleString)[indexPath.item - 1].imagePath)
            
            cell.layer.cornerRadius = 5
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardRemoveDefaultCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            let cell = moveCollectionView.cellForItem(at: indexPath) as! AlbumDeleteViewCell
            if !selectedInt.contains(indexPath.item - 1) {
                selectedInt.append(indexPath.item - 1)
                cell.checkImage.image = UIImage(named: "isChecked")
                deleteButton.isEnabled = true
                moveButton.isEnabled = true
            } else {
                selectedInt.removeAll {
                    $0 == indexPath.item - 1
                }
                cell.checkImage.image = UIImage(named: "notChecked")
                if selectedInt.count == 0 {
                    deleteButton.isEnabled = false
                    moveButton.isEnabled = false
                }
            }
        }
    }
    
    @IBOutlet weak var moveCollectionView: UICollectionView!
    
    @IBOutlet weak var moveButton: UIBarButtonItem! {
        didSet {
            moveButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var deleteButton: UIBarButtonItem! {
        didSet {
            deleteButton.isEnabled = false
        }
    }
    
    @IBAction func moveButtonClicked(_ sender: UIBarButtonItem) {
        let targetController: MoveCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "moveCard") as! MoveCardViewController
        var imgPathArray = [String]()
        for item in selectedInt {
            imgPathArray.append(setCategoryArray(Array: imageSets, CategoryName: titleString)[item].imagePath)
        }
        targetController.willMoveArray = imgPathArray
        let navController = UINavigationController(rootViewController: targetController)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIBarButtonItem) {
        var selectedArray = [IndexPath]()
        for item in selectedInt.sorted(by: >) {
            imageSets.removeAll {
                $0.imagePath == setCategoryArray(Array: imageSets, CategoryName: titleString)[item].imagePath
            }
            selectedArray.append(IndexPath(item: item + 1, section: 0))
            selectedInt.removeAll {
                $0 == item
            }
        }
        self.moveCollectionView.deleteItems(at: selectedArray)
        selectedArray = []
    }
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    }
}
