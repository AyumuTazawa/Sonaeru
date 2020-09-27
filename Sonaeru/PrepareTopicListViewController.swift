//
//  PrepareTopicListViewController.swift
//  Sonaeru
//
//  Created by 田澤歩 on 2020/09/26.
//  Copyright © 2020 net.ayumutazawa. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

class PrepareTopicListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var database: Firestore!
    var postArray: [PrepareData] = []

    @IBOutlet weak var prepareTopicListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        database = Firestore.firestore()
        prepareTopicListTableView.delegate = self
       prepareTopicListTableView.dataSource = self
        prepareTopicListTableView.register(UINib(nibName: "PrepareTopicTableViewCell", bundle: nil),  forCellReuseIdentifier: "prepareTopicCell")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData().done { posts in
            print(posts)
            self.postArray = posts
            self.prepareTopicListTableView.reloadData()
        }.catch { err in
            print(err)
        }
        
    }
    
    func getData() -> Promise<[PrepareData]> {
        return Promise { resolver in
            database.collection("Prepare").getDocuments { (snapshot, err) in
                if let err = err {
                    resolver.reject(err)
                }
                if let snapshot = snapshot {
                    
                    print(snapshot.documents)
                    let posts = snapshot.documents.map {PrepareData(data: $0.data())}
                    resolver.fulfill(posts)
                }
                
            }
        }
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prepareTopicCell", for: indexPath) as! PrepareTopicTableViewCell
        cell.setCell(prepare: postArray[indexPath.row])
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
   

}

/* database.collection("Prepare").getDocuments { (snapshot, err) in
                  if err == nil, let snapshot = snapshot {
                      self.postArray = []
                      print(snapshot.documents)
                      for document in snapshot.documents {
                          print("成功しました")
                          print(document.data())
                          
                          let data = document.data()
                          let post = PrepareData(data: data)
                          self.postArray.append(post)
                          
                          self.prepareTopicListTableView.reloadData()
                          
                      }
                  }
              }*/
