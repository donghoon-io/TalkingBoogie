//
//  SettingsViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 20/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import fluid_slider
import FirebaseAuth
import MessageUI
import Localize_Swift

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var sendingType = String()
    
    @IBAction func sendFeedback(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
            print("can send mail")
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["ssshyhy@snu.ac.kr"])
        mailComposerVC.setSubject("iOS TalkingBooghi 문의 메일".localized())
        mailComposerVC.setMessageBody("아래에 질문을 남겨주세요 \n ---------------------- \n".localized(), isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func showSendMailErrorAlert() {
        let sendMailAlert = UIAlertController(title: "메일 전송 실패".localized(), message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요".localized(), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인".localized(), style: .cancel, handler: nil)
        sendMailAlert.addAction(confirmAction)
        self.present(sendMailAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        let logoutAlert: UIAlertController = UIAlertController(title: "로그아웃 하시겠습니까?".localized(), message: nil, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "확인".localized(), style: .default) { alert in
            do {
                try Auth.auth().signOut()
            } catch {
            }
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소".localized(), style: .cancel, handler: nil)
        logoutAlert.addAction(okAction)
        logoutAlert.addAction(cancelAction)
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var settingsSlider: Slider! {
        didSet {
            settingsSlider.attributedTextForFraction = { fraction in
                let formatter = NumberFormatter()
                formatter.minimumIntegerDigits = 1
                formatter.maximumFractionDigits = 1
                
                let blackAttributes: [NSAttributedStringKey : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black]
                let string = formatter.string(from: (pow(2.0, 2.0*fraction - 1)) as NSNumber) ?? ""
                return NSAttributedString(string: string, attributes: blackAttributes)
            }
            let labelTextAttributes: [NSAttributedStringKey : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
            settingsSlider.setMinimumLabelAttributedText(NSAttributedString(string: "×0.5", attributes: labelTextAttributes))
            settingsSlider.setMaximumLabelAttributedText(NSAttributedString(string: "×2", attributes: labelTextAttributes))
            settingsSlider.fraction = CGFloat(speechSpeed)
            settingsSlider.shadowOffset = CGSize(width: 0, height: 2)
            settingsSlider.shadowBlur = 3
            settingsSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
            settingsSlider.contentViewColor = UIColor(red: 64/255.0, green: 178/255.0, blue: 237/255.0, alpha: 1)
            settingsSlider.valueViewColor = .white
            settingsSlider.tintColor = .white
            
            settingsSlider.didEndTracking = { [self] _ in
                speechSpeed = Float(self.settingsSlider.fraction)
            }
        }
    }
    
    @IBOutlet weak var feedbackButton: UIButton! {
        didSet {
            feedbackButton.layer.cornerRadius = feedbackButton.bounds.height / 2
        }
    }
    
    @IBOutlet weak var givenID: UITextField! {
        didSet {
            givenID.text = experimentID == "" ? "" : experimentID
        }
    }
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.layer.cornerRadius = confirmButton.bounds.height / 2
        }
    }
    @IBAction func confirmClicked(_ sender: UIButton) {
        experimentID = givenID.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        
    }
}
