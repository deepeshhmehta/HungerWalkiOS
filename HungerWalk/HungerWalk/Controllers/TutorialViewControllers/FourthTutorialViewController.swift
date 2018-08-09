//
//  FourthTutorialViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-19.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class FourthTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        DataFunctionStore.goToLogin(currentViewController: self)
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