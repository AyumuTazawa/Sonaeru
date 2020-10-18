//
//  PrepareDetailData.swift
//  Sonaeru
//
//  Created by 田澤歩 on 2020/10/11.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import Firebase

class PrepareDetailData {
    
    let day: String
    let memo: String
   // let prepareMemo: String
    //let selectDay: String
    
    init(data: [String: Any]) {
        day = data["day"] as! String
        memo = data["memo"] as! String
        //prepareMemo = data["repareMemo"] as! String
        //selectDay = data["selectDay"] as! String
    }
}
