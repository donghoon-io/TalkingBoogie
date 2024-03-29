//
//  EverySortViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 12/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class EverySortViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var selectedInt = [Int]()
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var moveCategoryButton: UIBarButtonItem! {
        didSet {
            moveCategoryButton.isEnabled = false
        }
    }
    @IBAction func moveCategoryButtonClicked(_ sender: UIBarButtonItem) {
        let targetController: MoveCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "moveCard") as! MoveCardViewController
        var imgPathArray = [String]()
        for item in selectedInt {
            imgPathArray.append(imageSets[item].imagePath)
        }
        targetController.willMoveArray = imgPathArray
        let navController = UINavigationController(rootViewController: targetController)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var deleteButton: UIBarButtonItem! {
        didSet {
            deleteButton.isEnabled = false
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIBarButtonItem) {
        var selectedArray = [IndexPath]()
        for item in selectedInt.sorted(by: >) {
            imageSets.remove(at: item)
            selectedArray.append(IndexPath(item: item + 1, section: 0))
            selectedInt.removeAll {
                $0 == item
            }
        }
        self.everySortCollectionView.deleteItems(at: selectedArray)
        selectedArray = []
    }
    
    @IBOutlet weak var everySortCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSets.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EverySortCell", for: indexPath) as! EverySortViewCell
            
            cell.imageView.image = loadImage(named: imageSets[indexPath.item - 1].imagePath)
            cell.imageView.clipsToBounds = true
            cell.imageView.layer.cornerRadius = 5
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EverySortCellMain", for: indexPath)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            let cell = everySortCollectionView.cellForItem(at: indexPath) as! EverySortViewCell
            if !selectedInt.contains(indexPath.item - 1) {
                selectedInt.append(indexPath.item - 1)
                cell.selectImage.image = UIImage(named: "isChecked")
                deleteButton.isEnabled = true
                moveCategoryButton.isEnabled = true
            } else {
                selectedInt.removeAll {
                    $0 == indexPath.item - 1
                }
                cell.selectImage.image = UIImage(named: "notChecked")
                if selectedInt.count == 0 {
                    deleteButton.isEnabled = false
                    moveCategoryButton.isEnabled = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        everySortCollectionView.delegate = self
        everySortCollectionView.dataSource = self
        
        switch viewLayout {
        case "threebythree":
            let layout = self.everySortCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        case "fourbyfour":
            let layout = self.everySortCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 60)/4
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        default:
            let layout = self.everySortCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
    }
}
