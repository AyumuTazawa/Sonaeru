//
//  AddPrepareViewController.swift
//  Sonaeru
//
//  Created by 田澤歩 on 2020/10/09.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

class AddPrepareViewController: UIViewController {

    @IBOutlet weak var addDayUITextField: UITextField!
    @IBOutlet weak var addMemoUITextView: UITextView!
    @IBOutlet weak var prepareID: UILabel!
    
    var database: Firestore!
    var selectPrepareData: PrepareData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        //self.prepareID.text = selectPrepareData.prepareId
        self.addMemoUITextView.text = selectPrepareData.topic
    }
    
    @IBAction func tapAddDataButton(_ sender: Any) {
       addMemo().done {
            
        }.catch { err in
            print(err)
            self.displayAlert()
        }
        
    }
    
    func addMemo() -> Promise<Void> {
        return Promise { resolver in
            let addDay = addDayUITextField.text
            let addMemo = addMemoUITextView.text
            let prepareID = selectPrepareData.prepareId
            let addMemoData = ["day": addDay, "memo": addMemo, "prepareID": prepareID]
            Firestore.firestore().collection("task").document().setData(addMemoData) { err in
                if let err = err {
                    print("失敗")
                } else {
                    
                }
            }
        }
    }
    
    func displayAlert() {
        let title = "保存失敗"
        let message = "保存内容を確認してください"
        let okText = "ok"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        present(alert, animated: true, completion: nil)
    }

}
