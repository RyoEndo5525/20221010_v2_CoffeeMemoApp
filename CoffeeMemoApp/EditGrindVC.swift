//
//  EditGrindVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import SVProgressHUD

class EditGrindVC: FormViewController {
    
    //prepare TableGrindVCからgrindIdの引き継ぎ
    var toEditGrindVC: String!
    //ImageRowで選択された画像を格納する変数
    var selectedGrindImage = UIImage()
    
    //CoreDataの入れ物を先に作っておく
    var grindMemos:[GrindMemo] = []
    var grindImages:[GrindImage] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreDataを取得して、配列へ格納
        grindMemos = getGrindMemoId(moc: managedObjectContext, grindId: toEditGrindVC)
        grindImages = getGrindImageId(moc: managedObjectContext, grindId: toEditGrindVC)

        navigationItem.title = "編集"
        tableView.backgroundColor = backgroundColor
        
        form
        +++ Section("挽き方")
        setTextRow(tag: "grindTag_namae", title: "名前", ph: "", value: grindMemos[0].grindTag_namae)
        setTextRow(tag: "grindTag_hikime", title: "挽き目", ph: "", value: grindMemos[0].grindTag_hikime)
        setTextRow(tag: "grindTag_miru", title: "ミルの種類", ph: "", value: grindMemos[0].grindTag_miru)
        setImageRow(tag: "grindTag_image1", savedImage: grindImages[0].grindImage1)
        (form.rowBy(tag: "grindTag_image1") as! ImageRow).onChange { [unowned self] row in
            //選択した画像を消してもエラーが出ないように
            if row.value != nil {
                selectedGrindImage = row.value!
            }
        }
        
        form
        +++ Section("メモ")
        setTextAreaRow(tag: "grindTag_memo", title: "メモ", ph: "", value: grindMemos[0].grindTag_memo)

    }

    //保存ボタンの処理
    @IBAction func saveButton(_ sender: Any) {
    //キーボードを閉じる
        view.endEditing(true)
        //フォームへの入力値をvalues（配列）へ格納
        let values = form.values()
        
        //名前を必須項目として、未入力の場合はエラー表示
        if values["grindTag_namae"] as? String == nil {
            self.errorMessageName()
            
        } else {
            //インジケータの表示
            SVProgressHUD.show(withStatus: "保存中です")
            
            //イベントメソッドが終わらないと画面表示が更新されないので
            //メインスレッドでの処理だが、時差で仕込み　ひとまず画面更新をかける
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //grindMemos[0]オブジェクトの各アトリビュートプロパティに入力値を代入
                //画像
                let image1 = values["grindTag_image1"] as? UIImage
                if image1 != nil {
                    self.grindImages[0].grindImage1 = image1!.reSizeImage()!.pngData()
                }else{
                    self.grindImages[0].grindImage1 = nil
                }
                
                //基本情報
                self.grindMemos[0].grindTag_namae = values["grindTag_namae"] as? String
                self.grindMemos[0].grindTag_hikime = values["grindTag_hikime"] as? String
                self.grindMemos[0].grindTag_miru = values["grindTag_miru"] as? String

                //メモの情報
                self.grindMemos[0].grindTag_memo = values["grindTag_memo"] as? String
                self.grindMemos[0].grindEditedDate = self.getNow()
                self.grindImages[0].grindEditedDate = self.getNow()
                
                //並べ替え用　カタカナ変換
                let grindTag_namae = values["grindTag_namae"] as? String
                if grindTag_namae != nil {
                    self.grindMemos[0].grindTag_ForSortNamae = grindTag_namae!.convertKana()
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
