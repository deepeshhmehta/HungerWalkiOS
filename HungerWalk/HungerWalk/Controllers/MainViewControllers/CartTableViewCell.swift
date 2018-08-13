//
//  CartTableViewCell.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-12.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

protocol CartTableViewCellDelegate {
    func changeCount(cell: CartTableViewCell, addTrueReduceFalse: Bool) -> Void
    func manuallyChangeCount(cell: CartTableViewCell) -> Void
}

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemCount: UITextField!
    
    var delegate: CartTableViewCellDelegate?
    var indexPath: IndexPath?
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func plusClicked(_ sender: Any) {
        delegate?.changeCount(cell: self, addTrueReduceFalse: true)
    }
    @IBAction func minusClicked(_ sender: Any) {
        delegate?.changeCount(cell: self, addTrueReduceFalse: false)
    }
   
    
    @IBAction func manuallyEnteredQuantity(_ sender: UITextField) {
        delegate?.manuallyChangeCount(cell: self)
    }
    
    
}
