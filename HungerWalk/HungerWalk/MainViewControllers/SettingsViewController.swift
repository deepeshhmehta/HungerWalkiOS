//
//  SettingsViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-06.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        DataFunctionStore.BasicData?.userID = 0
        DataFunctionStore.BasicData?.username = ""
        DataFunctionStore.BasicData?.logInSuccess = false
        DataFunctionStore.appDelegate.saveContext()
        
        DataFunctionStore.goToLogin(currentViewController: self)
        DataFunctionStore.showToast(message: "Logout Successful", controller: self)
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
