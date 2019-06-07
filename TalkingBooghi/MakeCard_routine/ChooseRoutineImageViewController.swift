//
//  ChooseRoutineImageViewController.swift
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
import KRPullLoader
import Localize_Swift

protocol SendOneImage {
    func receiveImage(img: [UIImage], strings: [String])
}

protocol SendOneImageToSorted {
    func receiveImage(img: [UIImage], strings: [String])
}

class ChooseRoutineImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, AddedCellDelegate, KRPullLoadViewDelegate {
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    completionHandler()
                    self.howManyWebImages += 10
                    self.webImageArray += Array(repeating: UIImage(), count: 10)
                    self.routineWebCollectionView.reloadData()
                }
            default: break
            }
            return
        }
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "더 당기세요"
            } else {
                pullLoadView.messageLabel.text = "놓아서 이미지 더 불러오기"
            }
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "로드중..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
                self.routineWebCollectionView.reloadData()
            }
        }
    }
    
    
    var titleString = String()
    
    var howManyWebImages = 20
    
    var tempAACArray = [String]()
    
    func renew(cell: ChooseRoutineAddedViewCell) {
        if let num = self.choosingCollectionView.indexPath(for: cell)?.item {
            selectedString[num] = cell.addedTextField.text ?? "이름 없음"
        }
    }
    
    func delete(cell: ChooseRoutineAddedViewCell) {
        if let num = self.choosingCollectionView.indexPath(for: cell)?.item {
            print(num)
            selectedImage.remove(at: num)
            selectedString.remove(at: num)
        }
        self.choosingCollectionView.reloadData()
    }
    
    var routinePickerDelegate: SendOneImage?
    var sortedPickerDelegate: SendOneImageToSorted?
    
    var receivingFrom = String()
    
    var receivingIndexPath = Int()
    
    var allPhotos: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    var webImageArray = Array(repeating: UIImage(), count: 20)
    
    var routineAacKeywordText = String()
    var routineWebKeywordText = String()
    
    var aacKeywordText = String()
    var aacArray = [String]()
    
    var selectedImage = [UIImage]()
    var selectedString = [String]()
    
    @IBOutlet weak var totView: UIView! {
        didSet {
            totView.clipsToBounds = true
            totView.layer.cornerRadius = 20
        }
    }
    
    @IBAction func doneClicked(_ sender: UIButton) {
        choosingCollectionView.reloadData()
        if receivingFrom == "Routine" {
            routinePickerDelegate?.receiveImage(img: selectedImage, strings: selectedString)
        } else {
            sortedPickerDelegate?.receiveImage(img: selectedImage, strings: selectedString)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == routineAacCollectionView {
            return aacArray.count
        } else if collectionView == routineWebCollectionView {
            return howManyWebImages
        } else if collectionView == choosingCollectionView {
            if receivingFrom == "Routine" {
                return 10
            } else {
                return 12
            }
        } else {
            return allPhotos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == routineAacCollectionView {
            let assetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "routineAacCell", for: indexPath) as! RoutineAacViewCell
            assetCell.imageView.image = UIImage(named: aacArray[indexPath.item])
            return assetCell
        } else if collectionView == routineWebCollectionView {
            let assetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "routineWebCell", for: indexPath) as! RoutineWebViewCell
            searchKeyword(keyword: routineWebKeywordText, index: indexPath.item) { (image) in
                assetCell.imageView.image = image
                self.webImageArray[indexPath.item] = image
            }
            return assetCell
        } else if collectionView == choosingCollectionView {
            if indexPath.item == selectedImage.count {
                let cell234 = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseRoutineDefault", for: indexPath) as! ChooseRoutineDefaultViewCell
                cell234.addingImage.image = UIImage(named: "choosingIcon")
                return cell234
            } else if indexPath.item < selectedImage.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseAddedOne", for: indexPath) as! ChooseRoutineAddedViewCell
                cell.addedImage.image = selectedImage[indexPath.item]
                cell.addedTextField.text = selectedString[indexPath.item]
                cell.delegate = self
                return cell
            } else {
                let cell22212 = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseRoutineDefault", for: indexPath) as! ChooseRoutineDefaultViewCell
                cell22212.addingImage.image = UIImage(named: "addsymbol")
                return cell22212
            }
        }
        else {
            let assetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "routineChooseImageViewCell", for: indexPath) as! RoutineChooseViewCell
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
        if (receivingFrom == "Routine" && selectedImage.count < 10) || (receivingFrom == "Sorted" && selectedImage.count < 12) {
            if collectionView == routineAacCollectionView {
                selectedImage.append(UIImage(named: aacArray[indexPath.item]) ?? UIImage())
                selectedString.append(routineAacSearchBar.text ?? "")
            } else if collectionView == routineWebCollectionView {
                selectedImage.append(webImageArray[indexPath.item])
                selectedString.append("")
            } else if collectionView == choosingCollectionView {
            } else {
                getImageFromAsset(asset: allPhotos.object(at: indexPath.item), imageSize: CGSize(width: 500, height: 500)) { (assetImage) in
                    self.selectedImage.append(assetImage)
                    self.selectedString.append("")
                    
                }
            }
            self.choosingCollectionView.reloadData()
        }
    }

    @IBOutlet weak var routineSegControl: BetterSegmentedControl! {
        didSet {
            routineSegControl.segments = LabelSegment.segments(withTitles: ["AAC 상징검색".localized(), "웹 이미지 검색".localized(), "라이브러리".localized()], normalBackgroundColor: UIColor(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1), normalFont: UIFont(name: "HelveticaNeue-Light", size: 14.0)!, normalTextColor: .white, selectedBackgroundColor: .clear, selectedFont: UIFont(name: "HelveticaNeue-Light", size: 14.0)!, selectedTextColor: .blue)
            routineSegControl.setIndex(UInt(currentCollectionViewIndex))
            routineSegControl.addTarget(self, action: #selector(self.routineSegmentedControlValueChanged(_:)), for: .valueChanged)
        }
    }
    @IBOutlet weak var routineAacSearchBar: UISearchBar!
    @IBOutlet weak var routineWebSearchBar: UISearchBar!
    @IBOutlet weak var routineEveryLabel: UILabel!
    
    
    @IBOutlet weak var choosingCollectionView: UICollectionView!
    @IBOutlet weak var routineAacCollectionView: UICollectionView!
    @IBOutlet weak var routineWebCollectionView: UICollectionView!
    @IBOutlet weak var routineLibraryCollectionView: UICollectionView!
    
    var currentCollectionViewIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshView = KRPullLoadView()
        refreshView.delegate = self
        routineWebCollectionView.addPullLoadableView(refreshView, type: .loadMore)
        
        
        fetchAllPhotos()
        
        routineAacCollectionView.delegate = self
        routineAacCollectionView.dataSource = self
        routineWebCollectionView.delegate = self
        routineWebCollectionView.dataSource = self
        choosingCollectionView.delegate = self
        choosingCollectionView.dataSource = self
        routineLibraryCollectionView.delegate = self
        routineLibraryCollectionView.dataSource = self
        routineAacSearchBar.delegate = self
        routineWebSearchBar.delegate = self

        
        switch currentCollectionViewIndex {
        case 0:
            routineAacLayout()
        case 1:
            routineWebLayout()
        default:
            routineLibraryLayout()
        }
        
        let layout = self.routineAacCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: 2,left: 2,bottom: 2,right: 2)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let itemWidth: CGFloat = (self.routineAacCollectionView.frame.size.width - 10)/4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let layout1 = self.routineWebCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout1.sectionInset = UIEdgeInsets.init(top: 2,left: 2,bottom: 2,right: 2)
        layout1.minimumInteritemSpacing = 2
        layout1.minimumLineSpacing = 2
        let itemWidth1: CGFloat = (self.routineWebCollectionView.frame.size.width - 6)/2
        layout1.itemSize = CGSize(width: itemWidth1, height: itemWidth1)
        
        
        
        let layout2 = self.routineLibraryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout2.sectionInset = UIEdgeInsets.init(top: 2,left: 2,bottom: 2,right: 2)
        layout2.minimumInteritemSpacing = 2
        layout2.minimumLineSpacing = 2
        let itemWidth2: CGFloat = (self.routineLibraryCollectionView.frame.size.width - 10)/4
        layout2.itemSize = CGSize(width: itemWidth2, height: itemWidth2)
        
        let layout3 = self.choosingCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout3.minimumInteritemSpacing = 10
        layout3.itemSize = CGSize(width: 90,height: 130)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar == routineAacSearchBar {
            aacArray = []
            aacKeywordText = searchBar.text!
            aacArray = dataSet.filter {
                $0.contains(aacKeywordText)
            }
            self.routineAacCollectionView.reloadData()
        } else {
            howManyWebImages = 20
            routineWebKeywordText = searchBar.text!
            webImageArray = Array(repeating: UIImage(), count: 20)
            self.routineWebCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            self.routineWebCollectionView.reloadData()
        }
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func fetchAllPhotos() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        routineLibraryCollectionView.reloadData()
    }
    
    @objc func routineSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
        case 0:
            routineAacLayout()
        case 1:
            routineWebLayout()
        default:
            routineLibraryLayout()
        }
    }
    
    func routineAacLayout() {
        currentCollectionViewIndex = 0
        routineAacSearchBar.isHidden = false
        routineWebSearchBar.isHidden = true
        routineEveryLabel.isHidden = true
        routineAacCollectionView.isHidden = false
        routineWebCollectionView.isHidden = true
        routineLibraryCollectionView.isHidden = true
    }
    func routineWebLayout() {
        currentCollectionViewIndex = 1
        routineAacSearchBar.isHidden = true
        routineWebSearchBar.isHidden = false
        routineEveryLabel.isHidden = true
        routineAacCollectionView.isHidden = true
        routineWebCollectionView.isHidden = false
        routineLibraryCollectionView.isHidden = true
    }
    func routineLibraryLayout() {
        currentCollectionViewIndex = 2
        routineAacSearchBar.isHidden = true
        routineWebSearchBar.isHidden = true
        routineEveryLabel.isHidden = false
        routineAacCollectionView.isHidden = true
        routineWebCollectionView.isHidden = true
        routineLibraryCollectionView.isHidden = false
    }
    
    
    /*func detectLabelsForAAC(image: UIImage?, completion: @escaping (String) -> Void) {
        let options = VisionLabelDetectorOptions(confidenceThreshold: 0.5)
        let labelDetector = vision.labelDetector(options: options)
        let imageConverted = VisionImage(image: image ?? UIImage())
        labelDetector.detect(in: imageConverted) { features, error in
            guard error == nil, let features = features, !features.isEmpty else {
                completion("이름 추가")
                return
            }
            if !features.isEmpty {
                let selectedFromLangCode = "en"
                let selectedToLangCode = "ko"
                
                struct encodeText: Codable {
                    var text = String()
                }
                
                let azureKey = "54ddfb9634d0462eb5b64d92dd5acd48"
                
                let contentType = "application/json"
                let traceID = "A14C9DB9-0DED-48D7-8BBE-C517A1A8DBB0"
                let host = "dev.microsofttranslator.com"
                let apiURL = "https://dev.microsofttranslator.com/translate?api-version=3.0&from=" + selectedFromLangCode + "&to=" + selectedToLangCode
                
                let text2Translate = features[0].label
                var encodeTextSingle = encodeText()
                var toTranslate = [encodeText]()
                let jsonEncoder = JSONEncoder()
                
                encodeTextSingle.text = text2Translate
                toTranslate.append(encodeTextSingle)
                
                let jsonToTranslate = try? jsonEncoder.encode(toTranslate)
                let url = URL(string: apiURL)
                var request = URLRequest(url: url!)
                
                request.httpMethod = "POST"
                request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
                request.addValue(host, forHTTPHeaderField: "Host")
                request.addValue(String(describing: jsonToTranslate?.count), forHTTPHeaderField: "Content-Length")
                request.httpBody = jsonToTranslate
                
                let config = URLSessionConfiguration.default
                let session =  URLSession(configuration: config)
                
                let task = session.dataTask(with: request) { (responseData, response, responseError) in
                    if responseError != nil {
                        print("this is the error ", responseError!)
                    }
                    print("*****")
                    struct ReturnedJson: Codable {
                        var translations: [TranslatedStrings]
                    }
                    struct TranslatedStrings: Codable {
                        var text: String
                        var to: String
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    if let rData = responseData {
                        let langTranslations = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: rData)
                        let numberOfTranslations = langTranslations!.count - 1
                        
                        DispatchQueue.main.async {
                            if let langTrans = langTranslations {
                                completion(langTrans[0].translations[numberOfTranslations].text)
                                self.choosingCollectionView.reloadData()
                            } else {
                                completion(text2Translate)
                                self.choosingCollectionView.reloadData()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(text2Translate)
                            self.choosingCollectionView.reloadData()
                        }
                    }
                }
                task.resume()
            }
        }
    }*/
}

func suggestAAC(str: String) -> [String] {
    if str.count <= 1 {
        return []
    } else {
        var tempStrArray = [String]()
        for i in 0..<str.count-1 {
            let start = String.Index(encodedOffset: i)
            let end = String.Index(encodedOffset: i+1)
            let tempStr = str[start...end]
            let tempTemp = dataSet.filter {
                $0.contains(tempStr)
            }
            tempStrArray += tempTemp
            tempStrArray = Array(Set(tempStrArray))
            if tempStrArray.count >= 10 {
                let tempSlice = tempStrArray[0..<10]
                return Array(tempSlice)
            }
        }
        return tempStrArray
    }
}
