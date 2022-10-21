//
//  SelectGrindPresetVC.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/07/03.
//

import UIKit
import CoreData
import SVProgressHUD
import Eureka

class SelectGrindPresetVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var searchController: UISearchController!
    var tableViewCellCount = 0
    weak var delegate: SendGrindDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    var grindMemos:[GrindMemo] = []
    var grindMemosFiltered :[GrindMemo] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var keyName = "grindTag_ForSortNamae"
    var boolName = true

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "挽き方"
        tableView.backgroundColor = backgroundColor
        //tableViewの定型
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GrindTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        setup()
        
        //ボタンの作成と配置
        setRightBarButton()
        setLeftBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ソート画面で変更したキー・オーダーをユーザーデフォルトから取得
        if UserDefaults.standard.string(forKey: "grindSortKeyName") == nil {
            print("Error")
        }else{
            keyName = UserDefaults.standard.string(forKey: "grindSortKeyName")!
        }
        boolName = UserDefaults.standard.bool(forKey: "grindSortOrderBool")
        // CoreDataからデータをfetchしてくる
        grindMemos = getGrindMemo(moc: managedObjectContext, keyName: keyName, boolName: boolName)
        print(keyName)
        // taskTableViewを再読み込みする
        tableView.reloadData()
        
    }
    //dismiss後、遷移元VCで、viewWillAppearが動くようにする
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }

    
    var selectedId: String?
    //編集モードにて、セルを選択した際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            selectedId = grindMemosFiltered[indexPath.row].grindId
            self.dismiss(animated: false, completion: nil)
            delegate?.sendGrindValue(id: selectedId)
            
        }else{
            selectedId = grindMemos[indexPath.row].grindId
            delegate?.sendGrindValue(id: selectedId)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //配列の数を数えている
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewCellCount = grindMemos.count
        //数えた配列の数を格納（テーブルビューの最下段と同じ数字）
        if searchController.isActive {
            return grindMemosFiltered.count
            
        } else {
            return grindMemos.count
            
        }
    }
   
    //TableViewへ表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! GrindTableViewCell
   
        if searchController.isActive {
            
            let grindMemosSelected = grindMemosFiltered[indexPath.row]
            
            cell.label1.text = grindMemosSelected.grindTag_namae
            if grindMemosSelected.grindTag_memo != nil {
                cell.label2.text = grindMemosSelected.grindTag_memo
            }else{
                cell.label2.text = ""
            }
            cell.label3.text = grindMemosSelected.grindEditedDate
            
        }else{
            
            let grindMemosSelected = grindMemos[indexPath.row]

            cell.label1.text = grindMemosSelected.grindTag_namae
            if grindMemosSelected.grindTag_memo != nil {
                cell.label2.text = grindMemosSelected.grindTag_memo
            }else{
                cell.label2.text = ""
            }
            cell.label3.text = grindMemosSelected.grindEditedDate
            
        }
        
        cell.backgroundColor = contentBackgroundColor

        //編集モードのチェックマークの背景色（チェックマーク自体の色は白固定）
        cell.tintColor = .black
        //セル選択時の色
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray4
        cell.selectedBackgroundView = backgroundView

        return cell
    }

    
    //UIMenu機能搭載BarBttonItemの作成
    func setRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(rightButtonPressed(_:)))
        navigationItem.rightBarButtonItem?.tintColor = textColor
    }
    
    @objc func rightButtonPressed(_ sender: UIBarButtonItem){
        //ボタンの作成と配置
        let sortVC = SortGrindVC(nibName: nil, bundle: nil)
        /* ここが実装のキモ */
        if let sheet = sortVC.sheetPresentationController {
            // ここで指定したサイズで表示される
            sheet.detents = [.medium()]
        }
        present(sortVC, animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    private func setup() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = textColor

        if #available(iOS 11.0, *) {
            // UISearchControllerをUINavigationItemのsearchControllerプロパティにセットする。
            navigationItem.searchController = searchController

            // trueだとスクロールした時にSearchBarを隠す（デフォルトはtrue）
            // falseだとスクロール位置に関係なく常にSearchBarが表示される
            navigationItem.hidesSearchBarWhenScrolling = false
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

extension SelectGrindPresetVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // SearchBarに入力したテキストを使って表示データをフィルタリングする。
        let text = searchController.searchBar.text ?? ""
        if text.isEmpty {

        } else {
            grindMemosFiltered = getGrindMemoFiltered(moc: managedObjectContext, text: text)
        }
        tableView.reloadData()
    }
}
