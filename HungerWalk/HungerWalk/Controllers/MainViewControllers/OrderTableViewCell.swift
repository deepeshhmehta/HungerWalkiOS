//
//  OrderTableViewCell.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-13.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
