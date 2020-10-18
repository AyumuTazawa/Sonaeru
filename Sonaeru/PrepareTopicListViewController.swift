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
    var selectTitle: PrepareData!
    var postArray: [PrepareData] = []
    var inputTextField: UITextField?
    var text: UITextField!

    
    @IBOutlet weak var prepareTopicListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

        database = Firestore.firestore()
        prepareTopicListTableView.delegate = self
       prepareTopicListTableView.dataSource = self
        prepareTopicListTableView.register(UINib(nibName: "PrepareTopicTableViewCell", bundle: nil),  forCellReuseIdentifier: "prepareTopicCell")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*getData().done { posts in
            print(posts)
            self.postArray = posts
            self.prepareTopicListTableView.reloadData()
        }.catch { err in
            print(err)
        }*/
        self.takeData()
        
    }
    
    //データをFirestoreから受け取ってtableviewを更新する
    func takeData() {
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
        
        let alertController: UIAlertController = UIAlertController(title: "タイトルを入力してください", message: "備える災害を設定してください", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { action -> Void in
        }
        alertController.addAction(cancelAction)
        let addAction: UIAlertAction = UIAlertAction(title: "追加", style: .default) { action -> Void in
             //SVProgressHUD.show()
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
        saveTitle.setData(["topic": addTitle, "prepareID": saveTitle.documentID])
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
       // return cell
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
    
    
    
    // スワイプボタン
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let upDateAction = UITableViewRowAction(style: .default, title: "Detail"){ action, indexPath in
            // Do anything
            //let selectedCell = self.prepareTopicListTableView.indexPathForSelectedRow!
            self.selectTitle = self.postArray[indexPath.row]
            print(self.selectTitle.topic)
            self.updateTitleAlret()
            
        }
        
        //Cell削除&Firestoreからも削除
        let deleteAction = UITableViewRowAction(style: .default, title: "削除"){ action, indexPath in
            //Firebaseからも削除
            self.selectTitle = self.postArray[indexPath.row]
            self.deleteTitle()
            
        }
        
        return [upDateAction, deleteAction]
    }
    
    
    
    //Titleの更新
    func updateTitleAlret() {
        //Cellの情報を取得
        //let selectedCell = prepareTopicListTableView.indexPathForSelectedRow!
       // selectTitle = postArray[selectedCell.row]
        //アラートを表示
        let alertController: UIAlertController = UIAlertController(title: "文言タイトル", message: "メッセージ", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { action -> Void in
        }
        alertController.addAction(cancelAction)
        let addAction: UIAlertAction = UIAlertAction(title: "追加", style: .default) { action -> Void in
            
            do {
                self.upDateTitle()
                self.takeData()
            } catch {
                print("エラー")
            }
        }
        alertController.addAction(addAction)
            alertController.addTextField { textField -> Void in
                
                textField.placeholder = "追加するテキスト"
                //textField.text = self.selectTitle.topic
                //let updataTitleTxt = textField.text
                self.text = textField
        }
            present(alertController, animated: true, completion: nil)
            
        }
        
    //Firestoreのタイトルを更新
    func upDateTitle() {
        let updateTitle = self.text.text
        
        let ref = Firestore.firestore().collection("Prepare").document(self.selectTitle.prepareId)
        ref.updateData(["topic": updateTitle])
    }
      
        //削除
    func deleteTitle() {
        //アラートを表示
        let alertController: UIAlertController = UIAlertController(title: "削除しますか", message: "メッセージ", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { action -> Void in
        }
        alertController.addAction(cancelAction)
        let addAction: UIAlertAction = UIAlertAction(title: "削除", style: .default) { action -> Void in
            
            do {
                self.deletePrepareData()
                self.takeData()
            } catch {
                print("エラー")
            }
        }
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
        
    }
        
    //Title含めた全ての情報をTiresotoreから削除
    func deletePrepareData() -> Promise <Void> {
        return Promise { resolver in
            Firestore.firestore().collection("Prepare").document(self.selectTitle.prepareId).delete()
            
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
