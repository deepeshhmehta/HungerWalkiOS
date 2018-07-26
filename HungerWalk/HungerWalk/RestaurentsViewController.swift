//
//  RestaurentsViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-26.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class RestaurentsViewController: UIViewController {
    @IBOutlet var test: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        test.text = "Hello " + (DataFunctionStore.BasicData!.username) + " yo!"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
