//
//  TableViewCell.swift
//  SQLiteExample
//
//  Created by Apple Guru on 7/1/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtRank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
