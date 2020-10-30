//
//  PrepareDetailListTableViewCell.swift
//  Sonaeru
//
//  Created by 田澤歩 on 2020/09/30.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import Firebase

class PrepareDetailListTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var prepareMemo: UITextView!
    @IBOutlet weak var selectDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(prepare: PrepareDetailData) {
        self.prepareMemo.text = prepare.memo as String
        self.selectDay.text = prepare.day as String
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
