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
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: ShadowView!
    
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

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
