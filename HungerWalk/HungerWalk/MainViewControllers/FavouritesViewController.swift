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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataFunctionStore.getFavouriteRestaurantAPI(controller: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = UITableViewCell()
        cell.textLabel?.text = DataFunctionStore.favouriteTableData![indexPath.row].R_NAME
        
        return cell
    }
    
    
}

