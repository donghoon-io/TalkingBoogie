//
//  SignUpViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 23/08/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            signupButton.layer.cornerRadius = signupButton.bounds.height/2
            signupButton.backgroundColor = UIColor.lightGray
            signupButton.isEnabled = false
        }
    }
    
    var isChecked = false
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var radioButton: UIButton!
    
    @IBAction func radioButtonClicked(_ sender: UIButton) {
        if !isChecked {
            radioButton.setImage(UIImage(named: "isChecked"), for: .normal)
            signupButton.backgroundColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
            signupButton.isEnabled = true
            isChecked = true
        } else {
            radioButton.setImage(UIImage(named: "notChecked"), for: .normal)
            signupButton.backgroundColor = UIColor.lightGray
            signupButton.isEnabled = false
            isChecked = false
        }
    }
    
    
    @IBAction func signupClicked(_ sender: UIButton) {
        if emailAddress.text?.count ?? 0 == 0 {
            statusLabel.text = "이메일을 입력해주세요!"
        } else if !isValidEmail(testStr: emailAddress.text!){
            statusLabel.text = "이메일이 올바른 형식이 아닙니다!"
        } else if password.text?.count ?? 0 == 0 {
            statusLabel.text = "비밀번호를 입력해주세요!"
        } else if passwordConfirm.text?.count ?? 0 == 0 {
            statusLabel.text = "비밀번호 확인을 입력해주세요!"
        } else if password.text != passwordConfirm.text {
            statusLabel.text = "비밀번호가 일치하지 않습니다!"
        } else {
            statusLabel.text = ""
            Auth.auth().createUser(withEmail: self.emailAddress.text!, password: self.password.text!) { (user, error) in
                if error == nil {
                    self.statusLabel.text = "가입 완료!"
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.statusLabel.text = "가입 실패! " + error!.localizedDescription
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        emailAddress.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
}
