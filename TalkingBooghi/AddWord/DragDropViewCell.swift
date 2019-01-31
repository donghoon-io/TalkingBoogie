//
//  DragDropViewCell.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 30..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit

protocol  DragDropCellDelegate: class {
    func delete(cell: DragDropViewCell)
}

class DragDropViewCell: UICollectionViewCell {
    
    var delegate3: DragDropCellDelegate?
    
    @IBOutlet weak var wordImage: UIImageView! {
        didSet {
            wordImage.layer.masksToBounds = true
            wordImage.layer.cornerRadius = 15
            wordImage.layer.borderWidth = 2
            wordImage.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        delegate3?.delete(cell: self)
    }
    
    @IBOutlet weak var wordLabel: UILabel!
}
