//
//  ResetPWViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 22/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPWViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmButton: UIButton! {
        didSet {
            emailConfirmButton.layer.cornerRadius = 5
        }
    }
    @IBAction func emailConfirmButtonClicked(_ sender: UIButton) {
        if emailTextField.text?.count ?? 0 == 0 {
            endLabel.text = "이메일을 입력하세요!"
        } else {
            Auth.auth().useAppLanguage()
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
                if error == nil {
                    self.endLabel.text = "\(self.emailTextField.text!)로 비밀번호 재설정 이메일을 보냈습니다!"
                } else {
                    self.endLabel.text = "이메일을 확인하세요!"
                }
            }
        }
    }
    @IBOutlet weak var endLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
