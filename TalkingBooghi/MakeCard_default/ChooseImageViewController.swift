//
//  ChooseImageViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 18/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import Firebase
import BetterSegmentedControl
import Localize_Swift

protocol PassAACBack {
    func passAACData(imgData: [UIImage], imgString: [String])
}

class ChooseImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    var aacDelegate: PassAACBack!
    
    var allPhotos = PHFetchResult<PHAsset>()
    let imageManager = PHCachingImageManager()
    var webImageArray = Array(repeating: UIImage(), count: 20)
    
    var selectedImages = [UIImage]()
    var selectedImageNames = [String]()
    
    var aacArray = [String]()
    
    @IBOutlet var segControl: BetterSegmentedControl! {
        didSet {
            segControl.segments = LabelSegment.segments(withTitles: ["AAC 상징검색".localized(), "웹 이미지 검색".localized(), "라이브러리".localized()], normalBackgroundColor: UIColor(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1), normalFont: UIFont(name: "HelveticaNeue-Light", size: 14.0)!, normalTextColor: .white, selectedBackgroundColor: .clear, selectedFont: UIFont(name: "HelveticaNeue-Light", size: 14.0)!, selectedTextColor: .blue)
            segControl.setIndex(0)
            segControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var totView: UIView! {
        didSet {
            totView.layer.cornerRadius = 20
            totView.clipsToBounds = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == aacCollectionView {
            return aacArray.count
        } else if collectionView == webCollectionView {
            return 20
        } else {
            return allPhotos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == aacCollectionView {
            let assetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "aacCell", for: indexPath) as! ChooseAACViewCell
            assetCell.imageView.image = UIImage(named: aacArray[indexPath.item])
            return assetCell
        } else if collectionView == webCollectionView {
            let assetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "webCell", for: indexPath) as! ChooseWebViewCell
            searchKeyword(keyword: webKeywordText, index: indexPath.item) { (image) in
                assetCell.imageView.image = image
                self.webImageArray[indexPath.item] = image
            }
            return assetCell
        } else {
            let assetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "chooseImageViewCell", for: indexPath) as! ChooseImageViewCell
            let asset = allPhotos.object(at: indexPath.item)
            
            assetCell.representedAssetIdentifier = asset.localIdentifier
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                if assetCell.representedAssetIdentifier == asset.localIdentifier {
                    assetCell.imageView.image = image
                }
            })
            return assetCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == aacCollectionView {
            if selectedImages.count < 3 {
                selectedImages.append(UIImage(named: aacArray[indexPath.item]) ?? UIImage())
                selectedImageNames.append(aacKeywordText)
                setBeforeLoad()
            }
        } else if collectionView == webCollectionView {
            if selectedImages.count < 3 {
                selectedImages.append(webImageArray[indexPath.item])
                selectedImageNames.append(webKeywordText)
                setBeforeLoad()
            }
        } else {
            getImageFromAsset(asset: allPhotos.object(at: indexPath.item), imageSize: CGSize(width: 500, height: 500)) { (img) in
                if self.selectedImages.count < 3 {
                    self.selectedImages.append(img)
                    self.selectedImageNames.append("이름 입력".localized())
                    self.setBeforeLoad()
                    
                }
            }
        }
    }
    @IBOutlet weak var deleteButton1: UIButton! {
        didSet {
            deleteButton1.isHidden = true
        }
    }
    @IBAction func deleteButton1Clicked(_ sender: UIButton) {
        switch selectedImages.count {
        case 1:
            deleteButton1.isHidden = true
            button1.setImage(UIImage(named: "choosingIcon"), for: .normal)
            button2.setImage(UIImage(named: "addsymbol"), for: .normal)
            button3.setImage(UIImage(named: "addsymbol"), for: .normal)
            symbolField1.text = ""
            symbolField1.isHidden = true
        case 2:
            deleteButton2.isHidden = true
            button1.setImage(selectedImages[1], for: .normal)
            button2.setImage(UIImage(named: "choosingIcon"), for: .normal)
            button3.setImage(UIImage(named: "addsymbol"), for: .normal)
            symbolField1.text = symbolField2.text
            symbolField2.text = ""
            symbolField2.isHidden = true
        default:
            deleteButton3.isHidden = true
            button1.setImage(selectedImages[1], for: .normal)
            button2.setImage(selectedImages[2], for: .normal)
            button3.setImage(UIImage(named: "choosingIcon"), for: .normal)
            symbolField1.text = symbolField2.text
            symbolField2.text = symbolField3.text
            symbolField3.text = ""
            symbolField3.isHidden = true
        }
        selectedImages.remove(at: 0)
        selectedImageNames.remove(at: 0)
        print(selectedImageNames)
    }
    @IBOutlet weak var deleteButton2: UIButton! {
        didSet {
            deleteButton2.isHidden = true
        }
    }
    @IBAction func deleteButton2Clicked(_ sender: UIButton) {
        switch selectedImages.count {
        case 2:
            deleteButton2.isHidden = true
            button2.setImage(UIImage(named: "choosingIcon"), for: .normal)
            button3.setImage(UIImage(named: "addsymbol"), for: .normal)
            symbolField2.text = ""
            symbolField2.isHidden = true
        default:
            deleteButton3.isHidden = true
            button2.setImage(selectedImages[2], for: .normal)
            button3.setImage(UIImage(named: "choosingIcon"), for: .normal)
            symbolField2.text = symbolField3.text
            symbolField3.text = ""
            symbolField3.isHidden = true
        }
        selectedImages.remove(at: 1)
        selectedImageNames.remove(at: 1)
        print(selectedImageNames)
    }
    @IBOutlet weak var deleteButton3: UIButton! {
        didSet {
            deleteButton3.isHidden = true
        }
    }
    @IBAction func deleteButton3Clicked(_ sender: UIButton) {
        deleteButton3.isHidden = true
        button3.setImage(UIImage(named: "choosingIcon"), for: .normal)
        selectedImages.remove(at: 2)
        selectedImageNames.remove(at: 2)
        symbolField3.text = ""
        symbolField3.isHidden = true
        print(selectedImageNames)
    }
    
    @IBOutlet weak var button1: UIButton! {
        didSet {
            button1.layer.cornerRadius = 10
            button1.clipsToBounds = true
            if let imgView = button1.imageView {
                imgView.contentMode = .scaleAspectFill
            }
        }
    }
    @IBOutlet weak var button2: UIButton! {
        didSet {
            button2.layer.cornerRadius = 10
            button2.clipsToBounds = true
            if let imgView = button2.imageView {
                imgView.contentMode = .scaleAspectFill
            }
        }
    }
    @IBOutlet weak var button3: UIButton! {
        didSet {
            button3.layer.cornerRadius = 10
            button3.clipsToBounds = true
            if let imgView = button3.imageView {
                imgView.contentMode = .scaleAspectFill
            }
        }
    }
    
    @IBOutlet weak var symbolField1: UITextField! {
        didSet {
            symbolField1.isHidden = true
            symbolField1.attributedPlaceholder = NSAttributedString(string: "이름 입력".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        }
    }
    @IBOutlet weak var symbolField2: UITextField! {
        didSet {
            symbolField2.isHidden = true
            symbolField2.attributedPlaceholder = NSAttributedString(string: "이름 입력".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        }
    }
    @IBOutlet weak var symbolField3: UITextField! {
        didSet {
            symbolField3.isHidden = true
            symbolField3.attributedPlaceholder = NSAttributedString(string: "이름 입력".localized(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        }
    }
    
    @IBAction func symbolField1Typing(_ sender: UITextField) {
        selectedImageNames[0] = sender.text ?? "이름 없음".localized()
        print(selectedImageNames)
    }
    @IBAction func symbolField2Typing(_ sender: UITextField) {
        selectedImageNames[1] = sender.text ?? "이름 없음".localized()
        print(selectedImageNames)
    }
    @IBAction func symbolField3Typing(_ sender: UITextField) {
        selectedImageNames[2] = sender.text ?? "이름 없음".localized()
        print(selectedImageNames)
    }
    
    @IBOutlet weak var aacSearchBar: UISearchBar!
    @IBOutlet weak var webSearchBar: UISearchBar!
    @IBOutlet weak var everyPicsLabel: UILabel!
    @IBOutlet weak var aacCollectionView: UICollectionView!
    @IBOutlet weak var webCollectionView: UICollectionView!
    @IBOutlet weak var chooseCollcetionView: UICollectionView!
    
    var currentCollectionViewIndex = 2
    
    var aacKeywordText = String()
    var webKeywordText = String()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar == aacSearchBar {
            aacArray = []
            aacKeywordText = searchBar.text!
            aacArray = dataSet.filter {
                $0.contains(aacKeywordText)
            }
            self.aacCollectionView.reloadData()
        } else {
            webKeywordText = searchBar.text!
            webImageArray = Array(repeating: UIImage(), count: 20)
            self.webCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllPhotos()
        
        aacCollectionView.delegate = self
        aacCollectionView.dataSource = self
        webCollectionView.delegate = self
        webCollectionView.dataSource = self
        chooseCollcetionView.delegate = self
        chooseCollcetionView.dataSource = self
        aacSearchBar.delegate = self
        webSearchBar.delegate = self
        symbolField1.delegate = self
        symbolField2.delegate = self
        symbolField3.delegate = self
        
        aacLayout()
        
        let layout = self.aacCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: 2,left: 2,bottom: 2,right: 2)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let itemWidth: CGFloat = (self.aacCollectionView.frame.size.width - 10)/4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let layout1 = self.webCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout1.sectionInset = UIEdgeInsets.init(top: 2,left: 2,bottom: 2,right: 2)
        layout1.minimumInteritemSpacing = 2
        layout1.minimumLineSpacing = 2
        let itemWidth1: CGFloat = (self.webCollectionView.frame.size.width - 10)/4
        layout1.itemSize = CGSize(width: itemWidth1, height: itemWidth1)
        
        let layout2 = self.chooseCollcetionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout2.sectionInset = UIEdgeInsets.init(top: 2,left: 2,bottom: 2,right: 2)
        layout2.minimumInteritemSpacing = 2
        layout2.minimumLineSpacing = 2
        let itemWidth2: CGFloat = (self.chooseCollcetionView.frame.size.width - 10)/4
        layout2.itemSize = CGSize(width: itemWidth2, height: itemWidth2)
        
        setBeforeLoad()
    }
    
    func fetchAllPhotos() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        chooseCollcetionView.reloadData()
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func segmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
            case 0:
            aacLayout()
            case 1:
            webLayout()
            default:
            libraryLayout()
        }
    }
    
    func aacLayout() {
        currentCollectionViewIndex = 0
        aacSearchBar.isHidden = false
        webSearchBar.isHidden = true
        everyPicsLabel.isHidden = true
        aacCollectionView.isHidden = false
        webCollectionView.isHidden = true
        chooseCollcetionView.isHidden = true
    }
    func webLayout() {
        currentCollectionViewIndex = 1
        aacSearchBar.isHidden = true
        webSearchBar.isHidden = false
        everyPicsLabel.isHidden = true
        aacCollectionView.isHidden = true
        webCollectionView.isHidden = false
        chooseCollcetionView.isHidden = true
    }
    func libraryLayout() {
        currentCollectionViewIndex = 2
        aacSearchBar.isHidden = true
        webSearchBar.isHidden = true
        everyPicsLabel.isHidden = false
        aacCollectionView.isHidden = true
        webCollectionView.isHidden = true
        chooseCollcetionView.isHidden = false
    }
    @IBAction func doneClicked(_ sender: UIButton) {
        aacDelegate.passAACData(imgData: selectedImages, imgString: selectedImageNames)
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setBeforeLoad() {
        switch selectedImages.count {
        case 1:
            button1.setImage(selectedImages[0], for: .normal)
            button1.alpha = 1
            deleteButton1.isHidden = false
            symbolField1.isHidden = false
            symbolField1.text = selectedImageNames[0]
            button2.setImage(UIImage(named: "choosingIcon"), for: .normal)
            button2.alpha = 0.5
            symbolField2.isHidden = true
            button3.setImage(UIImage(named: "addsymbol"), for: .normal)
            button3.alpha = 0.5
            symbolField3.isHidden = true
        case 2:
            button1.setImage(selectedImages[0], for: .normal)
            button1.alpha = 1
            deleteButton1.isHidden = false
            symbolField1.isHidden = false
            symbolField1.text = selectedImageNames[0]
            button2.setImage(selectedImages[1], for: .normal)
            button2.alpha = 1
            deleteButton2.isHidden = false
            symbolField2.isHidden = false
            symbolField2.text = selectedImageNames[1]
            button3.setImage(UIImage(named: "choosingIcon"), for: .normal)
            button3.alpha = 0.5
            symbolField3.isHidden = true
        case 3:
            button1.setImage(selectedImages[0], for: .normal)
            button1.alpha = 1
            deleteButton1.isHidden = false
            symbolField1.isHidden = false
            symbolField1.text = selectedImageNames[0]
            button2.setImage(selectedImages[1], for: .normal)
            button2.alpha = 1
            deleteButton2.isHidden = false
            symbolField2.isHidden = false
            symbolField2.text = selectedImageNames[1]
            button3.setImage(selectedImages[2], for: .normal)
            button3.alpha = 1
            deleteButton3.isHidden = false
            symbolField3.isHidden = false
            symbolField3.text = selectedImageNames[2]
        default:
            break
        }
    }
    /*func detectLabels(image: UIImage?, index: Int) {
        let options = VisionLabelDetectorOptions(confidenceThreshold: 0.5)
        let labelDetector = vision.labelDetector(options: options)
        let imageConverted = VisionImage(image: image ?? UIImage())
        labelDetector.detect(in: imageConverted) { features, error in
            guard error == nil, let features = features, !features.isEmpty else {
                return
            }
            if !features.isEmpty {
                switch index {
                case 1:
                    translateTextToString(stringToBeTranslated: features[0].label, completion: { (str) in
                        self.selectedImageNames[1] = str
                        self.setBeforeLoad()
                    })
                case 2:
                    translateTextToString(stringToBeTranslated: features[0].label, completion: { (str) in
                        self.selectedImageNames[2] = str
                        self.setBeforeLoad()
                    })
                default:
                    translateTextToString(stringToBeTranslated: features[0].label, completion: { (str) in
                        self.selectedImageNames[0] = str
                        self.setBeforeLoad()
                    })
                }
                self.setBeforeLoad()
            }
        }
    }*/
}

func getImageFromAsset(asset:PHAsset, imageSize:CGSize, callback:@escaping (_ result:UIImage) -> Void) -> Void {
    let requestOptions = PHImageRequestOptions()
    requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
    requestOptions.isNetworkAccessAllowed = true
    requestOptions.isSynchronous = true
    PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (currentImage, info) in
        callback(currentImage!)
    })
}
