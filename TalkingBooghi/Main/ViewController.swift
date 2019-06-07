//
//  ViewController.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 19..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit
import Firebase
import Sparrow
import BetterSegmentedControl
import RevealingSplashView
import Photos
import Localize_Swift

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension ViewController: CategoryCellDelegate {
    func edit(cell: CategoryViewCell) {
        let editAlert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let editNameAction: UIAlertAction = UIAlertAction(title: "\(cell.categoryLabel.text!)"+" 앨범 이름바꾸기".localized(), style: .default) {
            (action: UIAlertAction!) -> Void in
            let editName = UIAlertController(title: "\(cell.categoryLabel.text!)"+" 앨범 이름바꾸기".localized(), message: "변경할 앨범 이름을 입력해주세요".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "저장".localized(), style: .default) {
                (action:  UIAlertAction) -> Void in
                let textField = editName.textFields?[0]
                if !category.contains((textField?.text!)!) {
                    for (index, _) in category.enumerated() {
                        if category[index] == cell.categoryLabel.text! {
                            category[index] = (textField?.text!)!
                            break
                        }
                    }
                    for (index, _) in imageSets.enumerated() {
                        if imageSets[index].category == cell.categoryLabel.text! {
                            imageSets[index].category = (textField?.text!)!
                        }
                    }
                    self.categoryCollectionView.reloadData()
                } else {
                    let dialog = UIAlertController(title: (textField?.text!)! + " 카테고리가 이미 존재함".localized(), message: (textField?.text!)!+" 이름을 가진 카테고리가 이미 존재합니다".localized(), preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.cancel)
                    dialog.addAction(action)
                    self.present(dialog, animated: true, completion: nil)
                }
            }
            okAction.isEnabled = false
            
            
            let cancelAction = UIAlertAction(title: "취소".localized(), style: .cancel, handler: nil)
            
            editName.addAction(okAction)
            editName.addAction(cancelAction)
            editName.addTextField { (textField: UITextField) in
                textField.placeholder = "수정할 제목".localized()
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using:
                    {_ in
                        let textCount = textField.text?.count ?? 0
                        let textIsNotEmpty = textCount > 0
                        okAction.isEnabled = textIsNotEmpty
                })
            }
            self.present(editName, animated: true, completion: nil)
        }
        let copyAction: UIAlertAction = UIAlertAction(title: cell.categoryLabel.text!+" 앨범 복사".localized(), style: .default) {
            (action: UIAlertAction!) -> Void in
            var newCategoryName = cell.categoryLabel.text! + " 복사본".localized()
            while category.contains(newCategoryName) {
                newCategoryName += " 복사본".localized()
            }
            category.append(newCategoryName)
            
            var tempImageSets = imageSets.filter({
                $0.category == cell.categoryLabel.text!
            })
            for (index, _) in tempImageSets.enumerated() {
                tempImageSets[index].category = newCategoryName
                let title = getTodayString() + String(index)
                saveDocumentImage(img: loadImage(named: tempImageSets[index].imagePath), imgPath: title)
                tempImageSets[index].imagePath = title
                for (anotherIndex, _) in tempImageSets[index].tagPath.enumerated() {
                    let anotherTitle = title + String(anotherIndex)
                    saveDocumentImage(img: loadImage(named: tempImageSets[index].tagPath[anotherIndex]), imgPath: anotherTitle)
                    tempImageSets[index].tagPath[anotherIndex] = anotherTitle
                }
            }
            imageSets += tempImageSets
            self.categoryCollectionView.reloadData()
        }
        let categoryDeleteAction: UIAlertAction = UIAlertAction(title: cell.categoryLabel.text!+" 앨범 삭제".localized(), style: .destructive) {
            (action: UIAlertAction!) -> Void in
            self.delete(cell: cell)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소".localized(), style: .cancel) {
            (action: UIAlertAction!) -> Void in
            
        }
        editAlert.addAction(copyAction)
        editAlert.addAction(editNameAction)
        editAlert.addAction(categoryDeleteAction)
        editAlert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = editAlert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                self.present(editAlert, animated: true, completion: nil)
            }
        } else {
            self.present(editAlert, animated: true, completion: nil)
        }
    }
    
    func delete(cell: CategoryViewCell) {
        var alert: UIAlertController?
        if let indexPath = self.categoryCollectionView?.indexPath(for: cell) {
            if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item-1]).count != 0 {
                alert = UIAlertController(title: "'\(category[indexPath.item-1])'"+" 삭제".localized(), message: "'\(category[indexPath.item-1])'"+" 앨범을 삭제하시겠습니까? 카드는 제거되지 않습니다".localized(), preferredStyle: .alert)
            } else {
                alert = UIAlertController(title: "'\(category[indexPath.item-1])' 삭제", message: "'\(category[indexPath.item-1])' "+" 앨범을 삭제하시겠습니까?".localized(), preferredStyle: .alert)
            }
        }
        
        let informantAction: UIAlertAction = UIAlertAction(title: "앨범 삭제".localized(), style: UIAlertAction.Style.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            if let indexPath = self.categoryCollectionView?.indexPath(for: cell) {
                imageSets.removeAll(where: {
                    $0.category == cell.categoryLabel.text
                })
                category.removeAll(where: {
                    $0 == cell.categoryLabel.text
                })
                self.categoryCollectionView.deleteItems(at: [indexPath])
            }
            self.categoryCollectionView.reloadData()
            self.everyCollectionView.reloadData()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소".localized(), style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert?.addAction(cancelAction)
        alert?.addAction(informantAction)
        
        self.present(alert!, animated: true, completion: nil)
    }
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, goToMakeCard {
    
    var db: Firestore!
    
    let dateFormatter1: DateFormatter = DateFormatter()
    let dateFormatter2: DateFormatter = DateFormatter()
    let dateFormatter3: DateFormatter = DateFormatter()
    
    var offset = CGPoint.zero
    
    func goMake(titleName: String, type: String) {
        let titleNameForMakingCard = titleName
        switch type {
        case "routine":
            let routineController: RoutineMakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "routineMake") as! RoutineMakeCardViewController
            routineController.whatIsTitleText = titleNameForMakingCard
            let navController = UINavigationController(rootViewController: routineController)
            self.present(navController, animated: true, completion: nil)
        case "sorted":
            let sortedController: SortedMakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "sortedMake") as! SortedMakeCardViewController
            sortedController.whatIsTitleText = titleNameForMakingCard
            let navController = UINavigationController(rootViewController: sortedController)
            self.present(navController, animated: true, completion: nil)
        default:
            let defaultController: MakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "defaultMake") as! MakeCardViewController
            defaultController.whatIsTitleText = titleNameForMakingCard
            let navController = UINavigationController(rootViewController: defaultController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    var isAlbum = true
    
    var shouldScroll = false
    
    var titleField: UITextField?
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    @objc func mainSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
        case 0:
            self.everyCollectionView.isHidden = false
            self.categoryCollectionView.isHidden = true
            
            isAlbum = false
            cardLayout()
        default:
            self.everyCollectionView.isHidden = true
            self.categoryCollectionView.isHidden = false
            
            isAlbum = true
            albumLayout()
        }
    }
    
    @IBOutlet weak var mainSegmentControl: BetterSegmentedControl! {
        didSet {
            mainSegmentControl.segments = LabelSegment.segments(withTitles: ["모든 카드".localized(), "앨범".localized()], normalBackgroundColor: UIColor(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1), normalFont: UIFont.systemFont(ofSize: 14.0, weight: .bold), normalTextColor: .white, selectedBackgroundColor: .clear, selectedFont: UIFont.systemFont(ofSize: 14.0, weight: .bold), selectedTextColor: .blue)
            mainSegmentControl.setIndex(1)
            mainSegmentControl.addTarget(self, action: #selector(self.mainSegmentedControlValueChanged(_:)), for: .valueChanged)
        }
    }
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "logo_launch".localized())!, iconInitialSize: CGSize(width: 240, height: 166), backgroundImage: UIImage(named: "main")!)
    
    func setupViews() {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()
    }
    
    @IBOutlet weak var twobytwo: UIButton!
    @IBOutlet weak var threebythree: UIButton!
    @IBOutlet weak var fourbyfour: UIButton!
    
    @IBAction func twobytwoClicked(_ sender: UIButton) {
        twobytwoLayout()
        viewLayout = "twobytwo"
    }
    @IBAction func threebythreeClicked(_ sender: UIButton) {
        threebythreeLayout()
        viewLayout = "threebythree"
    }
    @IBAction func fourbyfourClicked(_ sender: UIButton) {
        fourbyfourLayout()
        viewLayout = "fourbyfour"
    }
    
    
    @IBAction func sortClicked(_ sender: UIBarButtonItem) {
        if isAlbum {
            self.performSegue(withIdentifier: "sortAlbum", sender: self)
        } else {
            self.performSegue(withIdentifier: "sortCard", sender: self)
        }
    }
    
    
    @IBAction func moveClicked(_ sender: UIBarButtonItem) {
        if isAlbum {
            self.performSegue(withIdentifier: "moveCategory", sender: self)
        } else {
            self.performSegue(withIdentifier: "moveCard", sender: self)
        }
    }
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var everyCollectionView: UICollectionView!
    
    func twobytwoLayout() {
        UIView.animate(withDuration: 2) {
            self.everyCollectionView.collectionViewLayout.invalidateLayout()
            let layout = self.everyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
        twobytwo.alpha = 1
        threebythree.alpha = 0.5
        fourbyfour.alpha = 0.5
    }
    
    func threebythreeLayout() {
        UIView.animate(withDuration: 2) {
            self.everyCollectionView.collectionViewLayout.invalidateLayout()
            let layout = self.everyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 50)/3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
        twobytwo.alpha = 0.5
        threebythree.alpha = 1
        fourbyfour.alpha = 0.5
    }
    
    func fourbyfourLayout() {
        UIView.animate(withDuration: 2) {
            self.everyCollectionView.collectionViewLayout.invalidateLayout()
            let layout = self.everyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.frame.size.width - 60)/4
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 204.88 / 162.88)
        }
        twobytwo.alpha = 0.5
        threebythree.alpha = 0.5
        fourbyfour.alpha = 1
    }
    
    @IBAction func upClicked(_ sender: UIButton) {
        print(self.categoryCollectionView.contentOffset)
        if mainSegmentControl.index == 1 {
            let cellSize = self.view.frame.size
            let contentOffset = self.categoryCollectionView.contentOffset
            let r = CGRect(x: 0, y: contentOffset.y-190, width: cellSize.width, height: 190)
            self.categoryCollectionView.scrollRectToVisible(r, animated: true)
        } else {
            let cellSize = self.view.frame.size
            let contentOffset = self.everyCollectionView.contentOffset
            let r = CGRect(x: 0, y: contentOffset.y-190, width: cellSize.width, height: 190)
            self.everyCollectionView.scrollRectToVisible(r, animated: true)
        }
    }
    
    @IBAction func downClicked(_ sender: UIButton) {
        if mainSegmentControl.index == 1 {
            let cellSize = self.view.frame.size
            let contentOffset = self.categoryCollectionView.contentOffset
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height+100)
            self.categoryCollectionView.scrollRectToVisible(r, animated: true)
        } else {
            let cellSize = self.view.frame.size
            let contentOffset = self.everyCollectionView.contentOffset
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height+100)
            self.everyCollectionView.scrollRectToVisible(r, animated: true)
        }
    }
    
    func albumLayout() {
        switch viewLayout {
        case "threebythree":
            threebythreeLayout()
        case "fourbyfour":
            fourbyfourLayout()
        default:
            twobytwoLayout()
        }
        
        twobytwo.isHidden = true
        threebythree.isHidden = true
        fourbyfour.isHidden = true
    }
    
    func cardLayout() {
        switch viewLayout {
        case "threebythree":
            threebythreeLayout()
        case "fourbyfour":
            fourbyfourLayout()
        default:
            twobytwoLayout()
        }
        
        twobytwo.isHidden = false
        threebythree.isHidden = false
        fourbyfour.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryCollectionView.reloadData()
        everyCollectionView.reloadData()
        
        if shouldScroll {
            categoryCollectionView.scrollToLast()
            shouldScroll = false
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 180/255.0, blue: 244/255.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        db = Firestore.firestore()
        
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter2.dateFormat = "HH:mm:ss"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        setupViews()
        
        offset = CGPoint(x: self.view.frame.width, y: 0)
        
        if !notInitial {
            imageSets = preSet
            category = ["음식", "활동", "사람", "일과", "오늘의 일기", "일상대화"]
            speechSpeed = 0.4
            isAlbum = true
            notInitial = true
        }
        
        if !isTutorialShown {
            performSegue(withIdentifier: "tutorial", sender: self)
            isTutorialShown = true
        }
        
        categoryCollectionView.isHidden = false
        everyCollectionView.isHidden = true
        
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    print("authorized")
                case .denied, .restricted:
                    print("denied")
                case .notDetermined:
                    print("notDetermined")
                }
            }
        }
        
        let navController = navigationController!
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let image = UIImage(named: "NavLogo".localized())!
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        navController.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 180/255.0, blue: 244/255.0, alpha:1.0)
        navController.navigationBar.tintColor = UIColor.white
        imageView.frame = CGRect(x: 0, y: 0, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        everyCollectionView.delegate = self
        everyCollectionView.dataSource = self
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            let layout = self.categoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.bounds.width - 50)/4.0
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 157.38 / 162.88)
        default:
            let layout = self.categoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 10,left: 15,bottom: 10,right: 15)
            layout.minimumInteritemSpacing = 5
            let itemWidth: CGFloat = (self.view.bounds.width - 50)/2.0
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 157.38 / 162.88)
        }
    
        if isAlbum {
            albumLayout()
        } else {
            cardLayout()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return category.count + 1
        } else {
            return imageSets.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            if indexPath.item != 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryViewCell
                cell.categoryLabel.text = category[indexPath.item - 1]
                
                if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count != 0 {
                    cell.howManyLabel.text = "+\(setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count - 1)"+"장".localized()
                } else {
                    cell.howManyLabel.text = "카드 없음".localized()
                }
                
                if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count != 0 {
                    cell.categoryImage.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1])[0].imagePath)
                    if setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1]).count > 1 {
                        cell.secondCategoryImage.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: category[indexPath.item - 1])[1].imagePath)
                    } else {
                        cell.secondCategoryImage.image = nil
                    }
                } else {
                    cell.categoryImage.image = loadImage(named: "defaultImage")
                    cell.secondCategoryImage.image = loadImage(named: "defaultImage")
                }
                
                cell.categoryImage.clipsToBounds = true
                cell.categoryImage.layer.cornerRadius = 5
                cell.secondCategoryImage.clipsToBounds = true
                cell.secondCategoryImage.layer.cornerRadius = 5
                
                cell.layer.cornerRadius = 5
                cell.contentView.layer.cornerRadius = 5
                cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
                cell.contentView.layer.masksToBounds = true
                cell.layer.shadowOffset = CGSize(width:2.0, height: 2.0)
                cell.layer.shadowRadius = 2.0
                cell.layer.shadowOpacity = 0.5
                cell.layer.masksToBounds = false
                
                cell.delegate = self
                
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellMain", for: indexPath)
                
                return cell
            }
        } else {
            if indexPath.item != 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainEveryViewCell", for: indexPath) as! MainEveryViewCell
                switch imageSets[indexPath.item - 1].cardType {
                case "default":
                    cell.everyImage.image = loadImage(named: imageSets[indexPath.item - 1].imagePath)
                case "sorted":
                    let tempImgSet = imageSets[indexPath.item - 1]
                    if let tempImage = loadMainImage(named: tempImgSet.imagePath + "main") {
                        cell.everyImage.image = tempImage
                    } else {
                        let img = sortedImageGenerator(imgSet: tempImgSet)
                        saveDocumentImage(img: img, imgPath: tempImgSet.imagePath+"main")
                        cell.everyImage.image = img
                    }
                default:
                    let tempImgSet = imageSets[indexPath.item - 1]
                    if let tempImage = loadMainImage(named: tempImgSet.imagePath + "main") {
                        cell.everyImage.image = tempImage
                    } else {
                        let img = routineImageGenerator(imgSet: tempImgSet)
                        saveDocumentImage(img: img, imgPath: tempImgSet.imagePath+"main")
                        cell.everyImage.image = img
                    }
                }
                
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstDefault", for: indexPath)
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 && collectionView == categoryCollectionView {
            let alertController = UIAlertController(title: "새로운 앨범".localized(), message: "이 앨범의 이름을 입력하십시오".localized(), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "저장".localized(), style: .default) { (action:  UIAlertAction) -> Void in
                let textField = alertController.textFields?[0]
                if !category.contains((textField?.text!)!) {
                    category.append((textField?.text)!)
                    self.categoryCollectionView.insertItems(at: [IndexPath(item: category.count, section: 0)])
                    self.categoryCollectionView.scrollToLast()
                } else {
                    let dialog = UIAlertController(title: "'\((textField?.text!)!)'"+" 카테고리가 이미 존재함".localized(), message: "'\((textField?.text!)!)'"+" 이름을 가진 카테고리가 이미 존재합니다".localized(), preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.cancel)
                    dialog.addAction(action)
                    self.present(dialog, animated: true, completion: nil)
                }
            }
            okAction.isEnabled = false
            let cancelAction = UIAlertAction(title: "취소".localized(), style: .cancel, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            alertController.addTextField { (textField: UITextField) in
                textField.placeholder = "제목".localized()
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using:
                    {_ in
                        let textCount = textField.text?.count ?? 0
                        let textIsNotEmpty = textCount > 0
                        okAction.isEnabled = textIsNotEmpty
                })
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goRight" {
            let secondController = segue.destination as! AlbumViewController
            if let cell = sender as? UICollectionViewCell,
                let indexPath = self.categoryCollectionView.indexPath(for: cell) {
                secondController.titleString = category[indexPath.item-1]
            }
        } else if segue.identifier == "goFromMain" {
            let destMain = segue.destination as! ImageViewController
            destMain.mainDelegate = self
            if let cell = sender as? UICollectionViewCell, let indexPath = self.everyCollectionView.indexPath(for: cell) {
                destMain.titleString = imageSets[indexPath.item - 1].imageName
                destMain.imagePathString = imageSets[indexPath.item - 1].imagePath
                destMain.setItem = imageSets[indexPath.item - 1]
                destMain.whatIsIndexPath = indexPath.item - 1
                destMain.whereFrom = "Every"
                
                
                let dateComponents = Calendar.current.dateComponents([.weekOfYear, .month], from: Date())
                
                db.collection("\(experimentID)_usage").addDocument(data: [
                    "cardname": imageSets[indexPath.item - 1].imageName,
                    "cardtype": imageSets[indexPath.item - 1].cardType,
                    "carddata": imageSets[indexPath.item - 1].tagName,
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
            destMain.whatIsCategory = "모든 카드"
        } else if segue.identifier == "goTypeFromMain" {
            let prepareFromMainController = segue.destination as! CardSelectionViewController
            prepareFromMainController.whatIsTitleText = "모든 카드"
            prepareFromMainController.makeDelegate = self
        }
    }
}

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        let lastSection = numberOfSections - 1
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}
