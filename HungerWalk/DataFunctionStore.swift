//
//  DataFunctionStore.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-25.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit
import CoreData

class DataFunctionStore: NSObject {
    
    static let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    static let context = DataFunctionStore.appDelegate.persistentContainer.viewContext
    
    static var BasicData: BasicData?
    
    static func goToLogin(currentViewController : UIViewController){
        DataFunctionStore.BasicData?.tutorialComplete = true
        DataFunctionStore.appDelegate.saveContext()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        currentViewController.present(nextViewController, animated:true, completion:nil)
        currentViewController.removeFromParentViewController()
    }
    
    static func basicDataExists() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BasicData")
        fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try DataFunctionStore.context.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    
    static func callBasicData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BasicData")
        fetchRequest.includesSubentities = false
        
        do{
            let result = try DataFunctionStore.context.fetch(fetchRequest).first
            DataFunctionStore.BasicData =  result as? BasicData
            
        }catch{
            print("error executing fetch request: \(error)")
        }
    }
}
