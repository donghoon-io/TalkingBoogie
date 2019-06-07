//
//  MakeCardViewController.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 20..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit
import Firebase
import Localize_Swift

class MakeCardViewController: UIViewController, UITextFieldDelegate, SendImageProtocol, SendAACProtocol, PassAACBack {
    
    var prepareForAAC = false
    
    var isFromEditing = false
    var tempImgName = String()
    var tempImagePath = String()
    var tempImage = UIImage()
    var tempImgSetForEditing: ImageSet?
    var tempIndex: Int?
    
    func passAACData(imgData: [UIImage], imgString: [String]) {
        tagImages = imgData
        tagNames = imgString
        
        setTagImages()
    }
    
    func sendImage(image: UIImage) {
        addedImage.image = image
        //detectLabels(image: image, txtField: textField)
    }
    
    @IBOutlet weak var addedImage: UIImageView! {
        didSet {
            addedImage.clipsToBounds = true
            addedImage.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
            addedImage.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)
            addedImage.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
            addedImage.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .vertical)
        }
    }
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "제목을 입력해주세요".localized()
        }
    }
    
    @IBOutlet weak var cancelClicked: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    @IBOutlet weak var totView: UIView! {
        didSet {
            totView.layer.cornerRadius = 20
            totView.clipsToBounds = true
        }
    }
    
    var whatIsTitleText: String?
    
    var imageSource: UIImage?
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelClicked.isEnabled = false
        doneButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelClicked.isEnabled = true
        doneButton.isEnabled = true
        addButton.isEnabled = true
    }
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        if !isFromEditing {
            if addedImage.image != UIImage(named: "add") {
                let nowDate = getTodayString()
                var tagPathSets = [String]()
                for (index, _) in tagImages.enumerated() {
                    let tagPathName = nowDate + "tag" + String(index)
                    tagPathSets.append(tagPathName)
                    saveDocumentImage(img: tagImages[index], imgPath: tagPathName)
                }
                imageSets.insert(ImageSet.init(category: whatIsTitleText!, imageName: textField.text!, imagePath: nowDate, tagName: tagNames, tagPath: tagPathSets, cardType: "default", isEditable: true), at: 0)
                saveDocumentImage(img: addedImage.image!, imgPath: nowDate)
                
                self.dismiss(animated: true, completion: nil)
            } else {
                textField.text = ""
                textField.placeholder = "이미지를 추가해주세요".localized()
            }
        } else {
            if addedImage.image != UIImage(named: "add") {
                var index = Int()
                index = imageSets.firstIndex(where: {
                    $0.imagePath == tempImgSetForEditing!.imagePath
                }) ?? 0
                imageSets.removeAll {
                    $0.imagePath == tempImgSetForEditing!.imagePath
                }
                let nowDate = getTodayString()
                var tagPathSets = [String]()
                for (index, _) in tagImages.enumerated() {
                    let tagPathName = nowDate + "tag" + String(index)
                    tagPathSets.append(tagPathName)
                    saveDocumentImage(img: tagImages[index], imgPath: tagPathName)
                }
                imageSets.insert(ImageSet.init(category: whatIsTitleText!, imageName: textField.text!, imagePath: nowDate, tagName: tagNames, tagPath: tagPathSets, cardType: "default", isEditable: true), at: index)
                saveDocumentImage(img: addedImage.image!, imgPath: nowDate)
                if tempImgSetForEditing!.isEditable {
                    for item in tempImgSetForEditing!.tagPath {
                        deleteDocumentImage(imgPath: item)
                    }
                    deleteDocumentImage(imgPath: tempImgSetForEditing!.imagePath)
                }
                self.dismiss(animated: true, completion: nil)
            } else {
                textField.text = ""
                textField.placeholder = "이미지를 추가해주세요".localized()
            
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let selectAlert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let aacAction: UIAlertAction = UIAlertAction(title: "AAC 상징 추가", style: .default) { (action) in
            self.performSegue(withIdentifier: "goAACadd", sender: self)
        }
        let webImageAction: UIAlertAction = UIAlertAction(title: "웹 이미지 검색".localized(), style: .default) { (action) in
            self.performSegue(withIdentifier: "goSearch", sender: self)
        }
        let takePicAction: UIAlertAction = UIAlertAction(title: "사진 촬영".localized(), style: .default) { (action) in
            self.openCamera()
        }
        let libraryAction: UIAlertAction = UIAlertAction(title: "라이브러리".localized(), style: .default) { (action) in
            self.openLibrary()
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소".localized(), style: .cancel, handler: nil)
        selectAlert.addAction(aacAction)
        selectAlert.addAction(webImageAction)
        selectAlert.addAction(takePicAction)
        selectAlert.addAction(libraryAction)
        selectAlert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            self.present(selectAlert, animated: true, completion: nil)
        } else {
            if let popoverController = selectAlert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(selectAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tagChoose1Clicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goChooseTag", sender: self)
    }
    @IBAction func tagChoose2Clicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goChooseTag", sender: self)
    }
    @IBAction func tagChoose3Clicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goChooseTag", sender: self)
    }
    @IBOutlet weak var defaultButton1: UIButton! {
        didSet {
            defaultButton1.clipsToBounds = true
            defaultButton1.isEnabled = false
            defaultButton1.layer.cornerRadius = 10
            if let imgView = defaultButton1.imageView {
                imgView.contentMode = .scaleAspectFill
            }
        }
    }
    @IBOutlet weak var defaultButton2: UIButton! {
        didSet {
            defaultButton2.clipsToBounds = true
            defaultButton2.isEnabled = false
            defaultButton2.layer.cornerRadius = 10
            if let imgView = defaultButton2.imageView {
                imgView.contentMode = .scaleAspectFill
            }
        }
    }
    @IBOutlet weak var defaultButton3: UIButton! {
        didSet {
            defaultButton3.clipsToBounds = true
            defaultButton3.isEnabled = false
            defaultButton3.layer.cornerRadius = 10
            if let imgView = defaultButton3.imageView {
                imgView.contentMode = .scaleAspectFill
            }
        }
    }
    @IBOutlet weak var tagLabel1: UILabel!
    @IBOutlet weak var tagLabel2: UILabel!
    @IBOutlet weak var tagLabel3: UILabel!
    
    var tagImages = [UIImage]()
    var tagNames = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
        if !prepareForAAC {
            if addedImage.image != UIImage(named: "add") {
                defaultButton1.setImage(UIImage(named: "addsymbolplus_activated"), for: .normal)
                defaultButton1.isEnabled = true
                tagLabel1.textColor = UIColor(red: 123/255.0, green: 191/255.0, blue: 232/255.0, alpha: 1)
                prepareForAAC = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        navigationController?.navigationBar.barTintColor = UIColor(red: 59/255.0, green: 60/255.0, blue: 68/255.0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        textField.delegate = self
        
        if isFromEditing {
            textField.text = tempImgName
            addedImage.image = tempImage
            self.title = "카드 수정하기".localized()
            tempImgSetForEditing = imageSets.filter({
                $0.imagePath == tempImagePath
            })[0]
            setTagImages()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAdd" {
            let fourthController = segue.destination as! AddWordViewController
            fourthController.imageToBeSet = self.imageSource!
            if textField.text != "" {
                fourthController.title = textField.text
            } else {
                fourthController.title = textField.placeholder
            }
            fourthController.categoryString = whatIsTitleText!
        } else if segue.identifier == "goSearch" {
            let searchController = segue.destination as! SearchViewController
            searchController.imageDelegate = self
        } else if segue.identifier == "goChooseTag" {
            let aacAddController = segue.destination as! ChooseImageViewController
            aacAddController.aacDelegate = self
            aacAddController.selectedImages = self.tagImages
            aacAddController.selectedImageNames = self.tagNames
        } else if segue.identifier == "goAACadd" {
            let addAACController = segue.destination as! SearchAACViewController
            addAACController.imageDelegate = self
        }
    }
    
    /*func detectLabels(image: UIImage?, txtField: UITextField) {
        let options = VisionLabelDetectorOptions(confidenceThreshold: 0.5)
        let labelDetector = vision.labelDetector(options: options)
        let imageConverted = VisionImage(image: image ?? UIImage())
        labelDetector.detect(in: imageConverted) { features, error in
            guard error == nil, let features = features, !features.isEmpty else {
                return
            }
            if !features.isEmpty {
                translateText(stringToBeTranslated: features[0].label, txtField: txtField)
//                txtField.text = features[0].label
            }
        }
    }*/
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        }
        else {
            print("Camera not available")
        }
    }
    
    func setTagImages() {
        if tagImages.indices.contains(0) && !tagImages.indices.contains(1) {
            self.defaultButton1.setImage(tagImages[0], for: .normal)
            self.defaultButton1.isEnabled = true
            self.tagLabel1.textColor = UIColor.lightGray
            self.tagLabel1.text = tagNames[0]
            self.defaultButton2.setImage(UIImage(named: "addsymbolplus_activated"), for: .normal)
            self.defaultButton2.isEnabled = true
            self.tagLabel2.textColor = UIColor(red: 123/255.0, green: 191/255.0, blue: 232/255.0, alpha: 1)
            self.tagLabel2.text = "상징 추가하기".localized()
            self.defaultButton3.setImage(UIImage(named: "addsymbolplus"), for: .normal)
            self.defaultButton3.isEnabled = false
            self.tagLabel3.textColor = UIColor.lightGray
            self.tagLabel3.text = "상징 추가하기".localized()
        }
        if tagImages.indices.contains(1) && !tagImages.indices.contains(2) {
            self.defaultButton1.setImage(tagImages[0], for: .normal)
            self.defaultButton1.isEnabled = true
            self.tagLabel1.textColor = UIColor.lightGray
            self.tagLabel1.text = tagNames[0]
            self.defaultButton2.setImage(tagImages[1], for: .normal)
            self.defaultButton2.isEnabled = true
            self.tagLabel2.textColor = UIColor.lightGray
            self.tagLabel2.text = tagNames[1]
            self.defaultButton3.setImage(UIImage(named: "addsymbolplus_activated"), for: .normal)
            self.defaultButton3.isEnabled = true
            self.tagLabel3.textColor = UIColor(red: 123/255.0, green: 191/255.0, blue: 232/255.0, alpha: 1)
            self.tagLabel3.text = "상징 추가하기".localized()
        }
        if tagImages.indices.contains(2) {
            self.defaultButton1.setImage(tagImages[0], for: .normal)
            self.defaultButton1.isEnabled = true
            self.tagLabel1.textColor = UIColor.lightGray
            self.tagLabel1.text = tagNames[0]
            self.defaultButton2.setImage(tagImages[1], for: .normal)
            self.defaultButton2.isEnabled = true
            self.tagLabel2.textColor = UIColor.lightGray
            self.tagLabel2.text = tagNames[1]
            self.defaultButton3.setImage(tagImages[2], for: .normal)
            self.defaultButton3.isEnabled = true
            self.tagLabel3.textColor = UIColor.lightGray
            self.tagLabel3.text = tagNames[2]
        }
        if !tagImages.indices.contains(0) {
            self.defaultButton1.setImage(UIImage(named: "addsymbolplus_activated"), for: .normal)
            self.defaultButton1.isEnabled = true
            self.tagLabel1.textColor = UIColor(red: 123/255.0, green: 191/255.0, blue: 232/255.0, alpha: 1)
            self.tagLabel1.text = "상징 추가하기".localized()
            self.defaultButton2.setImage(UIImage(named: "addsymbolplus"), for: .normal)
            self.defaultButton2.isEnabled = false
            self.tagLabel2.textColor = UIColor.lightGray
            self.tagLabel2.text = "상징 추가하기".localized()
            self.defaultButton3.setImage(UIImage(named: "addsymbolplus"), for: .normal)
            self.defaultButton3.isEnabled = false
            self.tagLabel3.textColor = UIColor.lightGray
            self.tagLabel3.text = "상징 추가하기".localized()
        }
    }
}

extension MakeCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addedImage.image = image
            //detectLabels(image: image, txtField: textField)
        }
        dismiss(animated: true, completion: nil)
    }
}
