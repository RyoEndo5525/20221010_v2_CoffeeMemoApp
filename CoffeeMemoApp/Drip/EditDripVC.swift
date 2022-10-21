//
//  EditDripVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import SVProgressHUD

class EditDripVC: FormViewController {
    
    //prepare TableDripVCからdripIdの引き継ぎ
    var toEditDripVC: String!
    
    //CoreDataの入れ物を先に作っておく
    var dripMemos:[DripMemo] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreDataを取得して、配列へ格納
        dripMemos = getDripMemoId(moc: managedObjectContext, dripId: toEditDripVC)
        navigationItem.title = "編集"
        tableView.backgroundColor = backgroundColor
        
        var tyuusyutuValue:Tuple<String, String>?
        if dripMemos[0].dripTag_tyuusyutujikann_minutes != nil && dripMemos[0].dripTag_tyuusyutujikann_seconds != nil {
            tyuusyutuValue = Tuple(a: dripMemos[0].dripTag_tyuusyutujikann_minutes!, b: dripMemos[0].dripTag_tyuusyutujikann_seconds!)
        }
        var murasiValue:Tuple<String, String>?
        if dripMemos[0].dripTag_murasijikann_minutes != nil && dripMemos[0].dripTag_murasijikann_seconds != nil {
            murasiValue = Tuple(a: dripMemos[0].dripTag_murasijikann_minutes!, b: dripMemos[0].dripTag_murasijikann_seconds!)
        }
        
        var dripTag_ondo: Double?
        if dripMemos[0].dripTag_ondo != nil {
            dripTag_ondo = Double(dripMemos[0].dripTag_ondo!)
        }
        var dripTag_ryou: Double?
        if dripMemos[0].dripTag_ryou != nil {
            dripTag_ryou = Double(dripMemos[0].dripTag_ryou!)
        }
        var dripTag_sasiyu: Double?
        if dripMemos[0].dripTag_sasiyu != nil {
            dripTag_sasiyu = Double(dripMemos[0].dripTag_sasiyu!)
        }
        

        form
        +++ Section("抽出方法")
        setTextRow(tag: "dripTag_namae", title: "名前", ph: "", value: dripMemos[0].dripTag_namae)
        setDecimalRow(tag: "dripTag_ondo", title: "お湯の温度", ph: "℃", value: dripTag_ondo)
        setDecimalRow(tag: "dripTag_ryou", title: "お湯の量", ph: "g", value: dripTag_ryou)
        setDoublePickerInputRow(tag: "dripTag_tyuusyutujikann", title: "抽出時間", value: tyuusyutuValue)
        setDoublePickerInputRow(tag: "dripTag_murasijikann", title: "蒸らし時間", value: murasiValue)
        
        form
        +++ Section("サブメニュー")
        setDecimalRow(tag: "dripTag_sasiyu", title: "差し湯の量", ph: "g", value: dripTag_sasiyu)
        setTextRow(tag: "dripTag_rinsu", title: "リンス有無", ph: "", value: dripMemos[0].dripTag_rinsu)
        setTextRow(tag: "dripTag_paper", title: "フィルターの種類", ph: "", value: dripMemos[0].dripTag_paper)
        setTextRow(tag: "dripTag_dorippa", title: "ドリッパーの種類", ph: "", value: dripMemos[0].dripTag_dorippa)
        
        form
        +++ Section("メモ")
        setTextAreaRow(tag: "dripTag_memo", title: "メモ", ph: "", value: dripMemos[0].dripTag_memo)
        
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
                //基本情報
                self.dripMemos[0].dripTag_namae = values["dripTag_namae"] as? String
                self.dripMemos[0].dripTag_rinsu = values["dripTag_rinsu"] as? String
                self.dripMemos[0].dripTag_paper = values["dripTag_paper"] as? String
                self.dripMemos[0].dripTag_dorippa = values["dripTag_dorippa"] as? String

                
                if (values["dripTag_ondo"] as? Double) != nil {
                    self.dripMemos[0].dripTag_ondo = (values["dripTag_ondo"] as? Double)!.description
                }else{
                    self.dripMemos[0].dripTag_ondo = nil
                }
                if (values["dripTag_ryou"] as? Double) != nil {
                    self.dripMemos[0].dripTag_ryou = (values["dripTag_ryou"] as? Double)!.description
                }else{
                    self.dripMemos[0].dripTag_ryou = nil
                }
                if (values["dripTag_sasiyu"] as? Double) != nil {
                    self.dripMemos[0].dripTag_sasiyu = (values["dripTag_sasiyu"] as? Double)!.description
                }else{
                    self.dripMemos[0].dripTag_sasiyu = nil
                }
                
                //DoublePickerInputRowがタプル構造体での形式のため、form.values()ではなく直接取得
                let murasiRow = self.form.rowBy(tag: "dripTag_murasijikann") as! DoublePickerInputRow<String, String>
                if murasiRow.value != nil {
                    let murasiValue = murasiRow.value!
                    self.dripMemos[0].dripTag_murasijikann_minutes = murasiValue.a
                    self.dripMemos[0].dripTag_murasijikann_seconds = murasiValue.b
                }else{
                    self.dripMemos[0].dripTag_murasijikann_minutes = nil
                    self.dripMemos[0].dripTag_murasijikann_seconds = nil
                }
                let tyuusyutuRow = self.form.rowBy(tag: "dripTag_tyuusyutujikann") as! DoublePickerInputRow<String, String>
                if tyuusyutuRow.value != nil {
                    let tyuusyutuValue = tyuusyutuRow.value!
                    self.dripMemos[0].dripTag_tyuusyutujikann_minutes = tyuusyutuValue.a
                    self.dripMemos[0].dripTag_tyuusyutujikann_seconds = tyuusyutuValue.b
                }else{
                    self.dripMemos[0].dripTag_tyuusyutujikann_minutes = nil
                    self.dripMemos[0].dripTag_tyuusyutujikann_seconds = nil
                }
                
                //メモの情報
                self.dripMemos[0].dripTag_memo = values["dripTag_memo"] as? String
                self.dripMemos[0].dripEditedDate = self.getNow()
           
                //並べ替え用　カタカナ変換
                let dripTag_namae = values["dripTag_namae"] as? String
                if dripTag_namae != nil {
                    self.dripMemos[0].dripTag_ForSortNamae = dripTag_namae!.convertKana()
                }
                
                //変更した内容にてデータを保存する（上書き保存）
                do{
                    try self.managedObjectContext.save()
                }catch{
                    print("エラーだよ")
                }
                
                //インジケータの非表示
                SVProgressHUD.dismiss()
                //完了メッセージ
                self.doneMessageToRoot()

            }
        }
    }

    
}
