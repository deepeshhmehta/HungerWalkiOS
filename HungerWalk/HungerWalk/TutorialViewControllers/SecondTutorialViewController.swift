//
//  SecondViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-10.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class SecondTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func nextButtonClicked(_ sender: Any) {
        tabBarController?.selectedIndex += 1
    }
    @IBAction func skipTouched(_ sender: Any) {
        DataFunctionStore.goToLogin(currentViewController: self)
    }
}

