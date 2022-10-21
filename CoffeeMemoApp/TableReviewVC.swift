//
//  TableReviewVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import SVProgressHUD
import Eureka
import ImageRow

class TableReviewVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var searchController: UISearchController!
    var tableViewCellCount = 0
    
    @IBOutlet weak var tableView: UITableView!
    var reviewImages:[ReviewImage] = []
    var reviewMemos:[ReviewMemo] = []
    var reviewMemosFiltered :[ReviewMemo] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // UIButtonを生成する
    let plusButton = UIButton()
    
    var keyName = "reviewTag_ForSortNamae"
    var boolName = true
    
    var selectedIndexPaths:[IndexPath] = []
    var sortedIndexPaths:[IndexPath] = []
    var editingStatus = false
    var swipedIndexPath:IndexPath?
    
    let sortVC = SortReviewVC(nibName: nil, bundle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "レビュー"
        //tableViewの定型
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        setup()
        
        //ボタンの作成と配置
        setRightBarButton_2items(viewController: sortVC)
        setPlusButton(button: plusButton)

        //編集モードの際、複数選択可能へ
        tableView.allowsMultipleSelectionDuringEditing = true


    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ソート画面で変更したキー・オーダーをユーザーデフォルトから取得
        if UserDefaults.standard.string(forKey: "reviewSortKeyName") != nil {
            keyName = UserDefaults.standard.string(forKey: "reviewSortKeyName")!
        }
        boolName = UserDefaults.standard.bool(forKey: "reviewSortOrderBool")
        
        // CoreDataからデータをfetchしてくる
        reviewMemos = getReviewMemo(moc: managedObjectContext, keyName: keyName, boolName: boolName)
        print(keyName)
        
        // taskTableViewを再読み込みする
        tableView.reloadData()
    }


    //DetailBeanVCへ選択したセルのBeanMemoIdを送っている
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "detailSegue" {
           if let indexPath = tableView.indexPathForSelectedRow {
             let destination = segue.destination as? DetailReviewVC
               if searchController.isActive {
                   destination?.toDetailReviewVC = reviewMemosFiltered[indexPath.row].reviewId
               }else{
                   destination?.toDetailReviewVC = reviewMemos[indexPath.row].reviewId
               }
            }
       }
    }
    
    //編集モードの際、左ボタンを全て選択へ変更。処理はbuttonTappedにて
    private func setLeftBarButtonItem(editing: Bool){
        if editing {
            let button = UIBarButtonItem(title: "全て選択",
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.leftBarButtonTapped(_:))
                                            )
            navigationItem.leftBarButtonItem = button
        }else{
            navigationItem.leftBarButtonItem = nil
        }
    }

    //編集モードの際、左ボタンの全選択系の処理内容
    @objc func leftBarButtonTapped(_ sender: UIBarButtonItem) {
        switch sender.title {
            case "全て選択":
                for i in 0..<tableViewCellCount {
                    self.tableView.selectRow(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .none)
                }
                //手動でdidSelectRowAtを呼ぶ必要あり
                self.tableView(self.tableView, didSelectRowAt: [0, 0])
                sender.title = "選択解除"
            case "選択解除":
                for i in 0..<tableViewCellCount {
                    self.tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true )
                }
                //手動でdidDeselectRowAtを呼ぶ必要あり
                self.tableView(self.tableView, didDeselectRowAt: [0, 0])
                sender.title = "全て選択"
            default:
                self.navigationController?.popViewController(animated: true)
        }
    }
    
    //編集モードにて、セルを選択した際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            //xibカスタムセル設定によりsegueが無効になっているためsegueを発生させる
            self.performSegue(withIdentifier: "detailSegue", sender: self.tableView)
            tableView.deselectRow(at: indexPath, animated: true)
        }else{
            //右上ボタンを削除へ変更
            self.editButtonItem.title = "削除"
        }
        
    }

    //編集モードにて、セルを選択解除した際の処理
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //どれも選択されていない時、右上ボタンを完了へ変更
        let selectedIndexPaths = self.tableView.indexPathsForSelectedRows
        if selectedIndexPaths == nil {
            self.editButtonItem.title = "完了"
        }
    }
    //編集モード開始・終了時の処理内容
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing , animated: animated)
        editingStatus = editing
        if editingStatus {
            // 編集開始の処理
            self.editButtonItem.title = "完了"
            searchController.searchBar.searchTextField.isEnabled = false
            //テーブルビューをeditingStatusで判別して、選択可能にする（左のチェックマーク）
            setLeftBarButtonItem(editing: editingStatus)
            tableView.isEditing = editingStatus
            plusButton.isHidden = editingStatus
            
        } else {
            if tableView.indexPathsForSelectedRows == nil {
                //左右ボタンを編集モード仕様から元に戻す（右:Menu, 左:nil）
                self.setRightBarButton_2items(viewController: sortVC)
                //テーブルビューをeditingStatusで判別して、選択不可にする（編集モード終了）
                setLeftBarButtonItem(editing: editingStatus)
                self.tableView.isEditing = editingStatus
                self.plusButton.isHidden = editingStatus
                
            }else{
                //選択した行を、配列に格納する
                selectedIndexPaths = tableView.indexPathsForSelectedRows!
                //削除時にエラーが出ないように、並び替えを行う
                sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
                //削除しても良いかの確認アラートを出す、編集モード終了の処理もアラートのアクションに記載
                self.alertActionDeleteRows()
            }
            searchController.searchBar.searchTextField.isEnabled = true
        }
    }
    
    //複数行削除の際に出てくる、アラート表示
    func alertActionDeleteRows() {
        //右ボタンがEditになるため、削除に変える
        self.editButtonItem.title = "削除"
        //削除してもよいかの確認ができる　アラート表示
        let alert = UIAlertController(title: "削除", message: "選択した行を\n削除してもよろしいですか？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
            //左右ボタンを編集モード仕様から元に戻す（右:Menu, 左:nil）
            self.setRightBarButton_2items(viewController: self.sortVC)
            //テーブルビューを選択可能にする（左のチェックマーク）
            self.setLeftBarButtonItem(editing: self.editingStatus)
            self.tableView.isEditing = self.editingStatus
            self.plusButton.isHidden = self.editingStatus
        })
        let delete = UIAlertAction(title: "削除", style: .default, handler: { (action) -> Void in
            //インジケータの表示
            SVProgressHUD.show(withStatus: "削除中です")
            
            //イベントメソッドが終わらないと画面表示が更新されないので
            //メインスレッドでの処理だが、時差で仕込み　ひとまず画面更新をかける
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.deleteRows()
                //左右ボタンを編集モード仕様から元に戻す（右:Menu, 左:nil）
                self.setRightBarButton_2items(viewController: self.sortVC)
                //テーブルビューを選択不可にする（左のチェックマーク）
                self.setLeftBarButtonItem(editing: self.editingStatus)
                self.tableView.isEditing = self.editingStatus
                self.plusButton.isHidden = self.editingStatus
                
                //インジケータの非表示
                SVProgressHUD.dismiss()
                
                //完了メッセージ
                let alert = UIAlertController(title: "削除できました", message: "削除が完了しました", preferredStyle: .alert)
                let okTimeAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:{(action) -> Void in
                    print("削除完了")
                    })
                alert.addAction(okTimeAction)
                self.present(alert, animated: false, completion: nil)
            }
        })
        alert.addAction(cancel)
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
    
    //編集モード終了時に呼び出す、複数行　削除する関数
    func deleteRows() {
        for indexPathList in sortedIndexPaths {
            //①画像データのエンティティーを削除
//            getReviewImageId(reviewId: reviewMemos[indexPathList.row].reviewId!)
            reviewImages = getReviewImageId(moc: managedObjectContext, reviewId: reviewMemos[indexPathList.row].reviewId!)
            managedObjectContext.delete(reviewImages[0])
            //②CoreDataから削除
            managedObjectContext.delete(reviewMemos[indexPathList.row])
            do {
                try managedObjectContext.save()
            } catch {
              let nsError = error as NSError
              fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            //③配列から削除
            self.reviewMemos.remove(at: indexPathList.row)
        }
        //④tableViewから削除
        self.tableView.deleteRows(at: sortedIndexPaths, with: UITableView.RowAnimation.automatic)
    }

    //スワイプしたセルの削除ボタンを押した際の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        swipedIndexPath = indexPath
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //削除してもよいかの確認ができる様なアラートを実装
            self.alertActionDeleteRow()
        }
    }
    
    //スワイプした１行の削除の際に出てくる、アラート表示
    func alertActionDeleteRow() {
        //削除してもよいかの確認ができる　アラート表示
        let alert = UIAlertController(title: "削除", message: "削除してもよろしいですか？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in

        })
        let delete = UIAlertAction(title: "削除", style: .default, handler: { (action) -> Void in
            self.deleteRow()
        })

        alert.addAction(cancel)
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
    
    //スワイプした１行を削除する関数
    func deleteRow(){
        if swipedIndexPath != nil {
            //①画像データのエンティティーを削除
//            getReviewImageId(reviewId: reviewMemos[swipedIndexPath!.row].reviewId!)
            reviewImages = getReviewImageId(moc: managedObjectContext, reviewId: reviewMemos[swipedIndexPath!.row].reviewId!)
            managedObjectContext.delete(reviewImages[0])
            //②CoreDataからの削除
            managedObjectContext.delete(reviewMemos[swipedIndexPath!.row])
            do {
              try managedObjectContext.save()
            } catch {
              let nsError = error as NSError
              fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            //③配列からの削除
            reviewMemos.remove(at: swipedIndexPath!.row)
            //④tableViewからの削除
            tableView.deleteRows(at: [swipedIndexPath! as IndexPath], with: UITableView.RowAnimation.automatic)
        }else{
            
        }
    }

    //配列の数を数えている
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewCellCount = reviewMemos.count
        //数えた配列の数を格納（テーブルビューの最下段と同じ数字）
        if searchController.isActive {
            return reviewMemosFiltered.count
            
        } else {
            return reviewMemos.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    //TableViewへ表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ReviewTableViewCell
        if searchController.isActive {
            let reviewMemosSelected = reviewMemosFiltered[indexPath.row]
            
            cell.label1.text = reviewMemosSelected.reviewTag_namae
            if reviewMemosSelected.reviewTag_memo != nil {
                cell.label2.text = reviewMemosSelected.reviewTag_memo
            }else{
                cell.label2.text = ""
            }
            cell.label3.text = reviewMemosSelected.reviewEditedDate
            cell.label4.text = reviewMemosSelected.reviewTag_hyouka.description
            
        }else{
            plusButton.isHidden = false
            let reviewMemosSelected = reviewMemos[indexPath.row]
            
            cell.label1.text = reviewMemosSelected.reviewTag_namae
            if reviewMemosSelected.reviewTag_memo != nil {
                cell.label2.text = reviewMemosSelected.reviewTag_memo
            }else{
                cell.label2.text = ""
            }
            cell.label3.text = reviewMemosSelected.reviewEditedDate
            cell.label4.text = "評価：" + reviewMemosSelected.reviewTag_hyouka.description
            

        }
        cell.backgroundColor = contentBackgroundColor
        //編集モードのチェックマークの背景色（チェックマーク自体の色は白固定）
        cell.tintColor = .black
        //セル選択時の色
        let backgroundView = UIView()
        backgroundView.backgroundColor = selectBackgroundColor
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }


    // MARK: Private Methods
    private func setup() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = textColor
        searchController.searchBar.searchTextField.backgroundColor = contentBackgroundColor

        if #available(iOS 11.0, *) {
            // UISearchControllerをUINavigationItemのsearchControllerプロパティにセットする。
            navigationItem.searchController = searchController

            // trueだとスクロールした時にSearchBarを隠す（デフォルトはtrue）
            // falseだとスクロール位置に関係なく常にSearchBarが表示される
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //searchBarがアクティブな状態で、スクロールをするとキーボードをしまう
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    //searchBarがアクティブな状態で、スクロールをするとキーボードをしまう
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchController.searchBar.resignFirstResponder()
    }
}



extension TableReviewVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        plusButton.isHidden = true
        // SearchBarに入力したテキストを使って表示データをフィルタリングする。
        let text = searchController.searchBar.text ?? ""
        if text.isEmpty {
            
        } else {
//            getReviewMemoFiltered(text: text)
            reviewMemosFiltered = getReviewMemoFiltered(moc: managedObjectContext, text: text)
        }
        tableView.reloadData()
    }
}
