//
//  SelectBeanPresetVC.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/07/03.
//

import UIKit
import CoreData
import SVProgressHUD
import Eureka

class SelectBeanPresetVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var searchController: UISearchController!
    var tableViewCellCount = 0
    weak var delegate: SendBeanDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    var beanMemos:[BeanMemo] = []
    var beanMemosFiltered :[BeanMemo] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var keyName = "beanTag_ForSortNamae"
    var boolName = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "コーヒー豆"
        tableView.backgroundColor = backgroundColor
        //tableViewの定型
        tableView.register(UINib(nibName: "BeanTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.dataSource = self
        tableView.delegate = self
        setup()
        
        
        setRightBarButton()
        setLeftBarButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ソート画面で変更したキー・オーダーをユーザーデフォルトから取得
        if UserDefaults.standard.string(forKey: "beanSortKeyName") == nil {
            print("Error")
        }else{
            keyName = UserDefaults.standard.string(forKey: "beanSortKeyName")!
        }
        boolName = UserDefaults.standard.bool(forKey: "beanSortOrderBool")
        // CoreDataからデータをfetchしてくる
        beanMemos = getBeanMemo(moc: managedObjectContext, keyName: keyName, boolName: boolName)
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
            selectedId = beanMemosFiltered[indexPath.row].beanId
            self.dismiss(animated: false, completion: nil)
            delegate?.sendBeanValue(id: selectedId)
        }else{
            selectedId = beanMemos[indexPath.row].beanId
            delegate?.sendBeanValue(id: selectedId)
        }
        self.dismiss(animated: true, completion: nil)
    }

    //配列の数を数えている
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewCellCount = beanMemos.count
        //数えた配列の数を格納（テーブルビューの最下段と同じ数字）
        if searchController.isActive {
            return beanMemosFiltered.count
        } else {
            return beanMemos.count
        }
    }
  
    //TableViewへ表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! BeanTableViewCell
   
        if searchController.isActive {
            let beanMemosSelected = beanMemosFiltered[indexPath.row]
            
            cell.label1.text = beanMemosSelected.beanTag_namae
            if beanMemosSelected.beanTag_memo != nil {
                cell.label2.text = beanMemosSelected.beanTag_memo
            }else{
                cell.label2.text = ""
            }
            cell.label3.text = beanMemosSelected.beanEditedDate
            cell.label4.text = beanMemosSelected.beanStatus

        }else{
            let beanMemosSelected = beanMemos[indexPath.row]
            cell.label1.text = beanMemosSelected.beanTag_namae
            if beanMemosSelected.beanTag_memo != nil {
                cell.label2.text = beanMemosSelected.beanTag_memo
            }else{
                cell.label2.text = ""
            }
            cell.label3.text = beanMemosSelected.beanEditedDate
            cell.label4.text = beanMemosSelected.beanStatus
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
        let sortVC = SortBeanVC(nibName: nil, bundle: nil)
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


// MARK: - UISearchResultsUpdating
extension SelectBeanPresetVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // SearchBarに入力したテキストを使って表示データをフィルタリングする。
        let text = searchController.searchBar.text ?? ""
        if text.isEmpty {
        } else {
            beanMemosFiltered = getBeanMemoFiltered(moc: managedObjectContext, text: text)
        }
        tableView.reloadData()
    }
}
