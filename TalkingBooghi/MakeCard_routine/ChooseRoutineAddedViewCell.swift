//
//  ChooseRoutineAddedViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 03/10/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Localize_Swift

protocol AddedCellDelegate: class {
    func delete(cell: ChooseRoutineAddedViewCell)
    func renew(cell: ChooseRoutineAddedViewCell)
}

class ChooseRoutineAddedViewCell: UICollectionViewCell, UITextFieldDelegate {
    var delegate: AddedCellDelegate?
    @IBOutlet weak var addedImage: UIImageView! {
        didSet {
            addedImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var addedTextField: UITextField! {
        didSet {
            addedTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            addedTextField.delegate = self
            addedTextField.attributedPlaceholder = NSAttributedString(string: "이름".localized(),
                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        }
    }
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        delegate?.delete(cell: self)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.renew(cell: self)
    }
}
