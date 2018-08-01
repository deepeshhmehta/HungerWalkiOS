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
    static let domain = "http://192.168.0.26:5050/hunger-walk/"
    
    static let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    static let context = DataFunctionStore.appDelegate.persistentContainer.viewContext
    
    static var BasicData: BasicData?
    
    static var restaurentTableData: [Restaurent]?
    
    static var favouriteTableData: [Restaurent]?
    
    static func goToLogin(currentViewController : UIViewController){
        DataFunctionStore.BasicData?.tutorialComplete = true
        DataFunctionStore.appDelegate.saveContext()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        currentViewController.present(nextViewController, animated:true, completion:{
            currentViewController.removeFromParentViewController()
        })
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
    
    static public func showToast(message : String, controller: UIViewController) {
        
        let toastLabel = UILabel(frame: CGRect(x: controller.view.frame.size.width/2 - 75, y: controller.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        controller.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
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
                
                let result = response.result.value as? NSDictionary
                
                
                if((result?.value(forKey: "SUCCESS")) as! Bool){
                    print("bool true")
                    DataFunctionStore.BasicData?.username =  result?.value(forKey: "NAME") as! String
                    DataFunctionStore.BasicData?.userID = Int(result?.value(forKey: "ID") as! String)!
                    DataFunctionStore.appDelegate.saveContext()
                    
                    
                }else{
                    print("bool false")
                    
                }
                DataFunctionStore.BasicData?.logInSuccess = result?.value(forKey: "SUCCESS") as! Bool
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
    
    static func getRestaurantAPI(controller: UIViewController){
        let url = DataFunctionStore.domain + "getRestaurantAPI.php"
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: [:])
            .responseJSON{response in
                let result = response.result.value as? NSDictionary
                var restaurentTableData : [Restaurent] = []
                
                for rest in result?.value(forKey: "RestaurantList") as! [NSDictionary]{
                    let restaurent = Restaurent()
                    restaurent.ID = Int(rest.value(forKey: "ID") as! String)!
                    restaurent.R_ADDESS = rest.value(forKey: "R_ADDESS") as! String
                    restaurent.R_NAME = rest.value(forKey: "R_NAME") as! String
                    restaurentTableData.append(restaurent)
                }
                
                DataFunctionStore.restaurentTableData = restaurentTableData
                (controller as! RestaurentsViewController).restaurentListTable.reloadData()
        }
        
    }
    
    static func getFavouriteRestaurantAPI(controller: UIViewController){
        let url = DataFunctionStore.domain + "getFavouriteAPI.php"
        Alamofire.request(url, method: .post, parameters: ["ID" : DataFunctionStore.BasicData?.userID ?? 0], encoding: URLEncoding.default, headers: [:])
            .responseJSON{response in
                let result = response.result.value as? NSDictionary
                var favouriteTableData : [Restaurent] = []
                
                for rest in result?.value(forKey: "RestaurantList") as! [NSDictionary]{
                    let restaurent = Restaurent()
                    restaurent.ID = Int(rest.value(forKey: "ID") as! String)!
                    restaurent.R_ADDESS = rest.value(forKey: "R_ADDESS") as! String
                    restaurent.R_NAME = rest.value(forKey: "R_NAME") as! String
                    favouriteTableData.append(restaurent)
                }
                
                DataFunctionStore.favouriteTableData = favouriteTableData
                
                (controller as! FavouritesViewController).favouriteListTable.reloadData()
        }
        
    }
}
