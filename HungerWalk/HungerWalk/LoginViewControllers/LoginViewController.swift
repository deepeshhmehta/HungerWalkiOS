//
//  LoginViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-19.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var keyboardShown: Bool = false
    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var logo: UIImageView!
    
    @IBOutlet var LoginBottomConstraint: NSLayoutConstraint!
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        self.title = "Login"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        animateLogo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo{
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.LoginBottomConstraint.constant = -keyboardSize.height - 20
            }
            let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
       
        self.LoginBottomConstraint.constant = -20
        let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })

    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func LoginTouched(_ sender: Any) {
        if email.text == "" {
            print("email cannot be blank")
            return
        }
        if password.text == ""{
            print("password cannot be blank")
            return
        }
        
        DataFunctionStore.checkLoginCompletion(data: ["EMAIL": email.text!, "PASSWORD": password.text!], completion: {result in
            
            DataFunctionStore.BasicData?.logInSuccess = result["SUCCESS"] as! Bool
            if (result["SUCCESS"] as? Bool) ?? false {
                DataFunctionStore.BasicData?.userID = result["ID"] as! Int
                DataFunctionStore.BasicData?.username = result["NAME"] as! String
                DataFunctionStore.appDelegate.saveContext()
                DataFunctionStore.showToast(message: "Login Success", controller: self)
                DataFunctionStore.goToMainScreen(currentViewController: self)
            }else{
                 DataFunctionStore.showToast(message: "Login Failed", controller: self)
            }
            
            
        })
    }
    
    
    
    func animateLogo(){
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.logo.transform = CGAffineTransform.identity.scaledBy(x: 2.5, y: 2.5)
            
        }, completion: { result in
            self.logo.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        })
    }
}
















