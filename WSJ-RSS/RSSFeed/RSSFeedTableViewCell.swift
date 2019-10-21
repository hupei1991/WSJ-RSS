//
//  RSSFeedTableViewCell.swift
//  WSJ-RSS
//
//  Created by Practice on 10/20/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import UIKit

class RSSFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var pubDate: UILabel!
    @IBOutlet weak var feedDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
