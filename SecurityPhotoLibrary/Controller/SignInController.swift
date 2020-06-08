//
//  SignInController.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 15/04/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit

class SignInController: UIViewController {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var userTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *){
            overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoImageView.rotate(degrees: CGFloat(Constant.degree))

        userTextField.addBottomBorder()
        userTextField.tintColor = .blue
        userTextField.setIcon(UIImage(systemName: "envelope") ?? UIImage())
        
        passwordTextField.addBottomBorder()
        passwordTextField.tintColor = .blue
        passwordTextField.setIcon(UIImage(systemName: "lock") ?? UIImage())
    }
    
    @IBAction private func isAccountCorrect(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: Constant.lmageViewController) as? ImageLibraryController else {return}
        if self.userTextField.text == Constant.login && self.passwordTextField.text == Constant.password {
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let alert = UIAlertController(title: "Login Fail", message: "Please check you login detail again", preferredStyle: .alert)
            let submitButton = UIAlertAction(title: "OK", style: .default) { (submitButton) in
                print(submitButton)
            }
            
            alert.addAction(submitButton)
            
            self.present(alert, animated: true)
            
        }
    }
    
    @IBAction func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }

    }
    @IBAction func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    
    
}

