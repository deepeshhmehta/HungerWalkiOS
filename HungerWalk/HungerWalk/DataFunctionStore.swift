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

enum ResultCompletion {
    case success([String: Any])
    case failure([String: Any])
}

class DataFunctionStore: NSObject {
    static let domain = "http://192.168.0.25:5050/hunger-walk/API/"
    
    static let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    static let context = DataFunctionStore.appDelegate.persistentContainer.viewContext
    
    static var BasicData: BasicData?
    
    static var restaurentTableData: [Restaurent]?
    
    static var favouriteTableData: [Restaurent]?
    
    static var cart: [Item : Int] = [:]
    
    static func goToLogin(currentViewController : UIViewController){
        DataFunctionStore.BasicData?.tutorialComplete = true
        DataFunctionStore.appDelegate.saveContext()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewNavigationController") as! UINavigationController
        currentViewController.present(nextViewController, animated:true, completion:{
            currentViewController.removeFromParentViewController()
        })
        
    }
    
    
    static func goToMainScreen(currentViewController : UIViewController){
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
        UIView.animate(withDuration: 6.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //Alamofire
    
    static func checkLoginCompletion(data: [String: String], completion: @escaping ([String: Any]) -> Void){
        let url = DataFunctionStore.domain + "LoginAPI.php"
        
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default, headers: [:])
            .responseJSON{response in
                if response.response?.statusCode == 200{
                    let result = response.result.value as! [String : Any]
                        completion(result)
                    
                }else{
                    completion(["SUCCESS": false])
                }
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
        let data = ["USER_ID" : DataFunctionStore.BasicData?.userID ?? 0] as [String: Any]
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default, headers: [:])
            .responseJSON{response in
                let result = response.result.value as? NSDictionary
                var restaurentTableData : [Restaurent] = []
                
                for rest in result?.value(forKey: "RestaurantList") as! [NSDictionary]{
                    let restaurent = Restaurent()
                    restaurent.ID = rest.value(forKey: "ID") as! Int
                    restaurent.R_ADDESS = rest.value(forKey: "R_ADDESS") as! String
                    restaurent.R_NAME = rest.value(forKey: "R_NAME") as! String
                    restaurent.IS_FAV = rest.value(forKey: "IS_FAV") as! Bool
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
    
    static func toggleLike(data: [String: Any], completion: @escaping () -> Void){
        let url = DataFunctionStore.domain + "addRemoveFavourite.php"
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default, headers: [:])
        .response(completionHandler: {result in
            completion()
        })
    }
    
    static func getMenuItems(current: Restaurent, completion: @escaping (ResultCompletion) -> Void){
        let url = DataFunctionStore.domain + "getMenuAPI.php"
        Alamofire.request(url, method: .post, parameters: ["R_ID" : current.ID], encoding: URLEncoding.default, headers: [:])
            .responseJSON{response in
                if (response.response?.statusCode == 200){
                    let result = response.result.value as? [[String: Any]]
                    var menuTableData : [Item] = []
                    
                    for item in result!{
                        let menuItem = Item()
                        menuItem.I_NAME = item["I_NAME"] as! String
                        menuItem.DESCRIPTION = item["DESCRIPTION"] as! String
                        menuItem.STATUS = item["STATUS"] as! String
                        menuItem.ID = item["ID"] as! Int
                        menuItem.PRICE = item["PRICE"] as! Int
                        menuItem.R_ID = item["R_ID"] as! Int
                        menuItem.Restaurent = current
                        
                        menuTableData.append(menuItem)
                    }
                    
                    completion(.success(["tableData": menuTableData]))
                }else{
                    completion(.failure(["message": "Wrong Connection"]))
                }
        }
    }
    
    static func getUserData(data: [String: Int], completion: @escaping (ResultCompletion) -> Void){
        let url = DataFunctionStore.domain + "userDataAPI.php"
        
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default, headers: [:])
            .responseJSON{response in
                if(response.response?.statusCode == 200){
                    let result = response.result.value as! [String : Any]
                        completion(.success(result))
                    
                }else{
                    completion(.failure(["Error" : "Unable to Connect"]))
                }
        }
    }
    
    static func updateUserData(data: [String: Any], completion: @escaping (ResultCompletion) -> Void){
        let url = domain + "updateUserDataAPI.php"
        Alamofire.request(url, method: .post, parameters: data, encoding: URLEncoding.default, headers: [:])
        .response(completionHandler: { responded in
            if(responded.response?.statusCode == 200){
                completion(.success(["SUCCESS": "Data Updated"]))
            }else{
                completion(.failure(["FAILURE": "Connection Error"]))
            }
            
        })
        
    }
    
    static func addOrder(data: [String: Any], completion: @escaping (ResultCompletion) -> Void){

        for (rest_id,items) in data["rest_wise_items"] as! [Int: [[Item: Int]]] {

            var amount = 0
            
            
            for itemBlock in items{
                for (item,count) in itemBlock{
                    amount += item.PRICE
                }
            }
            
            let params = [
                "user_id": data["user_id"] as! Int,
                "rest_id": rest_id,
                "count": items.count,
                "amount": amount
                
            ]
            
            let url = domain + "addOrderMasterAPI.php"
            dump(params)
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: [:])
                    .responseJSON(completionHandler: { response in
                        if(response.response?.statusCode == 200){
                            let order_id =  response.result.value as? Int ?? 0
                            let data = ["order_id": order_id, "items": items] as [String : Any]
                            DataFunctionStore.addOrderDetails(data: data, complete:{result in
                                switch(result){
                                    case .success(let success):
                                        completion(.success(success))
                                    case .failure(_):
                                        completion(.failure(["FAILURE": "Unable to Place order Detail"]))
                                }
                            })
                        }else{
                            completion(.failure(["FAILURE": "Unable to Place order Master"]))
                        }
                    })
        }
        
    }
        
    static func addOrderDetails(data: [String: Any],complete: @escaping (ResultCompletion) -> Void){
        let items = data["items"] as! [[Item: Int]]
        
        for itemBlock in items {
    
            for (item,count) in itemBlock{
                
                let params = [
                    "order_id": data["order_id"],
                    "item_id": item.ID,
                    "qty": count
                ]
                let url = domain + "addOrderDetailsAPI.php"
                Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: [:])
                .responseJSON(completionHandler: {response in
                    if(response.response?.statusCode == 200){
                        complete(.success(["SUCCESS" : 1]))
                    }else{
                        complete(.failure(["FAILURE": 0]))
                    }
                })
            }
            
        }
    }
}
