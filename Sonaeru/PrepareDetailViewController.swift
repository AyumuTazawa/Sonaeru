//
//  PrepareDetailViewController.swift
//  Sonaeru
//
//  Created by 田澤歩 on 2020/09/30.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import Firebase

class PrepareDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var database: Firestore!
    var selectTopic: PrepareData!
    var prepareDetailArry: [PrepareDetailData] = []
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var prepareDetailList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectTopic)
        //self.TitleLabel.text = selectTopic.topic
        database = Firestore.firestore()
        prepareDetailList.delegate = self
        prepareDetailList.dataSource = self
        prepareDetailList.register(UINib(nibName: "PrepareDetailListTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let prepareId = selectTopic.prepareId
        database.collection("Prepare").document(prepareId).collection("Details").addSnapshotListener { (snapshots, err) in
            if err == nil, let snapshots = snapshots {
                self.prepareDetailArry = []
                print(snapshots.documents)
                for document in snapshots.documents {
                    print("成功しました")
                    print(document.data())
                    
                    let data = document.data()
                    let post = PrepareDetailData(data: data)
                    self.prepareDetailArry.append(post)
                    
                    self.prepareDetailList.reloadData()
                    
                }
            }
            
        }
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prepareDetailArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PrepareDetailListTableViewCell
         cell.setCell(prepare: prepareDetailArry[indexPath.row])
                return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    
    
    
    //画面遷移＆値受け渡し
    @IBAction func toAddPrepareViewContoroller(_ sender: Any) {
        performSegue(withIdentifier: "toAdd", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd" {
            let addReviewContorollre = segue.destination as? AddPrepareViewController
            addReviewContorollre?.selectPrepareData = self.selectTopic
            
                   
               }
    }
    

}
