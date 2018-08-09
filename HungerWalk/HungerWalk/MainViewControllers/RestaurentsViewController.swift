//
//  RestaurentsViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-07-26.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class RestaurentsViewController: UIViewController {
    @IBOutlet var restaurentListTable: UITableView!
    var current: Restaurent?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Restaurents"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataFunctionStore.getRestaurantAPI(controller: self)
        self.restaurentListTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurentToMenuSegue" {
            guard let vc = segue.destination as? MenuTableViewController else{
                return
            }
            vc.current = current
            vc.title = current?.R_NAME
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

extension RestaurentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (DataFunctionStore.restaurentTableData?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restaurentListTable.dequeueReusableCell(withIdentifier: "RestaurentTableViewCell", for: indexPath) as! RestaurentTableViewCell
        current = DataFunctionStore.restaurentTableData![indexPath.row]
        cell.retaurentName?.text = current?.R_NAME
        cell.restaurentAddress?.text = current?.R_ADDESS
        cell.delegate = self
        cell.indexPathRow = indexPath.row
        let image = UIImage(named: (current?.IS_FAV)! ? "fav" : "notFav")
        cell.likeButton.setImage(image, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        current = DataFunctionStore.restaurentTableData![indexPath.row]
        self.performSegue(withIdentifier: "RestaurentToMenuSegue", sender: nil)
        
    }
    
}

extension RestaurentsViewController: RestaurentTableViewCellDelegate{
    func likeButtonClicked(indexPathRow: Int) {
        let current = DataFunctionStore.restaurentTableData![indexPathRow]
        let data = ["USER_ID": (DataFunctionStore.BasicData?.userID)!,
                    "RESTAURANT_ID": current.ID,
                    "ADD_REMOVE": current.IS_FAV ? "REMOVE" : "ADD"] as [String : Any]
        
        DataFunctionStore.toggleLike(data: data, completion: {
            DataFunctionStore.getRestaurantAPI(controller: self)
            self.restaurentListTable.reloadData()
        })
        
    }
    
    
}
