//
//  SortBeanVC.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/03/27.
//

import UIKit
import Eureka

class SortBeanVC: FormViewController {
    
    let sortButton = UIButton()
    // フォームに入れ込む値
    let sortItems = [[["名前"], ["アルファベット順", "逆アルファベット順"]],
                     [["変更日"], ["古い順", "新しい順"]],
                     [["シングル・ブレンド"], ["シングル", "ブレンド"]]
    ]

    //UserDefaultsがない時用の初期値
    var sortKeyName :String = "beanTag_ForSortNamae"
    var sortOrderBool :Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = backgroundColor
        //スクロールできないようにする
        tableView.isScrollEnabled = false
        //並べ替え確定ボタンの作成
        createSortButton(buttonTitle: sortButton)

        //UserDefaultsにsortKeyNameがあるなら、その項目を代入する
        if UserDefaults.standard.string(forKey: "beanSortKeyName") != nil {
            sortKeyName = UserDefaults.standard.string(forKey: "beanSortKeyName")!
            sortOrderBool = UserDefaults.standard.bool(forKey: "beanSortOrderBool")
        }

        //UserDefaultsに応じたSortItemsを入れる変数を作成。初期値は名前にて
        var selectedSortItem = sortItems[0][0][0]
        var trueOrderItem = sortItems[0][1][0]
        var falseOrderItem = sortItems[0][1][1]
        
        //UserDefaultsに応じて、SortItemsを代入する
        switch sortKeyName {
            case "beanTag_ForSortNamae":
                selectedSortItem = sortItems[0][0][0]
                trueOrderItem = sortItems[0][1][0]
                falseOrderItem = sortItems[0][1][1]

            case "beanEditedDate":
                selectedSortItem = sortItems[1][0][0]
                trueOrderItem = sortItems[1][1][0]
                falseOrderItem = sortItems[1][1][1]

            case "beanStatus":
                selectedSortItem = sortItems[2][0][0]
                trueOrderItem = sortItems[2][1][0]
                falseOrderItem = sortItems[2][1][1]

            default:
                print("Error")
        }
        
        // 項目のフォームを作成
        form +++ SelectableSection<ListCheckRow<String>>("次で並べ替え", selectionType: .singleSelection(enableDeselection: false))
        //名前フォーム
        <<< ListCheckRow <String> { listRow in
            listRow.title = sortItems[0][0][0]
            listRow.selectableValue = sortItems[0][0][0]
            listRow.cell.tintColor = textColor
            // 画面遷移の後、初期状態で、初期値を選択状態にする処理
            if selectedSortItem == listRow.title {
                listRow.value = selectedSortItem
            } else {
                listRow.value = nil
            }
        }
        //変更日フォーム
        <<< ListCheckRow <String> { listRow in
            listRow.title = sortItems[1][0][0]
            listRow.selectableValue = sortItems[1][0][0]
            listRow.cell.tintColor = textColor
            // 画面遷移の後、初期状態で、初期値を選択状態にする処理
            if selectedSortItem == listRow.title {
                listRow.value = selectedSortItem
            } else {
                listRow.value = nil
            }
        }
        //シングル・ブレンド　フォーム
        <<< ListCheckRow<String> { listRow in
            listRow.title = sortItems[2][0][0]
            listRow.selectableValue = sortItems[2][0][0]
            listRow.cell.tintColor = textColor
            // 画面遷移の後、初期状態で、初期値を選択状態にする処理
            if selectedSortItem == listRow.title {
                listRow.value = selectedSortItem
            } else {
                listRow.value = nil
            }
        }
        
        // 昇順降順のフォームを作成
        form +++ SelectableSection<ListCheckRow<String>>("順番", selectionType: .singleSelection(enableDeselection: false))
        //trueのフォーム
        <<< ListCheckRow<String> { listRow in
            listRow.title = trueOrderItem
            listRow.selectableValue = trueOrderItem
            listRow.tag = "trueの場合"
            listRow.cell.tintColor = textColor
            // 画面遷移の後、初期状態で、初期値を選択状態にする処理
            if sortOrderBool {
                listRow.value = "true"
            } else {
                listRow.value = nil
            }
        }
        //falseのフォーム
        <<< ListCheckRow<String> { listRow in
            listRow.title = falseOrderItem
            listRow.selectableValue = falseOrderItem
            listRow.tag = "falseの場合"
            listRow.cell.tintColor = textColor
            // 画面遷移の後、初期状態で、初期値を選択状態にする処理
            if sortOrderBool == false{
                listRow.value = "false"
            } else {
                listRow.value = nil
            }
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    // 選択が変更された時の処理。２回呼ばれる。
    // 1回目：　oldValue = some  ,  newValue = nil
    // 2回目：　oldValue = nil   ,  newValue = some
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if newValue != nil {
            if row.section === form[0] {
                //フォームのセクション0の処理（上側）
                switch (row.section as! SelectableSection<ListCheckRow<String>>).selectedRow()?.baseValue as! String {
                    //選択したセルのbaseValueで判別
                    case "名前":
                        changeOrderValue(index:0)
                        sortKeyName = "beanTag_ForSortNamae"
                    case "変更日":
                        changeOrderValue(index:1)
                        sortKeyName = "beanEditedDate"
                    case "シングル・ブレンド":
                        changeOrderValue(index:2)
                        sortKeyName = "beanStatus"
                    default:
                        print("Error")
                }
            }else{
                //フォームのセクション0以外（下側）
                switch (row.section as! SelectableSection<ListCheckRow<String>>).selectedRow()?.tag {
                    //選択したセルのtag名で判別
                    case "trueの場合":
                        sortOrderBool = true
                    case "falseの場合":
                        sortOrderBool = false
                    default:
                        print("Error")
                }
            }
        }
    }
    
    func changeOrderValue(index:Int) {
        //選択しているセルが変更された際に、昇順降順の項目をそれに応じたものへ変える
        form.rowBy(tag: "trueの場合")?.title = sortItems[index][1][0] as String?
        form.rowBy(tag: "falseの場合")?.title = sortItems[index][1][1] as String?
        form.rowBy(tag: "trueの場合")?.reload()
        form.rowBy(tag: "falseの場合")?.reload()

    }
    
    //並べ替えボタンの作成と配置・制約
    func createSortButton(buttonTitle: UIButton) {
        let button = buttonTitle
        // 必ずfalseにする（理由は後述）
        button.translatesAutoresizingMaskIntoConstraints = false
        // tintColorを黒にする
        button.tintColor = textColor
        // plustButtonのImageをplus（+）に設定する
        button.setTitle("並べ替える", for: .normal)
        button.setTitleColor(textColor, for: .normal)
        // ViewにplusButtonを設置する（必ず制約を設定する前に記述する）
        self.view.addSubview(button)
        // plustButtonの下端をViewの下端から-50pt（=上に50pt）
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        // plustButtonの右端をViewの右端から-30pt（=左に30pt）
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive = true
        // plustButtonの高さを50にする
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        // plusButtonの幅を50にする
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //ボタンを押したときの処理
        button.addAction(.init { _ in self.sortButtonAction(button: button)}, for: .touchUpInside)
    }
    //並べ替えボタン、の処理
    func sortButtonAction(button : UIButton){
        //UserDefaultsを更新するだけ。
        //tableviewの読み込み直し時に再度fetchするので、そこでソートされる
        UserDefaults.standard.set(sortKeyName, forKey: "beanSortKeyName")
        UserDefaults.standard.set(sortOrderBool, forKey: "beanSortOrderBool")

        self.dismiss(animated: true, completion: nil)
    }

}

