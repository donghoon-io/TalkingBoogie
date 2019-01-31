//
//  MoveCardViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 24/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Localize_Swift

class MoveCardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var willMoveArray = [String]() //add imagepath, possibly?
    var whereToAdd: Int?
    
    var isActivated: Bool = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count + 1
    }
    
    @IBOutlet weak var doneButton: UIBarButtonItem! {
        didSet {
            doneButton.isEnabled = false
        }
    }
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        for item in willMoveArray {
            var temp = imageSets.filter {
                $0.imagePath == item
            }[0]
            imageSets.removeAll {
                $0.imagePath == item
            }
            temp.category = category[whereToAdd!]
            imageSets.append(temp)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moveCell", for: indexPath) as! MoveViewCell
            cell.categoryLabel.text = category[indexPath.item - 1]
            cell.selectImage.image = UIImage(named: "notChecked")
            if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count != 0 {
                cell.howManyLabel.text = "\(setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count)"+"장".localized()
            } else {
                cell.howManyLabel.text = "카드 없음".localized()
            }
            
            if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count != 0 {
                cell.firstImageView.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1])[0].imagePath)
                if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count > 1 {
                    cell.secondImageView.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1])[1].imagePath)
                } else {
                    cell.secondImageView.image = UIImage()
                }
            } else {
                cell.firstImageView.image = UIImage()
                cell.secondImageView.image = UIImage()
            }
            
            cell.firstImageView.clipsToBounds = true
            cell.firstImageView.layer.cornerRadius = 5
            cell.secondImageView.clipsToBounds = true
            cell.secondImageView.layer.cornerRadius = 5
            
            cell.layer.cornerRadius = 5
            cell.contentView.layer.cornerRadius = 5
            cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            cell.contentView.layer.masksToBounds = true
            cell.layer.shadowOffset = CGSize(width:2.0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moveCellMain", for: indexPath)
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doneButton.isEnabled = true
        if indexPath.item - 1 != whereToAdd && indexPath.item != 0 {
            let cell = collectionView.cellForItem(at: indexPath) as! MoveViewCell
            whereToAdd = indexPath.item - 1
            cell.selectImage.image = UIImage(named: "isChecked")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let prevCell = collectionView.cellForItem(at: indexPath) as? MoveViewCell {
            prevCell.selectImage.image = UIImage(named: "notChecked")
        }
    }

    @IBOutlet weak var firstMoveImage: UIImageView! {
        didSet {
            firstMoveImage.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var howManyMoveCards: UILabel!
    
    @IBOutlet weak var moveCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
        moveCollectionView.delegate = self
        moveCollectionView.dataSource = self
        
        firstMoveImage.image = loadImage(named: willMoveArray[0])
        howManyMoveCards.text = String(willMoveArray.count)+"개의 카드를 어디로 이동할까요?".localized()
        
        let layout = self.moveCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let itemWidth: CGFloat = (self.view.frame.size.width - 50)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 157.38 / 162.88)
        
    }
}
