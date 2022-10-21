//
//  NewGrindVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import SVProgressHUD
import Eureka
import ImageRow

class NewGrindVC: FormViewController {
    
    //ImageRowで選択された画像を格納する変数
    var selectedGrindImage = UIImage()
    var saveBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "挽き方"
        tableView.backgroundColor = backgroundColor
        setLeftBarButton()
        
        form
        +++ Section("挽き方")
        setTextRow(tag: "grindTag_namae", title: "名前", ph: "", value: nil)
        setTextRow(tag: "grindTag_hikime", title: "挽き目", ph: "", value: nil)
        setTextRow(tag: "grindTag_miru", title: "ミルの種類", ph: "", value: nil)
        setImageRow(tag: "grindTag_image1", savedImage: nil)
        (form.rowBy(tag: "grindTag_image1") as! ImageRow).onChange { [unowned self] row in
            //選択した画像を消してもエラーが出ないように
            if row.value != nil {
                selectedGrindImage = row.value!
            }
        }
        
        form
        +++ Section("メモ")
        setTextAreaRow(tag: "grindTag_memo", title: "メモ", ph: "", value: nil)
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
        if values["grindTag_namae"] as? String == nil {
            self.errorMessageName()

        } else {
            //インジケータの表示
            SVProgressHUD.show(withStatus: "保存中です")
            
            //イベントメソッドが終わらないと画面表示が更新されないので
            //メインスレッドでの処理だが、時差で仕込み　ひとまず画面更新をかける
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let grindImages = GrindImage(context: managedObjectContext)
                let grindMemos = GrindMemo(context: managedObjectContext)
                
                //grindMemosオブジェクトの各アトリビュートプロパティに入力値を代入
                //画像
                let image1 = values["grindTag_image1"] as? UIImage
                if image1 != nil {
                    grindImages.grindImage1 = image1!.reSizeImage()!.pngData()
                }
            
                // 作成日の格納（現在日時を取得と配列への格納）
                let now = Date()
                let dateFormatter = DateFormatter()
                guard let formatString = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
                else { fatalError() }
                dateFormatter.dateFormat = formatString
                grindImages.grindCreatedDate = dateFormatter.string(from: now)
                grindMemos.grindCreatedDate = dateFormatter.string(from: now)
                grindMemos.grindEditedDate = dateFormatter.string(from: now)
                
                //ID関係の作成と登録
                let UUID = UUID().uuidString + dateFormatter.string(from: now)
                grindImages.grindId = UUID
                grindMemos.grindId = UUID
                
                //並べ替え用　カタカナ変換
                let grindTag_namae = values["grindTag_namae"] as? String
                if grindTag_namae != nil {
                    grindMemos.grindTag_ForSortNamae = grindTag_namae!.convertKana()
                }
                
                //以下、入力値の反映
                grindMemos.grindTag_namae = values["grindTag_namae"] as? String
                grindMemos.grindTag_hikime = values["grindTag_hikime"] as? String
                grindMemos.grindTag_miru = values["grindTag_miru"] as? String

                //メモの情報
                grindMemos.grindTag_memo = values["grindTag_memo"] as? String

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
