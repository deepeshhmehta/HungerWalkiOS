//
//  EditProfileViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-09.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    var currentTextBox: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.title = "Edit Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let data = ["user_id": DataFunctionStore.BasicData?.userID] as! [String: Int]
        DataFunctionStore.getUserData(data: data, completion:{ result in
            switch(result){
            case .success(let data):
                self.name.text = data["name"] as? String
                self.phone.text = data["phone"] as? String
                self.email.text = data["email"] as? String
                self.password.text = data["password"] as? String
            case .failure(let error):
                DataFunctionStore.showToast(message: error["Error"] as! String, controller: self)
                
            }
        })
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo{
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if((currentTextBox?.frame.minY)! > keyboardSize.height){
                    saveButtonBottomConstraint.constant -= -(keyboardSize.height - (currentTextBox?.frame.minY)!)
                }
            }
            let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        saveButtonBottomConstraint.constant = -20
        let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editStartedTextField(_ sender: UITextField) {
        currentTextBox = sender
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        let data = [
            "name" : name.text!,
            "phone" : phone.text!,
            "email" : email.text!,
            "password": password.text!,
            "user_id": (DataFunctionStore.BasicData?.userID)!
            ] as [String : Any]
        
        DataFunctionStore.updateUserData(data: data, completion: { result in
            switch result{
            case .success(let success):
                DataFunctionStore.showToast(message: success["SUCCESS"] as! String, controller: self)
            case .failure(let failure):
                DataFunctionStore.showToast(message: failure["FAILURE"] as! String, controller: self)
            }
        })
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
