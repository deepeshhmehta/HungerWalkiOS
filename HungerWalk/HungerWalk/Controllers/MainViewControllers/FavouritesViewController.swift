//
//  FavouritesViewController.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-01.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    @IBOutlet var favouriteListTable: UITableView!
    var current: Restaurent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favourites"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DataFunctionStore.getFavouriteRestaurantAPI(controller: self)
        favouriteListTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavouritesToMenuSegue" {
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

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (DataFunctionStore.favouriteTableData?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteListTable.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell", for: indexPath) as! FavouritesTableViewCell
        current = DataFunctionStore.favouriteTableData![indexPath.row]
        cell.restaurentName?.text = current?.R_NAME
        cell.restaurentAddress?.text = current?.R_ADDESS
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        current = DataFunctionStore.favouriteTableData![indexPath.row]
        self.performSegue(withIdentifier: "FavouritesToMenuSegue", sender: nil)
        
    }
    
}

