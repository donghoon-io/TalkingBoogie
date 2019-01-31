//
//  EditViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 2018. 8. 6..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit

extension EditViewController: EditViewCellDelegate {
    func delete(cell: EditViewCell) {
        if let indexPath = self.editCollectionView?.indexPath(for: cell) {
            let tempCurrentItem = currentItem
            let b = (currentItem?.tagName.filter({
                $0 != tempCurrentItem?.tagName[indexPath.item]
            }))!
            currentItem?.tagName = b
            let c = (currentItem?.tagPath.filter({
                $0 != tempCurrentItem?.tagPath[indexPath.item]
            }))!
            currentItem?.tagPath = c
            if let index = imageSets.firstIndex(where: {
                $0.imagePath == currentItem?.imagePath
            }) {
                imageSets[index] = currentItem!
            }
            self.editCollectionView.deleteItems(at: [indexPath])
        }
    }
}

class EditViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var editCollectionView: UICollectionView!
    
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItem!.tagName.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < currentItem!.tagName.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editCell1", for: indexPath) as! EditViewCell
            
            cell.tagImage.image = loadImage(named: currentItem!.tagPath[indexPath.item])
            cell.tagLabel.text = currentItem!.tagName[indexPath.item]
            
            cell.delegate = self
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "editCell2", for: indexPath)
            return cell
        }
    }
    
    var titleString = String()
    
    var currentItem: ImageSet?
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.image = loadImage(named: (currentItem?.imagePath)!)
        }
    }
    
    @IBOutlet weak var titleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = titleString
        
        editCollectionView.delegate = self
        editCollectionView.dataSource = self
        
        
        print(titleString)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
