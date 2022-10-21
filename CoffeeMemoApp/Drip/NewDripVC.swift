//
//  NewDripVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import SVProgressHUD


class NewDripVC: FormViewController {

    //ImageRowで選択された画像を格納する変数
    var saveBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "抽出方法"
        tableView.backgroundColor = backgroundColor
        setLeftBarButton()

        form
        +++ Section("抽出方法")
        setTextRow(tag: "dripTag_namae", title: "名前", ph: "", value: nil)
        setDecimalRow(tag: "dripTag_ondo", title: "お湯の温度", ph: "℃", value: nil)
        setDecimalRow(tag: "dripTag_ryou", title: "お湯の量", ph: "g", value: nil)
        setDoublePickerInputRow(tag: "dripTag_tyuusyutujikann", title: "抽出時間", value: nil)
        setDoublePickerInputRow(tag: "dripTag_murasijikann", title: "蒸らし時間", value: nil)
        
        form
        +++ Section("サブメニュー")
        setDecimalRow(tag: "dripTag_sasiyu", title: "差し湯の量", ph: "g", value: nil)
        setTextRow(tag: "dripTag_rinsu", title: "リンス有無", ph: "", value: nil)
        setTextRow(tag: "dripTag_paper", title: "フィルターの種類", ph: "", value: nil)
        setTextRow(tag: "dripTag_dorippa", title: "ドリッパーの種類", ph: "", value: nil)
        
        form
        +++ Section("メモ")
        setTextAreaRow(tag: "dripTag_memo", title: "メモ", ph: "", value: nil)
        
    }
    
    //dismiss後、遷移元VCで、viewWillAppearが動くようにする
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    //保存ボタンの処理
    @IBAction func saveButton(_ sender: Any) {
        //キーボードを閉じる
        view.endEditing(true)

        //フォームへの入力値をvalues（配列）へ格納
        let values = form.values()
        
        //名前を必須項目として、未入力の場合はエラー表示
        if values["dripTag_namae"] as? String == nil {
            self.errorMessageName()

        } else {
            //インジケータの表示
            SVProgressHUD.show(withStatus: "保存中です")
            
            //イベントメソッドが終わらないと画面表示が更新されないので
            //メインスレッドでの処理だが、時差で仕込み　ひとまず画面更新をかける
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let dripMemos = DripMemo(context: managedObjectContext)
                
                // 作成日の格納（現在日時を取得と配列への格納）
                let now = Date()
                let dateFormatter = DateFormatter()
                guard let formatString = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
                else { fatalError() }
                dateFormatter.dateFormat = formatString
                dripMemos.dripCreatedDate = dateFormatter.string(from: now)
                dripMemos.dripEditedDate = dateFormatter.string(from: now)
                
                //ID関係の作成と登録
                let UUID = UUID().uuidString + dateFormatter.string(from: now)
                dripMemos.dripId = UUID
                
                //並べ替え用　カタカナ変換
                let dripTag_namae = values["dripTag_namae"] as? String
                if dripTag_namae != nil {
                    dripMemos.dripTag_ForSortNamae = dripTag_namae!.convertKana()
                }
                if (values["dripTag_ondo"] as? Double) != nil {
                    dripMemos.dripTag_ondo = (values["dripTag_ondo"] as? Double)!.description
                }
                
                if (values["dripTag_ryou"] as? Double) != nil {
                    dripMemos.dripTag_ryou = (values["dripTag_ryou"] as? Double)!.description
                }
                if (values["dripTag_sasiyu"] as? Double) != nil {
                    dripMemos.dripTag_sasiyu = (values["dripTag_sasiyu"] as? Double)!.description
                }

                //以下、入力値の反映
                dripMemos.dripTag_namae = values["dripTag_namae"] as? String
                dripMemos.dripTag_rinsu = values["dripTag_rinsu"] as? String
                dripMemos.dripTag_paper = values["dripTag_paper"] as? String
                dripMemos.dripTag_dorippa = values["dripTag_dorippa"] as? String
                //DoublePickerInputRowがタプル構造体での形式のため、form.values()ではなく直接取得
                let murasiRow = self.form.rowBy(tag: "dripTag_murasijikann") as! DoublePickerInputRow<String, String>
                if murasiRow.value != nil {
                    let murasiValue = murasiRow.value!
                    dripMemos.dripTag_murasijikann_minutes = murasiValue.a
                    dripMemos.dripTag_murasijikann_seconds = murasiValue.b
                }
                let tyuusyutuRow = self.form.rowBy(tag: "dripTag_tyuusyutujikann") as! DoublePickerInputRow<String, String>
                if tyuusyutuRow.value != nil {
                    let tyuusyutuValue = tyuusyutuRow.value!
                    dripMemos.dripTag_tyuusyutujikann_minutes = tyuusyutuValue.a
                    dripMemos.dripTag_tyuusyutujikann_seconds = tyuusyutuValue.b
                }

                //メモの情報
                dripMemos.dripTag_memo = values["dripTag_memo"] as? String

                //appdelegateのsaveContextメソッドを使って保存
                //saveContextは現在のマネージドオブジェクトの変更内容をDBに反映する
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                //インジケータの非表示
                SVProgressHUD.dismiss()
                //完了メッセージ
                self.doneMessageDismiss()

            }
        }
    }


}
    


    



