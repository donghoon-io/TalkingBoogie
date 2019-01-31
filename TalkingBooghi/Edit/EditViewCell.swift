//
//  EditViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 2018. 8. 6..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit

protocol EditViewCellDelegate: class {
    func delete(cell: EditViewCell)
}

class EditViewCell: UICollectionViewCell {
    
    var delegate: EditViewCellDelegate?
    
    @IBOutlet weak var tagImage: UIImageView!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        delegate?.delete(cell: self)
    }
}
