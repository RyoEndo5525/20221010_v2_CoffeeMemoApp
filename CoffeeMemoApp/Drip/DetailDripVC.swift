//
//  DetailDripVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import ViewRow

class DetailDripVC: FormViewController {

    //prepare TableDripVCからdripIdの引き継ぎ
    var toDetailDripVC: String!
    
    //CoreDataの入れ物を先に作っておく
    var dripMemos:[DripMemo] = []
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        //CoreDataを取得して、配列へ格納
        dripMemos = getDripMemoId(moc: managedObjectContext, dripId: toDetailDripVC)
        
        navigationItem.title = dripMemos[0].dripTag_namae
        tableView.backgroundColor = backgroundColor
        
        var tyuusyutuValue:String?
        if dripMemos[0].dripTag_tyuusyutujikann_minutes != nil &&
            dripMemos[0].dripTag_tyuusyutujikann_seconds != nil {
                tyuusyutuValue = dripMemos[0].dripTag_tyuusyutujikann_minutes!
                        + dripMemos[0].dripTag_tyuusyutujikann_seconds!
        }
        
        var murasiValue:String?
        if dripMemos[0].dripTag_murasijikann_minutes != nil &&
            dripMemos[0].dripTag_murasijikann_seconds != nil {
                murasiValue = dripMemos[0].dripTag_murasijikann_minutes!
                        + dripMemos[0].dripTag_murasijikann_seconds!
        }
        
        
        //descriptionが不安、nilに対して実行できるのかどうか？
        form
        +++ Section("抽出方法")
        setLabelRow(tag: "dripCreatedDate", title: "作成日", value: dripMemos[0].dripCreatedDate)
        setLabelRow(tag: "dripEditedDate", title: "変更日", value: dripMemos[0].dripEditedDate)
        setLabelRow(tag: "dripTag_namae", title: "名前", value: dripMemos[0].dripTag_namae)
        setLabelRow(tag: "dripTag_ondo", title: "お湯の温度", value: dripMemos[0].dripTag_ondo)
        setLabelRow(tag: "dripTag_ryou", title: "お湯の量", value: dripMemos[0].dripTag_ryou)
        setLabelRow(tag: "dripTag_tyuusyutujikann", title: "抽出時間", value: tyuusyutuValue)
        setLabelRow(tag: "dripTag_murasijikann", title: "蒸らし時間", value: murasiValue)

        form
        +++ Section("サブメニュー")
        setLabelRow(tag: "dripTag_sasiyu", title: "差し湯の量", value: dripMemos[0].dripTag_sasiyu)
        setLabelRow(tag: "dripTag_rinsu", title: "リンス有無", value: dripMemos[0].dripTag_rinsu)
        setLabelRow(tag: "dripTag_paper", title: "フィルターの種類", value: dripMemos[0].dripTag_paper)
        setLabelRow(tag: "dripTag_dorippa", title: "ドリッパーの種類", value: dripMemos[0].dripTag_dorippa)

        form
        +++ Section("メモ")
        setTextAreaRow(tag: "dripTag_memo", title: "メモ", ph: "", value: dripMemos[0].dripTag_memo)
        (form.rowBy(tag: "dripTag_memo") as! TextAreaRow).textAreaMode = TextAreaMode.readOnly
        
    }

    //editVCへIDを送る
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "editSegue" {
            let destination = segue.destination as? EditDripVC
           destination?.toEditDripVC = toDetailDripVC
       }
    }
    
    
}
