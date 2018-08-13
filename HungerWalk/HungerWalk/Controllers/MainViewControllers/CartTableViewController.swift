//
//  CartTableViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-12.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class CartTableViewController: UITableViewController {
    var itemKey:[Item]?
    override func viewDidLoad() {
        super.viewDidLoad()
        itemKey = Array(DataFunctionStore.cart.keys)
        self.title = "Cart"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CartTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataFunctionStore.cart.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell

        let current = itemKey![indexPath.row]
        
        cell.restName.text = current.Restaurent?.R_NAME
        cell.itemName.text = current.I_NAME
        cell.itemCount.text = String(DataFunctionStore.cart[current]!)
        cell.delegate = self
        cell.indexPath = indexPath

        return cell
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to Order this?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in

            var restWiseData = [Int: [[Item: Int]]]()
            for (item,count) in DataFunctionStore.cart{
                restWiseData[item.Restaurent!.ID] = restWiseData[item.Restaurent!.ID] ?? [[Item: Int]]()
                restWiseData[item.Restaurent!.ID]?.append([item: count])
            }
            
            let data = [
                "user_id" : DataFunctionStore.BasicData?.userID ?? 0,
                "rest_wise_items" : restWiseData
            ] as [String : Any]
            DataFunctionStore.addOrder(data: data, completion:{ result in
                
                switch(result){
                    case .success(let success):
                        dump(success)
                        DataFunctionStore.cart = [:]
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        dump(error["FAILURE"])
                }
                
            })
//            self.deleteRecord()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {alert in
            print("Cancel Tapped")
        })
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true)
    }
    
}

extension CartTableViewController: CartTableViewCellDelegate{
    func changeCount(cell: CartTableViewCell, addTrueReduceFalse: Bool) {
        let currentItem = itemKey![(cell.indexPath!.row)]
        let increment: Int = addTrueReduceFalse ? 1 : -1
        DataFunctionStore.cart[currentItem] = (DataFunctionStore.cart[currentItem] ?? 0) + increment
        
        if(DataFunctionStore.cart[currentItem]! < 1){
            DataFunctionStore.cart[currentItem] =  nil
        }
        cell.itemCount.text = String(DataFunctionStore.cart[currentItem] ?? 0)
    }
    
    func manuallyChangeCount(cell: CartTableViewCell) {
        let currentItem = itemKey![(cell.indexPath!.row)]
        
        DataFunctionStore.cart[currentItem] = Int(cell.itemCount.text!)!
        if(DataFunctionStore.cart[currentItem]! < 1){
            DataFunctionStore.cart[currentItem] =  nil
        }
        
        cell.itemCount.text = String(DataFunctionStore.cart[currentItem] ?? 0)
    }
    
    
}
