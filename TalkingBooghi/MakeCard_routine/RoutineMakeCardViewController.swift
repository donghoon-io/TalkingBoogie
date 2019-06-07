//
//  RoutineMakeCardViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 03/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Localize_Swift

extension RoutineMakeCardViewController: RoutineCellDelegate {
    func delete(cell: RoutineViewCell) {
        if let indexPath = self.routineCollectionView?.indexPath(for: cell) {
            self.imageNames.remove(at: indexPath.item)
            self.images.remove(at: indexPath.item)
            self.routineCollectionView.reloadData()
        }
    }
}

class RoutineMakeCardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SendOneImage {
    
    var isFromEditing = false
    var tempImgName = String()
    var tempImgPath = String()
    
    var imageNames = [String]()
    var images = [UIImage]()
    
    var tempImgSetForEditing: ImageSet?
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    func receiveImage(img: [UIImage], strings: [String]) {
        images = img
        imageNames = strings
        self.routineCollectionView.reloadData()
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
                    temp = ImageSet(category: "모든 카드", imageName: textField.text!, imagePath: imgPath, tagName: imageNames, tagPath: tagPaths, cardType: "routine", isEditable: true)
                } else {
                    temp = ImageSet(category: self.whatIsTitleText!, imageName: textField.text!, imagePath: imgPath, tagName: imageNames, tagPath: tagPaths, cardType: "routine", isEditable: true)
                }
                imageSets.insert(temp!, at: 0)
                saveDocumentImage(img: routineImageGenerator(imgSet: temp!), imgPath: imgPath+"main")
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
                    temp = ImageSet(category: "모든 카드", imageName: textField.text!, imagePath: imgPath, tagName: imageNames, tagPath: tagPaths, cardType: "routine", isEditable: true)
                } else {
                    temp = ImageSet(category: self.whatIsTitleText!, imageName: textField.text!, imagePath: imgPath, tagName: imageNames, tagPath: tagPaths, cardType: "routine", isEditable: true)
                }
                imageSets.insert(temp!, at: index)
                saveDocumentImage(img: routineImageGenerator(imgSet: temp!), imgPath: imgPath+"main")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == imageNames.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath) as! RoutineDefaultViewCell
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chooseCell", for: indexPath) as! RoutineViewCell
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath) as! RoutineDefaultViewCell
            cell.imageView.image = UIImage(named: "addsymbol")
            cell.imageView.alpha = 0.5
            cell.imageLabel.text = ""
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == imageNames.count {
            self.performSegue(withIdentifier: "routineGoAdd", sender: self)
        }
    }
    
    var whatIsTitleText: String?

    @IBOutlet weak var routineCollectionView: UICollectionView!
   
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        routineCollectionView.addGestureRecognizer(longPressGesture)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 59/255.0, green: 60/255.0, blue: 68/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let layout = self.routineCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let margin = (self.view.bounds.width - 60) / 3
        layout.itemSize = CGSize(width: margin, height: margin*3/2)
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: margin, bottom: 10, right: margin)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = 10
        
        if isFromEditing {
            textField.text = tempImgName
            self.title = "카드 수정하기".localized()
            tempImgSetForEditing = imageSets.filter({
                $0.imagePath == tempImgPath
            })[0]
        }
        
        routineCollectionView.delegate = self
        routineCollectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "routineGoAdd" {
            let routinePickerController = segue.destination as! ChooseRoutineImageViewController
            routinePickerController.routinePickerDelegate = self
            routinePickerController.receivingFrom = "Routine"
            routinePickerController.selectedImage = images
            routinePickerController.selectedString = imageNames
            
            routinePickerController.titleString = self.textField.text ?? ""
        }
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
            guard let selectedIndexPath = routineCollectionView.indexPathForItem(at: gesture.location(in: routineCollectionView)) else {
                break
            }
            routineCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            routineCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            routineCollectionView.endInteractiveMovement()
        default:
            routineCollectionView.cancelInteractiveMovement()
        }
    }
}
