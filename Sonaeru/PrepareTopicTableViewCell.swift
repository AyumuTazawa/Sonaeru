//
//  PrepareTopicTableViewCell.swift
//  Sonaeru
//
//  Created by 田澤歩 on 2020/09/26.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import Firebase

class PrepareTopicTableViewCell: UITableViewCell {

    @IBOutlet weak var prepareTopic: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(prepare: PrepareData) {
        self.prepareTopic.text = prepare.topic as String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
