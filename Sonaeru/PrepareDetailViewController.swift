//
//  PrepareDetailViewController.swift
//  Sonaeru
//
//  Created by 田澤歩 on 2020/09/30.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

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
        
        self.fostDetailData()
       
    }
    
    func fostDetailData() {
        fechDetailData().done { detailposts in
            self.prepareDetailArry = detailposts
        }.catch { err in
            print(err)
        }.finally {
            self.prepareDetailList.reloadData()
        }
        
    }
    
    func fechDetailData() -> Promise<[PrepareDetailData]> {
        return Promise { resolver in
            let prepareId = selectTopic.prepareId
            Firestore.firestore().collection(prepareId).getDocuments { (snapshot, err) in
                if let err = err {
                    resolver.reject(err)
                }
                if let snapshot = snapshot {
                    let detailposts = snapshot.documents.map {PrepareDetailData(data: $0.data())}
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
