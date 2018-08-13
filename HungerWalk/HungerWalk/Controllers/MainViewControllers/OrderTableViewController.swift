//
//  OrderTableViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-13.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataFunctionStore.getOrders(completion: { result in
            print("vwa")
            switch(result){
            case.success(_):
                self.tableView.reloadData()
                
            case .failure(let error):
                dump(error)
                DataFunctionStore.showToast(message: error["Failure"] as! String, controller: self)
            }
            
        })
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
        return DataFunctionStore.orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell

        cell.restName.text = DataFunctionStore.orders[indexPath.row].rest_name
        cell.timestamp.text = DataFunctionStore.orders[indexPath.row].date
        cell.amount.text = "$" + String(DataFunctionStore.orders[indexPath.row].amount)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }


}
