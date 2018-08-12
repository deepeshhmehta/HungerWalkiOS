//
//  MenuItemTableViewCell.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-12.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit
protocol MenuItemTableViewCellDelegate {
    func changeCount(cell: MenuItemTableViewCell, addTrueReduceFalse: Bool) -> Void
}

class MenuItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    var indexPath : IndexPath?
    
    var delegate: MenuItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addCountPressed(_ sender: Any) {
        delegate?.changeCount(cell: self, addTrueReduceFalse: true)
    }
    
    @IBAction func reduceCountPressed(_ sender: Any) {
        delegate?.changeCount(cell: self, addTrueReduceFalse: false)
    }
    
    

}
