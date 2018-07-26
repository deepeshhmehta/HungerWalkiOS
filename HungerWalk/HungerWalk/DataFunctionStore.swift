//
//  DataFunctionStore.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-25.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class DataFunctionStore: NSObject {
    static let domain = "http://10.51.213.216:5050/hunger-walk/"
    
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
    
    static func goToMainScreen(currentViewController : UIViewController){
        DataFunctionStore.BasicData?.tutorialComplete = true
        DataFunctionStore.appDelegate.saveContext()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LandingScreen") as! UITabBarController
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
    
    //Alamofire
    static func networkTest(){
        Alamofire.request(DataFunctionStore.domain + "getRestaurantAPI.php").responseJSON{ response in
//            dump(response.result.value)
        }
        
    }
    
    static func checkLogin(data: [String: String]){
        //check login true or false with alamofire
        
        let url = DataFunctionStore.domain + "LoginAPI.php"
        
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default, headers: [:])
            .responseJSON{response in
                
                let result = response.result.value as! NSDictionary
                
                
                if((result.value(forKey: "SUCCESS")) as! Bool){
                    print("bool true")
                    DataFunctionStore.BasicData?.username =  result.value(forKey: "NAME") as! String
                    DataFunctionStore.BasicData?.userID = Int(result.value(forKey: "ID") as! String)!
                    DataFunctionStore.appDelegate.saveContext()
                    
                    
                }else{
                    
                    
                }
                DataFunctionStore.BasicData?.logInSuccess = result.value(forKey: "SUCCESS") as! Bool
                DataFunctionStore.appDelegate.saveContext()
        }
        
    }
    
    static func addUser(data: [String : String], controller: UIViewController){
        let url = DataFunctionStore.domain + "Signup.php"
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default, headers: [:])
            .responseData{ response in
                print(response)
        }
        
        DataFunctionStore.goToLogin(currentViewController: controller)
    }
}
