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
    var inputTextField: UITextField?

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
    
    
    @IBAction func addTopic(_ sender: Any) {
        let alertController: UIAlertController = UIAlertController(title: "文言タイトル", message: "メッセージ", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { action -> Void in
        }
        alertController.addAction(cancelAction)
        let addAction: UIAlertAction = UIAlertAction(title: "追加", style: .default) { action -> Void in
            do {
                self.addPrepareTitle()
                self.getData().done { posts in
                    print(posts)
                    self.postArray = posts
                    self.prepareTopicListTableView.reloadData()
                }
            } catch {
                print("エラー")
            }
        }
        
        alertController.addAction(addAction)
        alertController.addTextField { textField -> Void in
            self.inputTextField = textField
            textField.placeholder = "追加するテキスト"
        }
        present(alertController, animated: true, completion: nil)
        }

    func addPrepareTitle() {
            guard let addTitle = inputTextField?.text else {return}
            print( addTitle)
            //let addTitle = addText
            let saveTitle = Firestore.firestore().collection("Prepare").document()
            saveTitle.setData(["topic": addTitle])
    }
    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prepareTopicCell", for: indexPath) as! PrepareTopicTableViewCell
        cell.setCell(prepare: postArray[indexPath.row])
        
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.backgroundColor = .systemGray6
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "toDetail",sender: nil)
       // セルの選択を解除
       tableView.deselectRow(at: indexPath, animated: true)
   }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            //次の画面の取得
            let detailViewContorollre = segue.destination as! PrepareDetailViewController
            let selectedIndex = prepareTopicListTableView.indexPathForSelectedRow!
            detailViewContorollre.selectTopic = postArray[selectedIndex.row]
            
        
        }
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
