//
//  LoginViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-19.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
    
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
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
        
        DataFunctionStore.checkLogin(data: ["EMAIL": email.text!, "PASSWORD": password.text!])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if(DataFunctionStore.BasicData?.logInSuccess)!{
                DataFunctionStore.showToast(message: "Login Success", controller: self)
                DataFunctionStore.goToMainScreen(currentViewController: self)
            }else{
                DataFunctionStore.showToast(message: "Login Failed", controller: self)
            }
        }
       
        
    }
    
    @IBAction func signUpTouched(_ sender: Any) {
       let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpViewController, animated: true)
    }
}
















