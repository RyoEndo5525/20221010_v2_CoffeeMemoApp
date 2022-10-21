//
//  DetailGrindVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import ViewRow

class DetailGrindVC: FormViewController {

    //prepare TableGrindVCからgrindIdの引き継ぎ
    var toDetailGrindVC: String!
    
    //CoreDataの入れ物を先に作っておく
    var grindImages:[GrindImage] = []
    var grindMemos:[GrindMemo] = []
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        //CoreDataを取得して、配列へ格納
        grindMemos = getGrindMemoId(moc: managedObjectContext, grindId: toDetailGrindVC)
        grindImages = getGrindImageId(moc: managedObjectContext, grindId: toDetailGrindVC)
        
        navigationItem.title = grindMemos[0].grindTag_namae
        tableView.backgroundColor = backgroundColor
        
        form
        +++ Section("挽き目")
        setLabelRow(tag: "grindCreatedDate", title: "作成日", value: grindMemos[0].grindCreatedDate)
        setLabelRow(tag: "grindEditedDate", title: "変更日", value: grindMemos[0].grindEditedDate)
        setLabelRow(tag: "grindTag_namae", title: "名前", value: grindMemos[0].grindTag_namae)
        setLabelRow(tag: "grindTag_hikime", title: "挽き目", value: grindMemos[0].grindTag_hikime)
        setLabelRow(tag: "grindTag_miru", title: "ミルの種類", value: grindMemos[0].grindTag_miru)

        form
        +++ Section("メモ")
        setTextAreaRow(tag: "grindTag_memo", title: "メモ", ph: "", value: grindMemos[0].grindTag_memo)
        (form.rowBy(tag: "grindTag_memo") as! TextAreaRow).textAreaMode = TextAreaMode.readOnly
        
        if grindImages[0].grindImage1 != nil {
            form
            +++ Section("画像")
            setViewRow(savedImage: grindImages[0].grindImage1)
        }
    }
    
    //editVCへIDを送る
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "editSegue" {
            let destination = segue.destination as? EditGrindVC
           destination?.toEditGrindVC = toDetailGrindVC
       }
    }
    

}
