//
//  SortedMakeCardViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 03/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Localize_Swift

extension SortedMakeCardViewController: SortedCellDelegate {
    func delete(cell: SortedViewCell) {
        if let indexPath = self.sortedCollectionView.indexPath(for: cell) {
            self.images.remove(at: indexPath.item)
            self.imageNames.remove(at: indexPath.item)
            self.sortedCollectionView.reloadData()
        }
    }
}

class SortedMakeCardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SendOneImageToSorted {
    
    var isFromEditing = false
    var tempImgName = String()
    var tempImgPath = String()
    var tempImgSetForEditing: ImageSet?
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    func receiveImage(img: [UIImage], strings: [String]) {
        images = img
        imageNames = strings
        self.sortedCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == imageNames.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultSortedCell", for: indexPath) as! SortedDefaultViewCell
            cell.imageView.image = UIImage(named: "addsymbolplus_activated")
            cell.imageView.alpha = 1
            cell.imageLabel.text = ""
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                cell.imageLabel.font = cell.imageLabel.font.withSize(20)
            default:
                cell.imageLabel.font = cell.imageLabel.font.withSize(15)
            }
            return cell
        } else if indexPath.item < imageNames.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chooseSelectedCell", for: indexPath) as! SortedViewCell
            cell.selectImageView.image = self.images[indexPath.item]
            cell.selectImageLabel.text = self.imageNames[indexPath.item]
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                cell.selectImageLabel.font = cell.selectImageLabel.font.withSize(20)
            default:
                cell.selectImageLabel.font = cell.selectImageLabel.font.withSize(15)
            }
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultSortedCell", for: indexPath) as! SortedDefaultViewCell
            cell.imageView.image = UIImage(named: "addsymbol")
            cell.imageView.alpha = 0.5
            cell.imageLabel.text = ""
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == imageNames.count {
            self.performSegue(withIdentifier: "sortedGoAdd", sender: self)
        }
    }
    
    @IBOutlet weak var sortedCollectionView: UICollectionView!
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var imageNames = [String]()
    var images = [UIImage]()
    
    var whatIsTitleText: String?

    @IBOutlet weak var totView: UIView! {
        didSet {
            totView.layer.cornerRadius = 20
            totView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "제목을 입력해주세요".localized()
        }
    }
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        if !isFromEditing {
            if imageNames.count == 0 {
                let warning: UIAlertController = UIAlertController(title: "추가된 이미지가 없음".localized(), message: "적어도 하나의 사진을 추가하세요".localized(), preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { alert in
                }
                warning.addAction(okAction)
                self.present(warning, animated: true, completion: nil)
            } else {
                var temp: ImageSet?
                let imgPath = getTodayString() + "main"
                saveDocumentImage(img: images[0], imgPath: imgPath)
                var tagPaths = [String]()
                for (index, _) in images.enumerated() {
                    let tagPath = getTodayString() + String(index)
                    tagPaths.append(tagPath)
                    saveDocumentImage(img: images[index], imgPath: tagPath)
                }
                if self.whatIsTitleText == "모든 카드" {
                    temp = ImageSet(category: "모든 카드", imageName: textField.text!, imagePath: imgPath, tagName: imageNames, tagPath: tagPaths, cardType: "sorted", isEditable: true)
                } else {
                    temp = ImageSet(category: self.whatIsTitleText!, imageName: textField.text!, imagePath: imgPath, tagName: imageNames, tagPath: tagPaths, cardType: "sorted", isEditable: true)
                }
                imageSets.insert(temp!, at: 0)
                saveDocumentImage(img: sortedImageGenerator(imgSet: temp!), imgPath: imgPath+"main")
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            if imageNames.count == 0 {
                let warning: UIAlertController = UIAlertController(title: "추가된 이미지가 없음".localized(), message: "적어도 하나의 사진을 추가하세요".localized(), preferredStyle: .alert)
                let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { alert in
                }
                warning.addAction(okAction)
                self.present(warning, animated: true, completion: nil)
            } else {
                var index = Int()
                index = imageSets.firstIndex(where: {
                    $0.imagePath == tempImgSetForEditing!.imagePath
                }) ?? 0
                imageSets.removeAll {
                    $0.imagePath == tempImgSetForEditing!.imagePath
                }
                
                var temp: ImageSet?
                let imgPath = getTodayString() + "main"
                saveDocumentImage(img: images[0], imgPath: imgPath)
                var tagPaths = [String]()
                for (index, _) in images.enumerated() {
                    let tagPath = getTodayString() + String(index)
                    tagPaths.append(tagPath)
                    saveDocumentImage(img: images[index], imgPath: tagPath)
                }
                
                if tempImgPath.contains("20") {
                    for item in tempImgSetForEditing!.tagPath {
                        deleteDocumentImage(imgPath: item)
                    }
                    deleteDocumentImage(imgPath: tempImgSetForEditing!.imagePath)
                }
                
                if self.whatIsTitleText == "모든 카드" {
                    temp = ImageSet(category: "모든 카드", imageName: textField.text!, imagePath: imgPath, tagName: imageNames, tagPath: tagPaths, cardType: "sorted", isEditable: true)
                } else {
                    temp = ImageSet(category: self.whatIsTitleText!, imageName: textField.text!, imagePath: imgPath, tagName: imageNames, tagPath: tagPaths, cardType: "sorted", isEditable: true)
                }
                imageSets.insert(temp!, at: index)
                saveDocumentImage(img: sortedImageGenerator(imgSet: temp!), imgPath: imgPath+"main")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sortedCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        sortedCollectionView.addGestureRecognizer(longPressGesture)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 59/255.0, green: 60/255.0, blue: 68/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            let layout = self.sortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let margin = (self.view.bounds.width - 60) / 5
            layout.itemSize = CGSize(width: margin, height: margin*3/2)
            layout.sectionInset = UIEdgeInsets.init(top: 10, left: margin/2, bottom: 10, right: margin/2)
            layout.minimumInteritemSpacing = margin/2
            layout.minimumLineSpacing = 10
        default:
            let layout = self.sortedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let margin = (self.view.bounds.width - 60) * 3 / 13
            layout.itemSize = CGSize(width: margin, height: margin*3/2)
            layout.sectionInset = UIEdgeInsets.init(top: 10, left: margin/3, bottom: 10, right: margin/3)
            layout.minimumInteritemSpacing = margin/3
            layout.minimumLineSpacing = 15
        }
        
        if isFromEditing {
            textField.text = tempImgName
            self.title = "카드 수정하기".localized()
            tempImgSetForEditing = imageSets.filter({
                $0.imagePath == tempImgPath
            })[0]
        }
        
        sortedCollectionView.delegate = self
        sortedCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.item <= imageNames.count {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.item <= imageNames.count-1 {
            imageNames.swapAt(sourceIndexPath.item, destinationIndexPath.item)
            images.swapAt(sourceIndexPath.item, destinationIndexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.item >= imageNames.count {
            return originalIndexPath
        } else {
            return proposedIndexPath
        }
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = sortedCollectionView.indexPathForItem(at: gesture.location(in: sortedCollectionView)) else {
                break
            }
            sortedCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            sortedCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            sortedCollectionView.endInteractiveMovement()
        default:
            sortedCollectionView.cancelInteractiveMovement()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sortedGoAdd" {
            let sortedPickerController = segue.destination as! ChooseRoutineImageViewController
            sortedPickerController.sortedPickerDelegate = self
            sortedPickerController.receivingFrom = "Sorted"
            sortedPickerController.selectedImage = images
            sortedPickerController.selectedString = imageNames
            
            sortedPickerController.titleString = self.textField.text ?? ""
        }
    }
}
