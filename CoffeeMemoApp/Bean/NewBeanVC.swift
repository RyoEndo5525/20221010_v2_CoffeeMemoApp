//
//  NewBeanVC.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/03/19.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import SVProgressHUD

class NewBeanVC: FormViewController {

    //ImageRowで選択された画像を格納する変数
    var selectedBeanImage = UIImage()
    var saveBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "コーヒー豆"
        tableView.backgroundColor = backgroundColor
        setLeftBarButton()
        
        setSegmentedSection()

        form
        +++ Section("コーヒー豆")
        setTextRow(tag: "beanTag_namae", title: "名前", ph: "プリセットの名前になります", value: nil)
        setTextRow(tag: "beanTag_hanbaiten", title: "販売店", ph: "", value: nil)
        setTextRow(tag: "beanTag_keisiki", title: "購入形式", ph: "豆 / 粉", value: nil)
        setIntRow(tag: "beanTag_kakaku", title: "価格", ph: "/ 100g", value: nil)
        setIntRow(tag: "beanTag_kounyuuryou", title: "購入量", ph: "g", value: nil)
        setTextRow(tag: "beanTag_kaori", title: "香り", ph: "", value: nil)
        setDateRow(tag: "beanTag_kounyuubi", title: "購入日", value: nil)
        setImageRow(tag: "beanTag_image1", savedImage: nil)
        (form.rowBy(tag: "beanTag_image1") as! ImageRow).onChange { [unowned self] row in
            //選択した画像を消してもエラーが出ないように
            if row.value != nil {
                selectedBeanImage = row.value!
                
            }
        }
        
         
        form
        +++ Section("シングル"){
            $0.tag = "single"
        }
        setTextRow(tag: "beanTag_seisannkoku_Single", title: "生産国", ph: "", value: nil)
        setTextRow(tag: "beanTag_tiiki_Single", title: "地域", ph: "", value: nil)
        setTextRow(tag: "beanTag_nouennmei_Single", title: "農園名", ph: "", value: nil)
        setTextRow(tag: "beanTag_seisannsya_Single", title: "生産者", ph: "", value: nil)
        setTextRow(tag: "beanTag_hinnsyu_Single", title: "品種", ph: "", value: nil)
        setIntRow(tag: "beanTag_hyoukou_Single", title: "標高", ph: "m", value: nil)
        setTextRow(tag: "beanTag_seiseihouhou_Single", title: "精製方法", ph: "", value: nil)
        setTextRow(tag: "beanTag_baisenndo_Single", title: "焙煎度", ph: "", value: nil)
        setDateRow(tag: "beanTag_baisenbi_Single", title: "焙煎日", value: nil)
        
        form
        +++ Section("ブレンド豆１"){
            $0.tag = "blend1"
        }
        setTextRow(tag: "beanTag_seisannkoku_Blend1", title: "生産国", ph: "", value: nil)
        setTextRow(tag: "beanTag_tiiki_Blend1", title: "地域", ph: "", value: nil)
        setTextRow(tag: "beanTag_nouennmei_Blend1", title: "農園名", ph: "", value: nil)
        setTextRow(tag: "beanTag_seisannsya_Blend1", title: "生産者", ph: "", value: nil)
        setTextRow(tag: "beanTag_hinnsyu_Blend1", title: "品種", ph: "", value: nil)
        setIntRow(tag: "beanTag_hyoukou_Blend1", title: "標高", ph: "m", value: nil)
        setTextRow(tag: "beanTag_seiseihouhou_Blend1", title: "精製方法", ph: "", value: nil)
        setTextRow(tag: "beanTag_baisenndo_Blend1", title: "焙煎度", ph: "", value: nil)
        setDateRow(tag: "beanTag_baisenbi_Blend1", title: "焙煎日", value: nil)
        setDecimalRow(tag: "beanTag_ryou_Blend1", title: "豆の量", ph: "/ 100g", value: nil)
        
        
        form
        +++ Section("ブレンド豆２"){
            $0.tag = "blend2"
        }
        setTextRow(tag: "beanTag_seisannkoku_Blend2", title: "生産国", ph: "", value: nil)
        setTextRow(tag: "beanTag_tiiki_Blend2", title: "地域", ph: "", value: nil)
        setTextRow(tag: "beanTag_nouennmei_Blend2", title: "農園名", ph: "", value: nil)
        setTextRow(tag: "beanTag_seisannsya_Blend2", title: "生産者", ph: "", value: nil)
        setTextRow(tag: "beanTag_hinnsyu_Blend2", title: "品種", ph: "", value: nil)
        setIntRow(tag: "beanTag_hyoukou_Blend2", title: "標高", ph: "m", value: nil)
        setTextRow(tag: "beanTag_seiseihouhou_Blend2", title: "精製方法", ph: "", value: nil)
        setTextRow(tag: "beanTag_baisenndo_Blend2", title: "焙煎度", ph: "", value: nil)
        setDateRow(tag: "beanTag_baisenbi_Blend2", title: "焙煎日", value: nil)
        setDecimalRow(tag: "beanTag_ryou_Blend2", title: "豆の量", ph: "/ 100g", value: nil)
        
        form
        +++ Section("ブレンド豆３"){
            $0.tag = "blend3"
        }
        setTextRow(tag: "beanTag_seisannkoku_Blend3", title: "生産国", ph: "", value: nil)
        setTextRow(tag: "beanTag_tiiki_Blend3", title: "地域", ph: "", value: nil)
        setTextRow(tag: "beanTag_nouennmei_Blend3", title: "農園名", ph: "", value: nil)
        setTextRow(tag: "beanTag_seisannsya_Blend3", title: "生産者", ph: "", value: nil)
        setTextRow(tag: "beanTag_hinnsyu_Blend3", title: "品種", ph: "", value: nil)
        setIntRow(tag: "beanTag_hyoukou_Blend3", title: "標高", ph: "m", value: nil)
        setTextRow(tag: "beanTag_seiseihouhou_Blend3", title: "精製方法", ph: "", value: nil)
        setTextRow(tag: "beanTag_baisenndo_Blend3", title: "焙煎度", ph: "", value: nil)
        setDateRow(tag: "beanTag_baisenbi_Blend3", title: "焙煎日", value: nil)
        setDecimalRow(tag: "beanTag_ryou_Blend3", title: "豆の量", ph: "/ 100g", value: nil)
        
        form
        +++ Section("ブレンド豆４"){
            $0.tag = "blend4"
        }
        setTextRow(tag: "beanTag_seisannkoku_Blend4", title: "生産国", ph: "", value: nil)
        setTextRow(tag: "beanTag_tiiki_Blend4", title: "地域", ph: "", value: nil)
        setTextRow(tag: "beanTag_nouennmei_Blend4", title: "農園名", ph: "", value: nil)
        setTextRow(tag: "beanTag_seisannsya_Blend4", title: "生産者", ph: "", value: nil)
        setTextRow(tag: "beanTag_hinnsyu_Blend4", title: "品種", ph: "", value: nil)
        setIntRow(tag: "beanTag_hyoukou_Blend4", title: "標高", ph: "m", value: nil)
        setTextRow(tag: "beanTag_seiseihouhou_Blend4", title: "精製方法", ph: "", value: nil)
        setTextRow(tag: "beanTag_baisenndo_Blend4", title: "焙煎度", ph: "", value: nil)
        setDateRow(tag: "beanTag_baisenbi_Blend4", title: "焙煎日", value: nil)
        setDecimalRow(tag: "beanTag_ryou_Blend4", title: "豆の量", ph: "/ 100g", value: nil)
        
        form
        +++ Section("メモ")
        setTextAreaRow(tag: "beanTag_memo", title: "メモ", ph: "", value: nil)

        //初期画面でブレンドを非表示にする、これ以降はonchangeで管理
        let section = [
            self.form.sectionBy(tag: "blend1"),
            self.form.sectionBy(tag: "blend2"),
            self.form.sectionBy(tag: "blend3"),
            self.form.sectionBy(tag: "blend4")
        ]
        section.forEach {
            $0?.hidden = true
            $0?.evaluateHidden()
        }
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
        if values["beanTag_namae"] as? String == nil {
            self.errorMessageName()

        } else {
            //インジケータの表示
            SVProgressHUD.show(withStatus: "保存中です")
            
            //イベントメソッドが終わらないと画面表示が更新されないので
            //メインスレッドでの処理だが、時差で仕込み　ひとまず画面更新をかける
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                autoreleasepool {
                //NSManagedObjectContextをAppDelegate経由でオブジェクト化
                //(UIApplication.shared.delegate as! AppDelegate)はAppDelegateへのパスのようなもの
                //AppDelegateのpersistentContainerのviewContext(NSManagedObjectContextのこと)を叩いてオブジェクト化してるだけ
                let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                //フィールドで作ったマネージドオブジェクトコンテキスト内にMemoData型のマネージドオブジェクトを作る
                let beanImages = BeanImage(context: managedObjectContext)
                let beanMemos = BeanMemo(context: managedObjectContext)
                
                //beanMemosオブジェクトの各アトリビュートプロパティに入力値を代入
                //画像
                let image1 = values["beanTag_image1"] as? UIImage
                if image1 != nil {
                    beanImages.beanTag_image1 = image1!.reSizeImage()!.pngData()
                }
                
                // 作成日の格納（現在日時を取得と配列への格納）
                let now = Date()
                let dateFormatter = DateFormatter()
                guard let formatString = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
                else { fatalError() }
                dateFormatter.dateFormat = formatString
                beanImages.beanCreatedDate = dateFormatter.string(from: now)
                beanMemos.beanCreatedDate = dateFormatter.string(from: now)
                beanMemos.beanEditedDate = dateFormatter.string(from: now)
                
                //ID関係の作成と登録
                let UUID = UUID().uuidString + dateFormatter.string(from: now)
                beanImages.beanId = UUID
                beanMemos.beanId = UUID
                    
                //並べ替え用　カタカナ変換
                let beanTag_namae = values["beanTag_namae"] as? String
                if beanTag_namae != nil {
                    beanMemos.beanTag_ForSortNamae = beanTag_namae!.convertKana()
                }
                    
                if values["beanTag_kakaku"] as? Int != nil {
                    beanMemos.beanTag_kakaku = (values["beanTag_kakaku"] as? Int)!.description
                }
                if values["beanTag_kounyuuryou"] as? Int != nil {
                    beanMemos.beanTag_kounyuuryou = (values["beanTag_kounyuuryou"] as? Int)!.description
                }
                if values["beanTag_hyoukou_Single"] as? Int != nil {
                    beanMemos.beanTag_hyoukou_Single = (values["beanTag_hyoukou_Single"] as? Int)!.description
                }
                if values["beanTag_hyoukou_Blend1"] as? Int != nil {
                    beanMemos.beanTag_hyoukou_Blend1 = (values["beanTag_hyoukou_Blend1"] as? Int)!.description
                }
                if values["beanTag_ryou_Blend1"] as? Double != nil {
                    beanMemos.beanTag_ryou_Blend1 = (values["beanTag_ryou_Blend1"] as? Double)!.description
                }
                if values["beanTag_hyoukou_Blend2"] as? Int != nil {
                    beanMemos.beanTag_hyoukou_Blend2 = (values["beanTag_hyoukou_Blend2"] as? Int)!.description
                }
                if values["beanTag_ryou_Blend2"] as? Double != nil {
                    beanMemos.beanTag_ryou_Blend2 = (values["beanTag_ryou_Blend2"] as? Double)!.description
                }
                if values["beanTag_hyoukou_Blend3"] as? Int != nil {
                    beanMemos.beanTag_hyoukou_Blend3 = (values["beanTag_hyoukou_Blend3"] as? Int)!.description
                }
                if values["beanTag_ryou_Blend3"] as? Double != nil {
                    beanMemos.beanTag_ryou_Blend3 = (values["beanTag_ryou_Blend3"] as? Double)!.description
                }
                if values["beanTag_hyoukou_Blend4"] as? Int != nil {
                    beanMemos.beanTag_hyoukou_Blend4 = (values["beanTag_hyoukou_Blend4"] as? Int)!.description
                }
                if values["beanTag_ryou_Blend4"] as? Double != nil {
                    beanMemos.beanTag_ryou_Blend4 = (values["beanTag_ryou_Blend4"] as? Double)!.description
                }

                //以下、入力値の反映
                beanMemos.beanTag_namae = values["beanTag_namae"] as? String
                beanMemos.beanTag_hanbaiten = values["beanTag_hanbaiten"] as? String
                beanMemos.beanTag_keisiki = values["beanTag_keisiki"] as? String
                beanMemos.beanTag_kaori = values["beanTag_kaori"] as? String
                
                beanMemos.beanTag_seisannkoku_Single = values["beanTag_seisannkoku_Single"] as? String
                beanMemos.beanTag_tiiki_Single = values["beanTag_tiiki_Single"] as? String
                beanMemos.beanTag_nouennmei_Single = values["beanTag_nouennmei_Single"] as? String
                beanMemos.beanTag_seisannsya_Single = values["beanTag_seisannsya_Single"] as? String
                beanMemos.beanTag_hinnsyu_Single = values["beanTag_hinnsyu_Single"] as? String
                beanMemos.beanTag_seiseihouhou_Single = values["beanTag_seiseihouhou_Single"] as? String
                beanMemos.beanTag_baisenndo_Single = values["beanTag_baisenndo_Single"] as? String
                
                beanMemos.beanTag_seisannkoku_Blend1 = values["beanTag_seisannkoku_Blend1"] as? String
                beanMemos.beanTag_tiiki_Blend1 = values["beanTag_tiiki_Blend1"] as? String
                beanMemos.beanTag_nouennmei_Blend1 = values["beanTag_nouennmei_Blend1"] as? String
                beanMemos.beanTag_seisannsya_Blend1 = values["beanTag_seisannsya_Blend1"] as? String
                beanMemos.beanTag_hinnsyu_Blend1 = values["beanTag_hinnsyu_Blend1"] as? String
                beanMemos.beanTag_seiseihouhou_Blend1 = values["beanTag_seiseihouhou_Blend1"] as? String
                beanMemos.beanTag_baisenndo_Blend1 = values["beanTag_baisenndo_Blend1"] as? String

                beanMemos.beanTag_seisannkoku_Blend2 = values["beanTag_seisannkoku_Blend2"] as? String
                beanMemos.beanTag_tiiki_Blend2 = values["beanTag_tiiki_Blend2"] as? String
                beanMemos.beanTag_nouennmei_Blend2 = values["beanTag_nouennmei_Blend2"] as? String
                beanMemos.beanTag_seisannsya_Blend2 = values["beanTag_seisannsya_Blend2"] as? String
                beanMemos.beanTag_hinnsyu_Blend2 = values["beanTag_hinnsyu_Blend2"] as? String
                beanMemos.beanTag_seiseihouhou_Blend2 = values["beanTag_seiseihouhou_Blend2"] as? String
                beanMemos.beanTag_baisenndo_Blend2 = values["beanTag_baisenndo_Blend2"] as? String

                beanMemos.beanTag_seisannkoku_Blend3 = values["beanTag_seisannkoku_Blend3"] as? String
                beanMemos.beanTag_tiiki_Blend3 = values["beanTag_tiiki_Blend3"] as? String
                beanMemos.beanTag_nouennmei_Blend3 = values["beanTag_nouennmei_Blend3"] as? String
                beanMemos.beanTag_seisannsya_Blend3 = values["beanTag_seisannsya_Blend3"] as? String
                beanMemos.beanTag_hinnsyu_Blend3 = values["beanTag_hinnsyu_Blend3"] as? String
                beanMemos.beanTag_seiseihouhou_Blend3 = values["beanTag_seiseihouhou_Blend3"] as? String
                beanMemos.beanTag_baisenndo_Blend3 = values["beanTag_baisenndo_Blend3"] as? String
                
                beanMemos.beanTag_seisannkoku_Blend4 = values["beanTag_seisannkoku_Blend4"] as? String
                beanMemos.beanTag_tiiki_Blend4 = values["beanTag_tiiki_Blend4"] as? String
                beanMemos.beanTag_nouennmei_Blend4 = values["beanTag_nouennmei_Blend4"] as? String
                beanMemos.beanTag_seisannsya_Blend4 = values["beanTag_seisannsya_Blend4"] as? String
                beanMemos.beanTag_hinnsyu_Blend4 = values["beanTag_hinnsyu_Blend4"] as? String
                beanMemos.beanTag_seiseihouhou_Blend4 = values["beanTag_seiseihouhou_Blend4"] as? String
                beanMemos.beanTag_baisenndo_Blend4 = values["beanTag_baisenndo_Blend4"] as? String

                //DateRowの情報
                beanMemos.beanTag_kounyuubi = values["beanTag_kounyuubi"] as? Date
                beanMemos.beanTag_baisenbi_Single = values["beanTag_baisenbi_Single"] as? Date
                beanMemos.beanTag_baisenbi_Blend1 = values["beanTag_baisenbi_Blend1"] as? Date
                beanMemos.beanTag_baisenbi_Blend2 = values["beanTag_baisenbi_Blend2"] as? Date
                beanMemos.beanTag_baisenbi_Blend3 = values["beanTag_baisenbi_Blend3"] as? Date
                beanMemos.beanTag_baisenbi_Blend4 = values["beanTag_baisenbi_Blend4"] as? Date
                //メモの情報
                beanMemos.beanTag_memo = values["beanTag_memo"] as? String
                //保存後の最表示のために、シングル・ブレンドのステータスを格納しておく
                beanMemos.beanStatus = values["segments"] as? String
                
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
    

}






