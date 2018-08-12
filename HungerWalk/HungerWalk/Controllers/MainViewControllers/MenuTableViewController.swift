//
//  MenuTableViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-09.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var current: Restaurent?
    var tableData: [Item]?
    @IBOutlet var menuTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataFunctionStore.getMenuItems(current: current!, completion: { result in
            switch result{
            case .success(let data):
                self.tableData = data["tableData"] as? [Item]
                self.menuTable.reloadData()
            case .failure(let data):
                DataFunctionStore.showToast(message: data["message"] as! String, controller: self)
                dump(data)
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133.0
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
        return tableData?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
        let currentItem = tableData![indexPath.row]
        cell.indexPath = indexPath
        cell.itemTitle.text = currentItem.I_NAME
        cell.itemDesc.text = currentItem.DESCRIPTION
        cell.itemCount.text = String(DataFunctionStore.cart[currentItem] ?? 0)
        cell.delegate = self
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}

extension MenuTableViewController: MenuItemTableViewCellDelegate{
    func changeCount(cell: MenuItemTableViewCell, addTrueReduceFalse: Bool) {
        let currentItem = tableData![(cell.indexPath!.row)]
        let increment: Int = addTrueReduceFalse ? 1 : -1
        DataFunctionStore.cart[currentItem] = (DataFunctionStore.cart[currentItem] ?? 0) + increment
        
        if(DataFunctionStore.cart[currentItem]! < 0){
            DataFunctionStore.cart[currentItem] =  0
        }
        cell.itemCount.text = String(DataFunctionStore.cart[currentItem] ?? 0)
        dump(DataFunctionStore.cart[currentItem])
    }
    
    
}
