//
//  LoginViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 21/08/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import RevealingSplashView
import Localize_Swift

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView! {
        didSet {
            self.statusIndicator.startAnimating()
            statusIndicator.isHidden = true
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = loginButton.bounds.height/2
        }
    }

    @IBAction func loginClicked(_ sender: UIButton) {
        self.statusIndicator.isHidden = false
        self.statusLabel.text = ""
        Auth.auth().signIn(withEmail: idTextField.text!, password: pwTextField.text!) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "startMain", sender: self)
            } else {
                self.statusLabel.text = "로그인에 실패했습니다! 아이디와 비밀번호를 확인해주세요"
                self.statusIndicator.isHidden = true
            }
        }
    }
    
    func setupViews() {
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "logo_launch".localized())!, iconInitialSize: CGSize(width: 240, height: 166), backgroundImage: UIImage(named: "main")!)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.delegate = self
        pwTextField.delegate = self
        
        setupViews()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
