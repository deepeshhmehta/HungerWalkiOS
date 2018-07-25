//
//  TutorialViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-19.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class TutorialViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(DataFunctionStore.basicDataExists()){
            DataFunctionStore.callBasicData()
        }else{
            DataFunctionStore.BasicData = BasicData(context: DataFunctionStore.context)
            DataFunctionStore.BasicData?.tutorialComplete = false
            DataFunctionStore.appDelegate.saveContext()
        }
        
        if(DataFunctionStore.BasicData?.tutorialComplete)!{
            DataFunctionStore.goToLogin(currentViewController: self)
        }
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

extension TutorialViewController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
