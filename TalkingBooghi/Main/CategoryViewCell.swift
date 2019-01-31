//
//  CategoryViewCell.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 19..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate: class {
    func delete(cell: CategoryViewCell)
    func edit(cell: CategoryViewCell)
}

class CategoryViewCell: UICollectionViewCell {
    
    var delegate: CategoryCellDelegate?
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var secondCategoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var howManyLabel: UILabel!
    @IBOutlet weak var shadowView: UIVisualEffectView! {
        didSet {
            shadowView.clipsToBounds = true
            shadowView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonClicked(_ sender: UIButton) {
        delegate?.edit(cell: self)
    }
}
