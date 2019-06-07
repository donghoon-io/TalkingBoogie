//
//  ImageViewController.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 22..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit
import AVFoundation
import Toast_Swift
import Localize_Swift
import Firebase

class ImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let dateFormatter1: DateFormatter = DateFormatter()
    let dateFormatter2: DateFormatter = DateFormatter()
    let dateFormatter3: DateFormatter = DateFormatter()
    
    var db = Firestore.firestore()
    
    var synth: AVSpeechSynthesizer?
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if whereFrom == "Album" {
            albumDelegate.itemsCollectionView.reloadData()
        } else {
            mainDelegate.everyCollectionView.reloadData()
        }
    }
    @IBOutlet weak var leftButton: UIButton! {
        didSet {
            leftButton.layer.shadowColor = UIColor.black.cgColor
            leftButton.layer.shadowOpacity = 0.3
            leftButton.layer.shadowOffset = CGSize.zero
        }
    }
    @IBOutlet weak var rightButton: UIButton! {
        didSet {
            rightButton.layer.shadowColor = UIColor.black.cgColor
            rightButton.layer.shadowOpacity = 0.3
            rightButton.layer.shadowOffset = CGSize.zero
        }
    }
    
    @IBAction func goLeftClicked(_ sender: UIButton) {
        let nowIndex: IndexPath? = self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y))
        if nowIndex != nil {
            if nowIndex!.item != 0 {
                let indexToScrollTo = IndexPath(item: nowIndex!.item - 1, section: 0)
                self.scrollCollectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: true)
                sendLog()
            }
        }
    }
    
    @IBAction func goRightClicked(_ sender: UIButton) {
        let nowIndex: IndexPath? = self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y))
        if nowIndex != nil {
            if nowIndex!.item != setCategoryArray(Array: imageSets, CategoryName: whatIsCategory).count - 1 {
                let indexToScrollTo = IndexPath(item: nowIndex!.item + 1, section: 0)
                self.scrollCollectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: true)
                sendLog()
            }
        }
    }
    
    var albumDelegate: AlbumViewController!
    var mainDelegate: ViewController!
    
    var whereFrom = String()
    
    var timer = Timer()
    
    var onceOnly = false
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        sendLog()
    }
    
    func sendLog() {
        let centerItem: IndexPath = (self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y)))!
        let tempCard = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[centerItem.item]
        
        db = Firestore.firestore()
        
        let dateComponents = Calendar.current.dateComponents([.weekOfYear, .month], from: Date())
        
        
        
        db.collection("\(experimentID)_usage").addDocument(data: [
            "cardname": tempCard.imageName,
            "cardtype": tempCard.cardType,
            "carddata": tempCard.tagName,
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setCategoryArray(Array: imageSets, CategoryName: whatIsCategory).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].cardType == "default" {
            switch setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName.count {
            case 1:
                let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell_1", for: indexPath) as! ImageViewCell_1
                cell1.layer.cornerRadius = 30
                cell1.titleLabel.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imageName
                cell1.imageView.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imagePath)
                cell1.tagImage1.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath[0])
                cell1.tagLabel1.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName[0]
                
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(tapGestureRecognizer:)))
                cell1.imageView.isUserInteractionEnabled = true
                cell1.imageView.addGestureRecognizer(tapGestureRecognizer1)
                
                return cell1
            case 2:
                let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell_2", for: indexPath) as! ImageViewCell_2
                cell2.layer.cornerRadius = 30
                cell2.titleLabel.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imageName
                cell2.imageView.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imagePath)
                cell2.tagImage1.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath[0])
                cell2.tagLabel1.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName[0]
                cell2.tagImage2.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath[1])
                cell2.tagLabel2.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName[1]
                
                let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(tapGestureRecognizer:)))
                cell2.imageView.isUserInteractionEnabled = true
                cell2.imageView.addGestureRecognizer(tapGestureRecognizer2)
                
                return cell2
            case 3:
                let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell_3", for: indexPath) as! ImageViewCell_3
                cell3.layer.cornerRadius = 30
                cell3.titleLabel.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imageName
                cell3.imageView.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imagePath)
                cell3.tagImage1.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath[0])
                cell3.tagLabel1.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName[0]
                cell3.tagImage2.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath[1])
                cell3.tagLabel2.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName[1]
                cell3.tagImage3.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath[2])
                cell3.tagLabel3.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName[2]
                
                let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(tapGestureRecognizer:)))
                cell3.imageView.isUserInteractionEnabled = true
                cell3.imageView.addGestureRecognizer(tapGestureRecognizer3)
                
                return cell3
            default:
                let cell0 = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell_0", for: indexPath) as! ImageViewCell_0
                cell0.layer.cornerRadius = 30
                cell0.titleLabel.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imageName
                cell0.imageView.image = loadImage(named: setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imagePath)
                
                let tapGestureRecognizer0 = UITapGestureRecognizer(target: self, action: #selector(imageTapped0(tapGestureRecognizer:)))
                cell0.imageView.isUserInteractionEnabled = true
                cell0.imageView.addGestureRecognizer(tapGestureRecognizer0)
                
                return cell0
            }
        } else if setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].cardType == "routine" {
            let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: "routineCell", for: indexPath) as! ImageViewCell_routine1
            
            cell4.layer.cornerRadius = 30
            cell4.titleLabel.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imageName
            var nameArray = [String]()
            var imageArray = [UIImage]()
            let numberOfTags = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath.count
            cell4.count = numberOfTags
            for item in setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName {
                nameArray.append(item)
            }
            for item in setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath {
                imageArray.append(loadImage(named: item))
            }
            for _ in numberOfTags ..< 10 {
                nameArray.append(" ")
                imageArray.append(UIImage(named: "add")!)
            }
            
            cell4.imageNames = nameArray
            cell4.images = imageArray
            
            return cell4
        } else {
            let cell5 = collectionView.dequeueReusableCell(withReuseIdentifier: "sortedCell", for: indexPath) as! ImageViewCell_sorted1
            
            cell5.layer.cornerRadius = 30
            cell5.titleLabel.text = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].imageName
            var nameArray = [String]()
            var imageArray = [UIImage]()
            let numberOfTags = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath.count
            cell5.count = numberOfTags
            for item in setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagName {
                nameArray.append(item)
            }
            for item in setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[indexPath.item].tagPath {
                imageArray.append(loadImage(named: item))
            }
            for _ in numberOfTags ..< 12 {
                nameArray.append(" ")
                imageArray.append(UIImage(named: "add")!)
            }
            
            cell5.imageNames = nameArray
            cell5.images = imageArray
            
            return cell5
        }
    }
    
    override func viewDidLayoutSubviews() {
        if self.isBeingPresented || self.isMovingToParentViewController {
            let indexToScrollTo = IndexPath(item: whatIsIndexPath, section: 0)
            self.scrollCollectionView.scrollToItem(at: indexToScrollTo, at: .centeredHorizontally, animated: false)
        }
    }
    
    @objc func imageTapped0(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = UIColor.clear.cgColor
        color.toValue = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
        color.duration = 1
        tappedImage.layer.borderWidth = 6
        tappedImage.layer.borderColor = UIColor.clear.cgColor
        tappedImage.layer.add(color, forKey: "borderColor")
        
        let centerItem: IndexPath = (self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y)))!
        
        let item1 = scrollCollectionView.cellForItem(at: centerItem) as! ImageViewCell_0
        
        var charCount = 0
        
        if Array(item1.titleLabel.text!).count != 1 {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount < Array(item1.titleLabel.text!).count {
                    let range = (item1.titleLabel.text! as NSString).rangeOfComposedCharacterSequence(at: charCount)
                    let attributedText = NSMutableAttributedString.init(string: item1.titleLabel.text!)
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1), range: range)
                    item1.titleLabel.attributedText = attributedText
                    charCount += 1
                } else {
                    timer.invalidate()
                    item1.titleLabel.textColor = .black
                }
            })
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount == 0 {
                    item1.titleLabel.textColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
                    charCount += 1
                } else {
                    timer.invalidate()
                    item1.titleLabel.textColor = .black
                }
            })
        }
        
        synth?.stopSpeaking(at: .immediate)
        
        synth = AVSpeechSynthesizer()
        
        let item = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[centerItem.item].imageName
       
        let utterance = AVSpeechUtterance(string: item)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = speechSpeed
        
        synth?.speak(utterance)
    }
    
    @objc func imageTapped1(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = UIColor.clear.cgColor
        color.toValue = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
        color.duration = 1
        tappedImage.layer.borderWidth = 6
        tappedImage.layer.borderColor = UIColor.clear.cgColor
        tappedImage.layer.add(color, forKey: "borderColor")
        
        let centerItem: IndexPath = (self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y)))!
        
        let item1 = scrollCollectionView.cellForItem(at: centerItem) as! ImageViewCell_1
        
        var charCount = 0
        
        if Array(item1.titleLabel.text!).count != 1 {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount < Array(item1.titleLabel.text!).count {
                    let range = (item1.titleLabel.text! as NSString).rangeOfComposedCharacterSequence(at: charCount)
                    let attributedText = NSMutableAttributedString.init(string: item1.titleLabel.text!)
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1), range: range)
                    item1.titleLabel.attributedText = attributedText
                    charCount += 1
                } else {
                    timer.invalidate()
                    item1.titleLabel.textColor = .black
                }
            })
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount == 0 {
                    item1.titleLabel.textColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
                    charCount += 1
                } else {
                    timer.invalidate()
                    item1.titleLabel.textColor = .black
                }
            })
        }
        
        synth?.stopSpeaking(at: .immediate)
        
        synth = AVSpeechSynthesizer()
        
        let item = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[centerItem.item].imageName
        
        let utterance = AVSpeechUtterance(string: item)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = speechSpeed
        
        synth?.speak(utterance)
    }
    @objc func imageTapped2(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = UIColor.clear.cgColor
        color.toValue = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
        color.duration = 1
        tappedImage.layer.borderWidth = 6
        tappedImage.layer.borderColor = UIColor.clear.cgColor
        tappedImage.layer.add(color, forKey: "borderColor")
        
        let centerItem: IndexPath = (self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y)))!
        
        let item1 = scrollCollectionView.cellForItem(at: centerItem) as! ImageViewCell_2
        
        var charCount = 0
        
        if Array(item1.titleLabel.text!).count != 1 {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount < Array(item1.titleLabel.text!).count {
                    let range = (item1.titleLabel.text! as NSString).rangeOfComposedCharacterSequence(at: charCount)
                    let attributedText = NSMutableAttributedString.init(string: item1.titleLabel.text!)
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1), range: range)
                    item1.titleLabel.attributedText = attributedText
                    charCount += 1
                } else {
                    timer.invalidate()
                    item1.titleLabel.textColor = .black
                }
            })
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount == 0 {
                    item1.titleLabel.textColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
                    charCount += 1
                } else {
                    timer.invalidate()
                    item1.titleLabel.textColor = .black
                }
            })
        }
        
        synth?.stopSpeaking(at: .immediate)
        
        synth = AVSpeechSynthesizer()
        
        let item = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[centerItem.item].imageName
        
        let utterance = AVSpeechUtterance(string: item)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = speechSpeed
        
        synth?.speak(utterance)
    }
    @objc func imageTapped3(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = UIColor.clear.cgColor
        color.toValue = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
        color.duration = 1
        tappedImage.layer.borderWidth = 6
        tappedImage.layer.borderColor = UIColor.clear.cgColor
        tappedImage.layer.add(color, forKey: "borderColor")
        
        let centerItem: IndexPath = (self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y)))!
        
        let item1 = scrollCollectionView.cellForItem(at: centerItem) as! ImageViewCell_3
        
        var charCount = 0
        
        if Array(item1.titleLabel.text!).count != 1 {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount < Array(item1.titleLabel.text!).count {
                    let range = (item1.titleLabel.text! as NSString).rangeOfComposedCharacterSequence(at: charCount)
                    let attributedText = NSMutableAttributedString.init(string: item1.titleLabel.text!)
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1), range: range)
                    item1.titleLabel.attributedText = attributedText
                    charCount += 1
                } else {
                    timer.invalidate()
                    item1.titleLabel.textColor = .black
                }
            })
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount == 0 {
                    item1.titleLabel.textColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
                    charCount += 1
                } else {
                    timer.invalidate()
                    item1.titleLabel.textColor = .black
                }
            })
        }
        
        synth?.stopSpeaking(at: .immediate)
        
        synth = AVSpeechSynthesizer()
        
        let item = setCategoryArray(Array: imageSets, CategoryName: whatIsCategory)[centerItem.item].imageName
        
        let utterance = AVSpeechUtterance(string: item)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = speechSpeed
        
        synth?.speak(utterance)
    }
    
    @IBOutlet weak var scrollCollectionView: UICollectionView!
    
    var setItem: ImageSet?
    
    var whatIsCategory = String()
    var whatIsIndexPath = Int()
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        
        let centerItem: IndexPath = (self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y)))!
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle:  UIAlertController.Style.actionSheet)
        let exportAction: UIAlertAction = UIAlertAction(title: "카드 내보내기".localized(), style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            if let cell = self.scrollCollectionView.cellForItem(at: centerItem) {
                let img = self.createPreview(category: self.whatIsCategory, index: centerItem.item)
                
                let imgShare = [img]
                let activityViewController = UIActivityViewController(activityItems: imgShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                activityViewController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
                    if (!completed) {
                        return
                    }
                    cell.contentView.makeToast("카드를 사진첩에 저장했습니다".localized())
                }
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
        
        let moveAction: UIAlertAction = UIAlertAction(title: "카드 이동".localized(), style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            if let centerItem: IndexPath = (self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y))) {
                let storyboard = self.storyboard!
                let movecardVC: MoveCardViewController = storyboard.instantiateViewController(withIdentifier: "moveCard") as! MoveCardViewController
                movecardVC.willMoveArray = [setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].imagePath]
                let navController = UINavigationController(rootViewController: movecardVC)
                self.present(navController, animated: true, completion: nil)
            }
        })
        
        let editAction: UIAlertAction = UIAlertAction(title: "카드 수정".localized(), style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            if let centerItem: IndexPath = (self.scrollCollectionView.indexPathForItem(at: CGPoint(x: self.scrollCollectionView.center.x + self.scrollCollectionView.contentOffset.x, y: self.scrollCollectionView.center.y + self.scrollCollectionView.contentOffset.y))) {
                switch setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].cardType {
                case "default":
                    print(centerItem.item)
                    let targetController: MakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "defaultMake") as! MakeCardViewController
                    targetController.isFromEditing = true
                    var tagImgs = [UIImage]()
                    for item in setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].tagPath {
                        tagImgs.append(loadImage(named: item))
                    }
                    let tempImgPth = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].imagePath
                    targetController.tempImage = loadImage(named: tempImgPth)
                    targetController.prepareForAAC = true
                    targetController.tagImages = tagImgs
                    targetController.tempImagePath = tempImgPth
                    targetController.whatIsTitleText = self.whatIsCategory
                    targetController.tagNames = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].tagName
                    targetController.tempImgName = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].imageName
//                    targetController.willMoveArray = imgPathArray
                    let navController = UINavigationController(rootViewController: targetController)
                    self.present(navController, animated: true, completion: nil)
                case "routine":
                    let targetController: RoutineMakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "routineMake") as! RoutineMakeCardViewController
                    targetController.isFromEditing = true
                    var tagImgs = [UIImage]()
                    for item in setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].tagPath {
                        tagImgs.append(loadImage(named: item))
                    }
                    let tempImgPth = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].imagePath
                    targetController.images = tagImgs
                    targetController.imageNames = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].tagName
                    targetController.whatIsTitleText = self.whatIsCategory
                    targetController.tempImgName = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].imageName
                    targetController.tempImgPath = tempImgPth
                    
                    //                    targetController.willMoveArray = imgPathArray
                    let navController = UINavigationController(rootViewController: targetController)
                    self.present(navController, animated: true, completion: nil)
                default:
                    let targetController: SortedMakeCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "sortedMake") as! SortedMakeCardViewController
                    targetController.isFromEditing = true
                    var tagImgs = [UIImage]()
                    for item in setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].tagPath {
                        tagImgs.append(loadImage(named: item))
                    }
                    let tempImgPth = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].imagePath
                    targetController.images = tagImgs
                    targetController.imageNames = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].tagName
                    targetController.whatIsTitleText = self.whatIsCategory
                    targetController.tempImgName = setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].imageName
                    targetController.tempImgPath = tempImgPth
                    
                    //                    targetController.willMoveArray = imgPathArray
                    let navController = UINavigationController(rootViewController: targetController)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        })
        
        let informantAction: UIAlertAction = UIAlertAction(title: "카드 삭제".localized(), style: UIAlertAction.Style.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            var alert1: UIAlertController
            if self.whatIsCategory == "모든 카드" {
                alert1 = UIAlertController(title: nil, message: "해당 카드가 앱에서 삭제됩니다".localized(), preferredStyle: UIAlertController.Style.actionSheet)
                let deleteAction: UIAlertAction = UIAlertAction(title: "카드 삭제".localized(), style: UIAlertAction.Style.destructive, handler:{
                    (action: UIAlertAction!) -> Void in
                    _ = self.navigationController?.popViewController(animated: true)
                    imageSets = imageSets.filter({
                        $0.imagePath != imageSets[centerItem.item].imagePath
                    })
                    self.scrollCollectionView.deleteItems(at: [centerItem])
                    
                    if imageSets.count == 0 {
                        self.dismiss(animated: true, completion: nil)
                        self.albumDelegate.itemsCollectionView.reloadData()
                    }
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "취소".localized(), style: UIAlertAction.Style.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    
                })
                alert1.addAction(deleteAction)
                alert1.addAction(cancelAction)
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let popoverController = alert1.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        self.present(alert1, animated: true, completion: nil)
                    }
                } else {
                    self.present(alert1, animated: true, completion: nil)
                }
            } else {
                alert1 = UIAlertController(title: nil, message: "이 사진을 삭제하시겠습니까?".localized(), preferredStyle: UIAlertController.Style.actionSheet)
                let cardDeleteAction: UIAlertAction = UIAlertAction(title: "삭제".localized(), style: UIAlertAction.Style.destructive, handler:{
                    (action: UIAlertAction!) -> Void in
                    _ = self.navigationController?.popViewController(animated: true)
                    imageSets = imageSets.filter({
                        $0.imagePath != setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory)[centerItem.item].imagePath
                    })
                    self.scrollCollectionView.deleteItems(at: [centerItem])
                    if setCategoryArray(Array: imageSets, CategoryName: self.whatIsCategory).count == 0 {
                        self.dismiss(animated: true, completion: nil)
                        self.albumDelegate.itemsCollectionView.reloadData()
                    }
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "취소".localized(), style: UIAlertAction.Style.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                })
                alert1.addAction(cardDeleteAction)
                alert1.addAction(cancelAction)
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let popoverController = alert1.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        self.present(alert1, animated: true, completion: nil)
                    }
                } else {
                    self.present(alert1, animated: true, completion: nil)
                }
            }
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소".localized(), style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            
        })
        
        alert.addAction(editAction)
        alert.addAction(exportAction)
        alert.addAction(moveAction)
        alert.addAction(cancelAction)
        alert.addAction(informantAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    var titleString = String()
    var imagePathString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter2.dateFormat = "HH:mm:ss"
        dateFormatter3.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let layout = UPCarouselFlowLayout()
        switch UIDevice.current.screenResolutionType {
        case "iPhoneX":
            layout.itemSize = CGSize(width: view.bounds.width * 0.9, height: view.bounds.height * 0.76)
        default:
            layout.itemSize = CGSize(width: view.bounds.width * 0.9, height: view.bounds.height * 0.83)
        }
        layout.sideItemScale = 0.8
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
        scrollCollectionView.collectionViewLayout = layout
        
        scrollCollectionView.delegate = self
        scrollCollectionView.dataSource = self
        
        scrollCollectionView.reloadInputViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollCollectionView.reloadData()
        if setCategoryArray(Array: imageSets, CategoryName: whatIsCategory).count == 0 {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func createPreview(category: String, index: Int) -> UIImage {
        let tempImgSetForView: ImageSet = setCategoryArray(Array: imageSets, CategoryName: category)[index]
        switch tempImgSetForView.cardType {
        case "default":
            switch tempImgSetForView.tagName.count {
            case 0:
                let VC: ExportDefault0ViewController = UIStoryboard(name: "Export", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExportDefault0ViewController") as! ExportDefault0ViewController
                VC.loadViewIfNeeded()
                VC.imageView.image = loadImage(named: tempImgSetForView.imagePath)
                VC.titleLabel.text = tempImgSetForView.imageName
                let snapshot = VC.captureView.snapshot()
                return snapshot
            case 1:
                let VC: ExportDefault1ViewController = UIStoryboard(name: "Export", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExportDefault1ViewController") as! ExportDefault1ViewController
                VC.loadViewIfNeeded()
                VC.imageView.image = loadImage(named: tempImgSetForView.imagePath)
                VC.titleLabel.text = tempImgSetForView.imageName
                VC.tagImage1.image = loadImage(named: tempImgSetForView.tagPath[0])
                VC.tagLabel1.text = tempImgSetForView.tagName[0]
                let snapshot = VC.captureView.snapshot()
                return snapshot
            case 2:
                let VC: ExportDefault2ViewController = UIStoryboard(name: "Export", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExportDefault2ViewController") as! ExportDefault2ViewController
                VC.loadViewIfNeeded()
                VC.imageView.image = loadImage(named: tempImgSetForView.imagePath)
                VC.titleLabel.text = tempImgSetForView.imageName
                VC.tagImage1.image = loadImage(named: tempImgSetForView.tagPath[0])
                VC.tagLabel1.text = tempImgSetForView.tagName[0]
                VC.tagImage2.image = loadImage(named: tempImgSetForView.tagPath[1])
                VC.tagLabel2.text = tempImgSetForView.tagName[1]
                let snapshot = VC.captureView.snapshot()
                return snapshot
            default:
                let VC: ExportDefault3ViewController = UIStoryboard(name: "Export", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExportDefault3ViewController") as! ExportDefault3ViewController
                VC.loadViewIfNeeded()
                VC.imageView.image = loadImage(named: tempImgSetForView.imagePath)
                VC.titleLabel.text = tempImgSetForView.imageName
                VC.tagImage1.image = loadImage(named: tempImgSetForView.tagPath[0])
                VC.tagLabel1.text = tempImgSetForView.tagName[0]
                VC.tagImage2.image = loadImage(named: tempImgSetForView.tagPath[1])
                VC.tagLabel2.text = tempImgSetForView.tagName[1]
                VC.tagImage3.image = loadImage(named: tempImgSetForView.tagPath[2])
                VC.tagLabel3.text = tempImgSetForView.tagName[2]
                let snapshot = VC.captureView.snapshot()
                return snapshot
            }
        case "sorted":
            let VC: ExportSortedViewController = UIStoryboard(name: "Export", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExportSortedViewController") as! ExportSortedViewController
            VC.loadViewIfNeeded()
            VC.titleLabel.text = tempImgSetForView.imageName
            VC.imageNames = tempImgSetForView.tagName
            var tempImages = [UIImage]()
            for item in tempImgSetForView.tagPath {
                tempImages.append(loadImage(named: item))
            }
            VC.images = tempImages
            VC.reloadLayout()
            let snapshot = VC.captureView.snapshot()
            return snapshot
        default:
            let VC: ExportRoutineViewController = UIStoryboard(name: "Export", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExportRoutineViewController") as! ExportRoutineViewController
            VC.loadViewIfNeeded()
            VC.titleText = tempImgSetForView.imageName
            VC.imageNames = tempImgSetForView.tagName
            var tempImages = [UIImage]()
            for item in tempImgSetForView.tagPath {
                tempImages.append(loadImage(named: item))
            }
            VC.images = tempImages
            VC.reloadView()
            let snapshot = VC.captureView.snapshot()
            return snapshot
        }
    }
}

func sortedImageGenerator(imgSet: ImageSet) -> UIImage {
    let VC: ExportSortedViewController = UIStoryboard(name: "Export", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExportSortedViewController") as! ExportSortedViewController
    VC.loadViewIfNeeded()
    VC.titleLabel.text = imgSet.imageName
    VC.imageNames = imgSet.tagName
    var tempImages = [UIImage]()
    for item in imgSet.tagPath {
        tempImages.append(loadImage(named: item))
    }
    VC.images = tempImages
    VC.reloadLayout()
    let snapshot = VC.captureView.snapshot()
    return snapshot
}

func routineImageGenerator(imgSet: ImageSet) -> UIImage {
    let VC: ExportRoutineViewController = UIStoryboard(name: "Export", bundle: Bundle.main).instantiateViewController(withIdentifier: "ExportRoutineViewController") as! ExportRoutineViewController
    VC.loadViewIfNeeded()
    VC.titleText = imgSet.imageName
    VC.imageNames = imgSet.tagName
    var tempImages = [UIImage]()
    for item in imgSet.tagPath {
        tempImages.append(loadImage(named: item))
    }
    VC.images = tempImages
    VC.reloadView()
    let snapshot = VC.captureView.snapshot()
    return snapshot
}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 375, height: 647), self.isOpaque, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
