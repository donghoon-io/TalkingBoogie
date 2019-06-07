//
//  SearchViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 17/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SendImageProtocol {
    func sendImage(image: UIImage)
}

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var imageDelegate: SendImageProtocol!
    
    var keywordText = String()
    
    var imageArray = Array(repeating: UIImage(), count: 10)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchViewCell
        searchKeyword(keyword: keywordText, index: indexPath.item) { (image) in
            cell.imageView.image = image
            self.imageArray[indexPath.item] = image
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageDelegate.sendImage(image: imageArray[indexPath.item])
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var navBar: UINavigationBar! {
        didSet {
            navBar.setBackgroundImage(UIImage(), for:.default)
            navBar.shadowImage = UIImage()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundImage = UIImage()
        }
    }
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keywordText = searchBar.text!
        searchBar.resignFirstResponder()
        self.searchCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        let layout = self.searchCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        let itemWidth: CGFloat = (self.searchCollectionView.frame.size.width - 50)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
}

func searchKeyword(keyword: String, index: Int, completion: @escaping (UIImage) -> Void) {
    let escapedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    let strUrl = "https://dapi.kakao.com/v2/search/image?query=\(escapedString)"
    Alamofire.request(strUrl, method: .get, encoding: JSONEncoding.prettyPrinted, headers: ["Authorization": "KakaoAK 0ba4a06a202e64d20eeb4f03f7120994"]).responseJSON { (response) in
        if response.result.isSuccess {
            let searchResult: JSON = JSON(response.result.value!)
            let imageResult = searchResult["documents"][index]["image_url"].string ?? ""
            let encodedResult = imageResult.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            Alamofire.request(encodedResult).responseData(completionHandler: { (response) in
                if response.result.isSuccess {
                    let image = UIImage(data: response.result.value!)
                    completion(image ?? UIImage())
                } else {
                    print("Image Load Failed! \(response.result.error ?? "error" as! Error)")
                    completion(UIImage())
                }
            })
        } else {
            print("Kakao Search Failed! \(response.result.error ?? "error" as! Error)")
        }
    }
}


func searchKeywordStringVersion(keyword: String, index: Int, completion: @escaping (String) -> Void) {
    let escapedString = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    let strUrl = "https://dapi.kakao.com/v2/search/image?query=\(escapedString)"
    Alamofire.request(strUrl, method: .get, encoding: JSONEncoding.prettyPrinted, headers: ["Authorization": "KakaoAK 0ba4a06a202e64d20eeb4f03f7120994"]).responseJSON { (response) in
        if response.result.isSuccess {
            let searchResult: JSON = JSON(response.result.value!)
            let imageResult = searchResult["documents"][index]["image_url"].string!
            let encodedResult = imageResult.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            completion(encodedResult)
        } else {
            print("Kakao Search Failed! \(response.result.error ?? "error" as! Error)")
        }
    }
}
