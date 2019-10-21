//
//  RSSChannelTableViewCell.swift
//  WSJ-RSS
//
//  Created by Practice on 10/19/19.
//  Copyright © 2019 PH Assignment. All rights reserved.
//

import UIKit

class RSSChannelTableViewCell: UITableViewCell {
    @IBOutlet weak var channelLogo: UIImageView!
    @IBOutlet weak var channelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initChannelLogo()
    }
    
    private func initChannelLogo() {
        let config = UIImage.SymbolConfiguration(pointSize: 19.0, weight: .regular)
        self.channelLogo.preferredSymbolConfiguration = config
        self.channelLogo.tintColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
