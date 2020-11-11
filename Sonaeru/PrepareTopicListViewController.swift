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
    private let refreshContorol = UIRefreshControl()
    @IBOutlet weak var prepareTopicListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Firestore.firestore()
        prepareTopicListTableView.delegate = self
        prepareTopicListTableView.dataSource = self
        prepareTopicListTableView.register(UINib(nibName: "PrepareTopicTableViewCell", bundle: nil),  forCellReuseIdentifier: "prepareTopicCell")
        prepareTopicListTableView.refreshControl = refreshContorol
        refreshContorol.addTarget(self, action: #selector(PrepareTopicListViewController.refresh(sender:)), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //prepareTopicListTableViewにtopicを反映
        self.fostTableViewData()
    }
    
    //prepareTopicListTableViewにtopic入れる
    func fostTableViewData() {
        fechData().done { posts in
            self.postArray = posts
        }.catch { err in
            print(err)
        }.finally {
            self.prepareTopicListTableView.reloadData()
        }
    }
    
    //Prepare取得
    func fechData() -> Promise<[PrepareData]> {
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
            //TopicをFirestoreに追加
            self.uploadTopic()
        }
        
        alertController.addAction(addAction)
        alertController.addTextField { textField -> Void in
            self.inputTextField = textField
            textField.placeholder = "追加するテキスト"
        }
        present(alertController, animated: true, completion: nil)
    }
    
    //TopicをFirestoreに追加してリロード
    func uploadTopic() {
        firstly {
            self.addPrepareTitle()
        }.then {
            self.fechData()
        }.done { posts in
            self.postArray = posts
            self.prepareTopicListTableView.reloadData()
            print("reloadData")
        }.catch { err in
            print(err)
        }
    }
    //TopicをFirestoreに追加
    func addPrepareTitle() -> Promise<Void> {
        return Promise { reslver in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                guard let addTitle = self.inputTextField?.text else {return}
                print( addTitle)
                let saveTitle = Firestore.firestore().collection("Prepare").document()
                saveTitle.setData(["topic": addTitle, "prepareID": saveTitle.documentID]) { (err) in
                    if let err = err {
                        print(err)
                    } else {
                        reslver.fulfill(())
                    }
                }
            }
        }
    }
    
    
    // スワイプボタン
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let upDateAction = UITableViewRowAction(style: .default, title: "Detail"){ action, indexPath in
            
            self.selectTitle = self.postArray[indexPath.row]
            print(self.selectTitle.topic)
            self.updateTitleAlret()
            
        }
        
        //Cell削除&Firestoreからも削除
        let deleteAction = UITableViewRowAction(style: .default, title: "削除"){ action, indexPath in
            //Firebaseからも削除
            self.selectTitle = self.postArray[indexPath.row]
            //self.deleteTask()
            self.deleteTitle()
        }
        return [upDateAction, deleteAction]
    }
    
    //Titleの更新
    func updateTitleAlret() {
        //アラートを表示
        let alertController: UIAlertController = UIAlertController(title: "文言タイトル", message: "メッセージ", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { action -> Void in
        }
        alertController.addAction(cancelAction)
        let addAction: UIAlertAction = UIAlertAction(title: "追加", style: .default) { action -> Void in
            //Titleの更新を実行
            self.runUpdateTitle()
        }
        alertController.addAction(addAction)
        alertController.addTextField { textField -> Void in
            textField.placeholder = "追加するテキスト"
            self.text = textField
        }
        present(alertController, animated: true, completion: nil)
        
    }
    
    //Titleの更新を実行
    func runUpdateTitle() {
        firstly {
            self.upDateTitle()
        }.done {
            self.fostTableViewData()
        }.catch { err in
            print(err)
        }
    }
    
    //Firestoreのタイトルを更新
    func upDateTitle() -> Promise<Void> {
        return Promise { resolver in
            let updateTitle = self.text.text
            let ref = Firestore.firestore().collection("Prepare").document(self.selectTitle.prepareId)
            ref.updateData(["topic": updateTitle]) { (err) in
                if let err = err {
                    print(err)
                } else {
                    resolver.fulfill(())
                }
            }
        }
    }
    
    //削除
    func deleteTitle() {
        //アラートを表示
        let alertController: UIAlertController = UIAlertController(title: "削除しますか", message: "メッセージ", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { action -> Void in
        }
        alertController.addAction(cancelAction)
        let addAction: UIAlertAction = UIAlertAction(title: "削除", style: .default) { action -> Void in
            //削除を実行
            self.runDeleteTitle()
        }
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    //Titleの削除を実行
    func runDeleteTitle() {
        firstly {
            self.deletePrepareData()
        }.done {
            self.fostTableViewData()
        }.catch { err in
            print(err)
        }
    }
    
    //Title含めた全ての情報をTiresotoreから削除
    func deletePrepareData() -> Promise <Void> {
        return Promise { resolver in
            let prepareId = selectTitle.prepareId
            Firestore.firestore().collection("Prepare").document(self.selectTitle.prepareId).delete() { (err) in
                if let err = err {
                    print(err)
                } else {
                    resolver.fulfill(())
                }
            }
        }
    }
    
    //紙に引っ張ってTableViewを更新
    @objc func refresh(sender: UIRefreshControl) {
        self.fostTableViewData()
        refreshContorol.endRefreshing()
    }
    
    //以下Tableviewの設定
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
}

