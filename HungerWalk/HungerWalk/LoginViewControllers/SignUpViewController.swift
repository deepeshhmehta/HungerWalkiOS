//
//  SignUpViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-26.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirm_password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpTOuched(_ sender: Any) {
        
        var pass = true
        if name.text == "" {
            print("Name cannot be blank")
            pass = false
        }
        if email.text == ""{
            print("Email cannot be blank")
            pass = false
        }
        if phone.text == ""{
            print("Phone cannot be blank")
            pass = false
        }
        if password.text == "" {
            print("Password cannot be blank")
            pass = false
        }
        if password.text != confirm_password.text{
            print("passwords do not match")
            pass = false
        }
        if(pass){
            DataFunctionStore.addUser(data: [
                                            "NAME": name.text!,
                                            "EMAIL": email.text!,
                                            "PHONE": phone.text!,
                                            "PASSWORD": password.text!], controller: self)
            
        }
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
