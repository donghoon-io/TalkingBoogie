//
//  SortViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 12/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Localize_Swift

class CategorySortViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedInt = [Int]()
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var deleteButton: UIBarButtonItem! {
        didSet {
            deleteButton.isEnabled = false
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIBarButtonItem) {
        var selectedArray = [IndexPath]()
        for item in selectedInt.sorted(by: >) {
            let catName = category[item]
            category.remove(at: item)
            imageSets = imageSets.filter({
                $0.category != catName
            })
            selectedArray.append(IndexPath(item: item + 1, section: 0))
            selectedInt.removeAll {
                $0 == item
            }
        }
        self.categorySortCollectionView.deleteItems(at: selectedArray)
        selectedArray = []
    }
    
    @IBOutlet weak var categorySortCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorySortCell", for: indexPath) as! CategorySortViewCell
            
            cell.categoryLabel.text = category[indexPath.item - 1]
            if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count != 0 {
                cell.howManyLabel.text = "+ \(setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count - 1)"+"장".localized()
            } else {
                cell.howManyLabel.text = "카드 없음".localized()
            }
            
            if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count != 0 {
                cell.imageView1.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1])[0].imagePath)
                if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count > 1 {
                    cell.imageView2.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1])[1].imagePath)
                } else {
                    cell.imageView2.image = nil
                }
            } else {
                cell.imageView1.image = loadImage(named: "defaultImage")
                cell.imageView2.image = loadImage(named: "defaultImage")
            }
            cell.imageView1.clipsToBounds = true
            cell.imageView1.layer.cornerRadius = 5
            cell.imageView2.clipsToBounds = true
            cell.imageView2.layer.cornerRadius = 5
            cell.alphaView.layer.cornerRadius = 5
            cell.alphaView.clipsToBounds = true
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortCellMain", for: indexPath)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            let cell = categorySortCollectionView.cellForItem(at: indexPath) as! CategorySortViewCell
            if !selectedInt.contains(indexPath.item - 1) {
                selectedInt.append(indexPath.item - 1)
                cell.chooseImage.image = UIImage(named: "isChecked")
                deleteButton.isEnabled = true
            } else {
                selectedInt.removeAll {
                    $0 == indexPath.item - 1
                }
                cell.chooseImage.image = UIImage(named: "notChecked")
                if selectedInt.count == 0 {
                    deleteButton.isEnabled = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categorySortCollectionView.delegate = self
        categorySortCollectionView.dataSource = self
        
        let layout = self.categorySortCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
        layout.minimumInteritemSpacing = 5
        let itemWidth: CGFloat = (self.view.frame.size.width - 50)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 157.38 / 162.88)

        // Do any additional setup after loading the view.
    }
}
