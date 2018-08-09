//
//  RestaurentTableViewCell.swift
//  HungerWalk
//
//  Created by Deepesh Mehta on 2018-08-02.
//  Copyright © 2018 DGames. All rights reserved.
//

import UIKit

protocol RestaurentTableViewCellDelegate: class {
    func likeButtonClicked(indexPathRow: Int)
}

class RestaurentTableViewCell: UITableViewCell {
    @IBOutlet var retaurentName: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var restaurentAddress: UILabel!
    var indexPathRow: Int?
    weak var delegate: RestaurentTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func likeTouched(_ sender: Any) {
        delegate?.likeButtonClicked(indexPathRow: indexPathRow!)
    }
}

