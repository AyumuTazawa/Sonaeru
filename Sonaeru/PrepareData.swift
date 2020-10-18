//
//  PrepareData.swift
//  Sonaeru
//
//  Created by 田澤歩 on 2020/09/26.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import Foundation
import Firebase

class PrepareData {
    
    let topic: String
    let prepareId: String
   // let prepareMemo: String
    //let selectDay: String
    
    init(data: [String: Any]) {
        topic = data["topic"] as! String
        prepareId = data["prepareID"] as! String
        //prepareMemo = data["repareMemo"] as! String
        //selectDay = data["selectDay"] as! String
    }
}
