//
//  AlbumViewController.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 19..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit
import Localize_Swift
import Firebase

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, goToMakeCard {
    
    var db: Firestore!
    
    let dateFormatter1: DateFormatter = DateFormatter()
    let dateFormatter2: DateFormatter = DateFormatter()
    let dateFormatter3: DateFormatter = DateFormatter()
    
    func goMake(titleName: String, type: String) {
        titleString = titleName
        switch type {
        case "routine":
            let routineController: RoutineMakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "routineMake") as! RoutineMakeCardViewController
            routineController.whatIsTitleText = self.titleString
            let navController = UINavigationController(rootViewController: routineController)
            self.present(navController, animated: true, completion: nil)
        case "sorted":
            let sortedController: SortedMakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "sortedMake") as! SortedMakeCardViewController
            sortedController.whatIsTitleText = self.titleString
            let navController = UINavigationController(rootViewController: sortedController)
            self.present(navController, animated: true, completion: nil)
        default:
            let defaultController: MakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "defaultMake") as! MakeCardViewController
            defaultController.whatIsTitleText = self.titleString
            let navController = UINavigationController(rootViewController: defaultController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    var titleString = String()
    
    var selectedList = [Int]()
    
    var nowEditing = false
    
    var currentIndexPath = Int()
    
    @IBOutlet weak var twobytwoAlbum: UIButton!
    @IBOutlet weak var threebythreeAlbum: UIButton!
    @IBOutlet weak var fourbyfourAlbum: UIButton!
    @IBAction func twobytwoAlbumClicked(_ sender: UIButton) {
        twobytwoLayoutAlbum()
        viewLayout = "twobytwo"
    }
    @IBAction func threebythreeAlbumClicked(_ sender: UIButton) {
        threebythreeLayoutAlbum()
        viewLayout = "threebythree"
    }
    @IBAction func fourbyfourAlbumClicked(_ sender: UIButton) {
        fourbyfourLayoutAlbum()
        viewLayout = "fourbyfour"
    }
    
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    @objc func deleteAction(sender: AnyObject?) {
        if selectedList.count != 0 {
            if titleString == "모든 카드" {
                let alertController = UIAlertController(title: nil, message: "해당 카드가 앱에서 삭제됩니다".localized(), preferredStyle: .actionSheet)
                let deleteAction = UIAlertAction(title: String(selectedList.count)+"장의 카드 삭제".localized(), style: .destructive) { (action: UIAlertAction) -> Void in
                    var indexpathArray = [IndexPath]()
                    for i in self.selectedList.sorted(by: >) {
                        imageSets.remove(at: i)
                        indexpathArray.append(IndexPath(item: i + 1, section: 0))
                    }
                    self.itemsCollectionView.deleteItems(at: indexpathArray)
                    self.selectedList = [Int]()
                }
                let cancelAction = UIAlertAction(title: "취소".localized(), style: .cancel) { (action: UIAlertAction) -> Void in
                }
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: nil, message: "이 사진을 삭제하시겠습니까, 아니면 이 앨범에서 제거하시겠습니까?".localized(), preferredStyle: .actionSheet)
                let trueDeleteAction = UIAlertAction(title: String(selectedList.count)+"장의 카드 삭제".localized(), style: .destructive) { (action: UIAlertAction) -> Void in
                    let setArray = setCategoryArray(Array: imageSets, CategoryName: self.titleString)
                    var a = [IndexPath]()
                    for i in self.selectedList.sorted(by: >) {
                        imageSets = imageSets.filter({
                            $0.imagePath != setArray[i].imagePath
                        })
                        a.append(IndexPath(item: i + 1, section: 0))
                    }
                    self.itemsCollectionView.deleteItems(at: a)
                    self.selectedList = [Int]()
                }
                let cancelAction = UIAlertAction(title: "취소".localized(), style: .cancel) { (action: UIAlertAction) -> Void in
                    
                }
                alertController.addAction(trueDeleteAction)
                alertController.addAction(cancelAction)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func scrollUp(_ sender: UIButton) {
        let cellSize = view.frame.size
        let contentOffset = itemsCollectionView.contentOffset
        let r = CGRect(x: 0, y: contentOffset.y-190, width: cellSize.width, height: 190)
        itemsCollectionView.scrollRectToVisible(r, animated: true)
    }
    
    @IBAction func scrollDown(_ sender: UIButton) {
        let cellSize = view.frame.size
        let contentOffset = itemsCollectionView.contentOffset
        let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height+100)
        itemsCollectionView.scrollRectToVisible(r, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        db = Firestore.firestore()
        
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter2.dateFormat = "HH:mm:ss"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        switch viewLayout {
        case "threebythree":
            threebythreeLayoutAlbum()
        case "fourbyfour":
            fourbyfourLayoutAlbum()
        default:
            twobytwoLayoutAlbum()
        }
        
        title = titleString
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemsCollectionView.reloadData()
        switch viewLayout {
        case "threebythree":
            threebythreeLayoutAlbum()
        case "fourbyfour":
            fourbyfourLayoutAlbum()
        default:
            twobytwoLayoutAlbum()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setCategoryArray(Array: imageSets, CategoryName: titleString).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! ItemsViewCell
            let imgSet = setCategoryArray(Array: imageSets, CategoryName: titleString)[indexPath.item-1]
            switch imgSet.cardType {
            case "default":
                cell2.itemImage.image = loadImage(named: imgSet.imagePath)
            case "routine":
                if let tempImage = loadMainImage(named: imgSet.imagePath + "main") {
                    cell2.itemImage.image = tempImage
                } else {
                    let img = routineImageGenerator(imgSet: imgSet)
                    saveDocumentImage(img: img, imgPath: imgSet.imagePath+"main")
                    cell2.itemImage.image = img
                }
            default:
                if let tempImage = loadMainImage(named: imgSet.imagePath + "main") {
                    cell2.itemImage.image = tempImage
                } else {
                    let img = sortedImageGenerator(imgSet: imgSet)
                    saveDocumentImage(img: img, imgPath: imgSet.imagePath+"main")
                    cell2.itemImage.image = img
                }
            }
            
            cell2.imageNameLabel.text = setCategoryArray(Array: imageSets, CategoryName: titleString)[indexPath.item-1].imageName
            
            cell2.layer.cornerRadius = 5
            
            cell2.layer.cornerRadius = 5
            cell2.contentView.layer.cornerRadius = 5
            cell2.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            cell2.contentView.layer.masksToBounds = true
            cell2.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            cell2.layer.shadowRadius = 2.0
            cell2.layer.shadowOpacity = 0.5
            cell2.layer.masksToBounds = false
            
            return cell2
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell22", for: indexPath)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            let cell2 = collectionView.cellForItem(at: indexPath) as! ItemsViewCell
            self.currentIndexPath = indexPath.item - 1
            performSegue(withIdentifier: "goBelow", sender: cell2)
            
            let dateComponents = Calendar.current.dateComponents([.weekOfYear, .month], from: Date())
            
            let currentImageSet = setCategoryArray(Array: imageSets, CategoryName: self.titleString)[self.currentIndexPath]
            
            db.collection("\(experimentID)_usage").addDocument(data: [
                "cardname": currentImageSet.imageName,
                "cardtype": currentImageSet.cardType,
                "carddata": currentImageSet.tagName,
                "date": dateFormatter1.string(from: Date()),
                "time": dateFormatter2.string(from: Date()),
                "weekofyear": String(dateComponents.weekOfYear ?? 0),
                "month": String(dateComponents.month ?? 0),
                "totrecord": dateFormatter3.string(from: Date())
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: documentID")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBelow" {
            let thirdController = segue.destination as! ImageViewController
            thirdController.albumDelegate = self
            thirdController.whatIsCategory = self.titleString
            thirdController.whatIsIndexPath = self.currentIndexPath
            thirdController.whereFrom = "Album"
            
            
        } else if segue.identifier == "setType" {
            let prepareController = segue.destination as! CardSelectionViewController
            prepareController.whatIsTitleText = self.titleString
            prepareController.makeDelegate = self
        } else if segue.identifier == "goMoveFromAlbum" {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? AlbumMoveViewController {
                    childVC.titleString = titleString
                }
            }
        } else if segue.identifier == "goDeleteFromAlbum" {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? AlbumDeleteViewController {
                    childVC.titleString = titleString
                }
            }
        }
    }
    
    func twobytwoLayoutAlbum() {
        UIView.animate(withDuration: 2.0) {
            self.itemsCollectionView.collectionViewLayout.invalidateLayout()
            let layout = self.itemsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
        twobytwoAlbum.alpha = 1
        threebythreeAlbum.alpha = 0.5
        fourbyfourAlbum.alpha = 0.5
    }
    
    func threebythreeLayoutAlbum() {
        UIView.animate(withDuration: 2.0) {
            self.itemsCollectionView.collectionViewLayout.invalidateLayout()
            let layout = self.itemsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
        twobytwoAlbum.alpha = 0.5
        threebythreeAlbum.alpha = 1
        fourbyfourAlbum.alpha = 0.5
    }
    
    func fourbyfourLayoutAlbum() {
        UIView.animate(withDuration: 2.0) {
            self.itemsCollectionView.collectionViewLayout.invalidateLayout()
            let layout = self.itemsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 60)/4
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
        twobytwoAlbum.alpha = 0.5
        threebythreeAlbum.alpha = 0.5
        fourbyfourAlbum.alpha = 1
    }
}

func setCategoryArray(Array: [ImageSet], CategoryName: String) -> [ImageSet] {
    if CategoryName != "모든 카드" {
        let filteredArray = imageSets.filter {
            $0.category == CategoryName
        }
        return filteredArray
    } else {
        return Array
    }
}

