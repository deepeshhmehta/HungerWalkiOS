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
    
    func commentButtonClicked(indexPathRow: Int) -> Void {
        let current = DataFunctionStore.restaurentTableData![indexPathRow]
        let dialogMessage = UIAlertController(title: "Comment on " + current.R_NAME, message: "Write a comment to be sent to the rest", preferredStyle: .alert)
        
        dialogMessage.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Comment"
        })
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            let data = ["user_id": DataFunctionStore.BasicData?.userID ?? 0,
                        "rest_id": current.ID ,
                        "comment": dialogMessage.textFields![0].text ?? "error in reading"] as [String : Any]
            DataFunctionStore.addComment(params: data, completion:{ result in
                switch(result){
                    
                case .success(_):
                    DataFunctionStore.showToast(message: "Comment Submitted Successfully", controller: self)
                case .failure(let error):
                    dump(error)
                    DataFunctionStore.showToast(message: "There was an error", controller: self)
                }
            })
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {alert in
            
        })
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true)
    }
    
    
}
