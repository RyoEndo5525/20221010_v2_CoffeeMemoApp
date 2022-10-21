//
//  EditBeanVC.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/03/21.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import SVProgressHUD

class EditBeanVC: FormViewController {
    
    //prepare TableBeanVCからbeanIdの引き継ぎ
    var toEditBeanVC: String!
    //ImageRowで選択された画像を格納する変数
    var selectedBeanImage = UIImage()
    
    //CoreDataの入れ物を先に作っておく
    var beanImages:[BeanImage] = []
    var beanMemos:[BeanMemo] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //CoreDataを取得して、配列へ格納
        beanMemos = getBeanMemoId(moc: managedObjectContext, beanId: toEditBeanVC)
        beanImages = getBeanImageId(moc: managedObjectContext, beanId: toEditBeanVC)

        navigationItem.title = "編集"
        tableView.backgroundColor = backgroundColor
 
        var beanTag_kakaku: Int?
        if beanMemos[0].beanTag_kakaku != nil {
            beanTag_kakaku = Int(beanMemos[0].beanTag_kakaku!)
        }
        var beanTag_kounyuuryou: Int?
        if beanMemos[0].beanTag_kounyuuryou != nil {
            beanTag_kounyuuryou = Int(beanMemos[0].beanTag_kounyuuryou!)
        }
        var beanTag_hyoukou_Single: Int?
        if beanMemos[0].beanTag_hyoukou_Single != nil {
            beanTag_hyoukou_Single = Int(beanMemos[0].beanTag_hyoukou_Single!)
        }
        var beanTag_hyoukou_Blend1: Int?
        if beanMemos[0].beanTag_hyoukou_Blend1 != nil {
            beanTag_hyoukou_Blend1 = Int(beanMemos[0].beanTag_hyoukou_Blend1!)
        }
        var beanTag_hyoukou_Blend2: Int?
        if beanMemos[0].beanTag_hyoukou_Blend2 != nil {
            beanTag_hyoukou_Blend2 = Int(beanMemos[0].beanTag_hyoukou_Blend2!)
        }
        var beanTag_hyoukou_Blend3: Int?
        if beanMemos[0].beanTag_hyoukou_Blend3 != nil {
            beanTag_hyoukou_Blend3 = Int(beanMemos[0].beanTag_hyoukou_Blend3!)
        }
        var beanTag_hyoukou_Blend4: Int?
        if beanMemos[0].beanTag_hyoukou_Blend4 != nil {
            beanTag_hyoukou_Blend4 = Int(beanMemos[0].beanTag_hyoukou_Blend4!)
        }
        var beanTag_ryou_Blend1: Double?
        if beanMemos[0].beanTag_ryou_Blend1 != nil {
            beanTag_ryou_Blend1 = Double(beanMemos[0].beanTag_ryou_Blend1!)
        }
        var beanTag_ryou_Blend2: Double?
        if beanMemos[0].beanTag_ryou_Blend2 != nil {
            beanTag_ryou_Blend2 = Double(beanMemos[0].beanTag_ryou_Blend2!)
        }
        var beanTag_ryou_Blend3: Double?
        if beanMemos[0].beanTag_ryou_Blend3 != nil {
            beanTag_ryou_Blend3 = Double(beanMemos[0].beanTag_ryou_Blend3!)
        }
        var beanTag_ryou_Blend4: Double?
        if beanMemos[0].beanTag_ryou_Blend4 != nil {
            beanTag_ryou_Blend4 = Double(beanMemos[0].beanTag_ryou_Blend4!)
        }
        
        
        form
        +++ Section("コーヒー豆")
        setTextRow(tag: "beanStatus", title: "ステータス", ph: "", value: beanMemos[0].beanStatus)
        setTextRow(tag: "beanTag_namae", title: "名前", ph: "プリセットの名前になります", value: beanMemos[0].beanTag_namae)
        setTextRow(tag: "beanTag_hanbaiten", title: "販売店", ph: "", value: beanMemos[0].beanTag_hanbaiten)
        setTextRow(tag: "beanTag_keisiki", title: "購入形式", ph: "豆 / 粉", value: beanMemos[0].beanTag_keisiki)
        setIntRow(tag: "beanTag_kakaku", title: "価格", ph: "/ 100g", value: beanTag_kakaku)
        setIntRow(tag: "beanTag_kounyuuryou", title: "購入量", ph: "g", value: beanTag_kounyuuryou)
        setTextRow(tag: "beanTag_kaori", title: "香り", ph: "", value: beanMemos[0].beanTag_kaori)
        setDateRow(tag: "beanTag_kounyuubi", title: "購入日", value: beanMemos[0].beanTag_kounyuubi)
        setImageRow(tag: "beanTag_image1", savedImage: beanImages[0].beanTag_image1)
        
        if beanMemos[0].beanStatus == "シングル" {
            form
            +++ Section("シングル")
            setTextRow(tag: "beanTag_seisannkoku_Single", title: "生産国", ph: "", value: beanMemos[0].beanTag_seisannkoku_Single)
            setTextRow(tag: "beanTag_tiiki_Single", title: "地域", ph: "", value: beanMemos[0].beanTag_tiiki_Single)
            setTextRow(tag: "beanTag_nouennmei_Single", title: "農園名", ph: "", value: beanMemos[0].beanTag_nouennmei_Single)
            setTextRow(tag: "beanTag_seisannsya_Single", title: "生産者", ph: "", value: beanMemos[0].beanTag_seisannsya_Single)
            setTextRow(tag: "beanTag_hinnsyu_Single", title: "品種", ph: "", value: beanMemos[0].beanTag_hinnsyu_Single)
            setIntRow(tag: "beanTag_hyoukou_Single", title: "標高", ph: "m", value: beanTag_hyoukou_Single)
            setTextRow(tag: "beanTag_seiseihouhou_Single", title: "精製方法", ph: "", value: beanMemos[0].beanTag_seiseihouhou_Single)
            setTextRow(tag: "beanTag_baisenndo_Single", title: "焙煎度", ph: "", value: beanMemos[0].beanTag_baisenndo_Single)
            setDateRow(tag: "beanTag_baisenbi_Single", title: "焙煎日", value: beanMemos[0].beanTag_baisenbi_Single)
        }else{
            form
            +++ Section("ブレンド豆１")
            setTextRow(tag: "beanTag_seisannkoku_Blend1", title: "生産国", ph: "", value: beanMemos[0].beanTag_seisannkoku_Blend1)
            setTextRow(tag: "beanTag_tiiki_Blend1", title: "地域", ph: "", value: beanMemos[0].beanTag_tiiki_Blend1)
            setTextRow(tag: "beanTag_nouennmei_Blend1", title: "農園名", ph: "", value: beanMemos[0].beanTag_nouennmei_Blend1)
            setTextRow(tag: "beanTag_seisannsya_Blend1", title: "生産者", ph: "", value: beanMemos[0].beanTag_seisannsya_Blend1)
            setTextRow(tag: "beanTag_hinnsyu_Blend1", title: "品種", ph: "", value: beanMemos[0].beanTag_hinnsyu_Blend1)
            setIntRow(tag: "beanTag_hyoukou_Blend1", title: "標高", ph: "m", value: beanTag_hyoukou_Blend1)
            setTextRow(tag: "beanTag_seiseihouhou_Blend1", title: "精製方法", ph: "", value: beanMemos[0].beanTag_seiseihouhou_Blend1)
            setTextRow(tag: "beanTag_baisenndo_Blend1", title: "焙煎度", ph: "", value: beanMemos[0].beanTag_baisenndo_Blend1)
            setDateRow(tag: "beanTag_baisenbi_Blend1", title: "焙煎日", value: beanMemos[0].beanTag_baisenbi_Blend1)
            setDecimalRow(tag: "beanTag_ryou_Blend1", title: "豆の量", ph: "/ 100g", value: beanTag_ryou_Blend1)
            
            form
            +++ Section("ブレンド豆２")
            setTextRow(tag: "beanTag_seisannkoku_Blend2", title: "生産国", ph: "", value: beanMemos[0].beanTag_seisannkoku_Blend2)
            setTextRow(tag: "beanTag_tiiki_Blend2", title: "地域", ph: "", value: beanMemos[0].beanTag_tiiki_Blend2)
            setTextRow(tag: "beanTag_nouennmei_Blend2", title: "農園名", ph: "", value: beanMemos[0].beanTag_nouennmei_Blend2)
            setTextRow(tag: "beanTag_seisannsya_Blend2", title: "生産者", ph: "", value: beanMemos[0].beanTag_seisannsya_Blend2)
            setTextRow(tag: "beanTag_hinnsyu_Blend2", title: "品種", ph: "", value: beanMemos[0].beanTag_hinnsyu_Blend2)
            setIntRow(tag: "beanTag_hyoukou_Blend2", title: "標高", ph: "m", value: beanTag_hyoukou_Blend2)
            setTextRow(tag: "beanTag_seiseihouhou_Blend2", title: "精製方法", ph: "", value: beanMemos[0].beanTag_seiseihouhou_Blend2)
            setTextRow(tag: "beanTag_baisenndo_Blend2", title: "焙煎度", ph: "", value: beanMemos[0].beanTag_baisenndo_Blend2)
            setDateRow(tag: "beanTag_baisenbi_Blend2", title: "焙煎日", value: beanMemos[0].beanTag_baisenbi_Blend2)
            setDecimalRow(tag: "beanTag_ryou_Blend2", title: "豆の量", ph: "/ 100g", value: beanTag_ryou_Blend2)
            
            form
            +++ Section("ブレンド豆３")
            setTextRow(tag: "beanTag_seisannkoku_Blend3", title: "生産国", ph: "", value: beanMemos[0].beanTag_seisannkoku_Blend3)
            setTextRow(tag: "beanTag_tiiki_Blend3", title: "地域", ph: "", value: beanMemos[0].beanTag_tiiki_Blend3)
            setTextRow(tag: "beanTag_nouennmei_Blend3", title: "農園名", ph: "", value: beanMemos[0].beanTag_nouennmei_Blend3)
            setTextRow(tag: "beanTag_seisannsya_Blend3", title: "生産者", ph: "", value: beanMemos[0].beanTag_seisannsya_Blend3)
            setTextRow(tag: "beanTag_hinnsyu_Blend3", title: "品種", ph: "", value: beanMemos[0].beanTag_hinnsyu_Blend3)
            setIntRow(tag: "beanTag_hyoukou_Blend3", title: "標高", ph: "m", value: beanTag_hyoukou_Blend3)
            setTextRow(tag: "beanTag_seiseihouhou_Blend3", title: "精製方法", ph: "", value: beanMemos[0].beanTag_seiseihouhou_Blend3)
            setTextRow(tag: "beanTag_baisenndo_Blend3", title: "焙煎度", ph: "", value: beanMemos[0].beanTag_baisenndo_Blend3)
            setDateRow(tag: "beanTag_baisenbi_Blend3", title: "焙煎日", value: beanMemos[0].beanTag_baisenbi_Blend3)
            setDecimalRow(tag: "beanTag_ryou_Blend3", title: "豆の量", ph: "/ 100g", value: beanTag_ryou_Blend3)
            
            form
            +++ Section("ブレンド豆４")
            setTextRow(tag: "beanTag_seisannkoku_Blend4", title: "生産国", ph: "", value: beanMemos[0].beanTag_seisannkoku_Blend4)
            setTextRow(tag: "beanTag_tiiki_Blend4", title: "地域", ph: "", value: beanMemos[0].beanTag_tiiki_Blend4)
            setTextRow(tag: "beanTag_nouennmei_Blend4", title: "農園名", ph: "", value: beanMemos[0].beanTag_nouennmei_Blend4)
            setTextRow(tag: "beanTag_seisannsya_Blend4", title: "生産者", ph: "", value: beanMemos[0].beanTag_seisannsya_Blend4)
            setTextRow(tag: "beanTag_hinnsyu_Blend4", title: "品種", ph: "", value: beanMemos[0].beanTag_hinnsyu_Blend4)
            setIntRow(tag: "beanTag_hyoukou_Blend4", title: "標高", ph: "m", value: beanTag_hyoukou_Blend4)
            setTextRow(tag: "beanTag_seiseihouhou_Blend4", title: "精製方法", ph: "", value: beanMemos[0].beanTag_seiseihouhou_Blend4)
            setTextRow(tag: "beanTag_baisenndo_Blend4", title: "焙煎度", ph: "", value: beanMemos[0].beanTag_baisenndo_Blend4)
            setDateRow(tag: "beanTag_baisenbi_Blend4", title: "焙煎日", value: beanMemos[0].beanTag_baisenbi_Blend4)
            setDecimalRow(tag: "beanTag_ryou_Blend4", title: "豆の量", ph: "/ 100g", value: beanTag_ryou_Blend4)
        }
        
        form
        +++ Section("メモ")
        setTextAreaRow(tag: "beanTag_memo", title: "メモ", ph: "", value: beanMemos[0].beanTag_memo)

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
                //beanMemos[0]オブジェクトの各アトリビュートプロパティに入力値を代入
                //画像
                let image1 = values["beanTag_image1"] as? UIImage
                if image1 != nil {
                    self.beanImages[0].beanTag_image1 = image1!.reSizeImage()!.pngData()
                }else{
                    self.beanImages[0].beanTag_image1 = nil
                }
                
                if values["beanTag_kakaku"] as? Int != nil {
                    self.beanMemos[0].beanTag_kakaku = (values["beanTag_kakaku"] as? Int)!.description
                }else{
                    self.beanMemos[0].beanTag_kakaku = nil
                }
                if values["beanTag_kounyuuryou"] as? Int != nil {
                    self.beanMemos[0].beanTag_kounyuuryou = (values["beanTag_kounyuuryou"] as? Int)!.description
                }else{
                    self.beanMemos[0].beanTag_kounyuuryou = nil
                }
                if values["beanTag_hyoukou_Single"] as? Int != nil {
                    self.beanMemos[0].beanTag_hyoukou_Single = (values["beanTag_hyoukou_Single"] as? Int)!.description
                }else{
                    self.beanMemos[0].beanTag_hyoukou_Single = nil
                }
                if values["beanTag_hyoukou_Blend1"] as? Int != nil {
                    self.beanMemos[0].beanTag_hyoukou_Blend1 = (values["beanTag_hyoukou_Blend1"] as? Int)!.description
                }else{
                    self.beanMemos[0].beanTag_hyoukou_Blend1 = nil
                }
                if values["beanTag_ryou_Blend1"] as? Double != nil {
                    self.beanMemos[0].beanTag_ryou_Blend1 = (values["beanTag_ryou_Blend1"] as? Double)!.description
                }else{
                    self.beanMemos[0].beanTag_ryou_Blend1 = nil
                }
                if values["beanTag_hyoukou_Blend2"] as? Int != nil {
                    self.beanMemos[0].beanTag_hyoukou_Blend2 = (values["beanTag_hyoukou_Blend2"] as? Int)!.description
                }else{
                    self.beanMemos[0].beanTag_hyoukou_Blend2 = nil
                }
                if values["beanTag_ryou_Blend2"] as? Double != nil {
                    self.beanMemos[0].beanTag_ryou_Blend2 = (values["beanTag_ryou_Blend2"] as? Double)!.description
                }else{
                    self.beanMemos[0].beanTag_ryou_Blend2 = nil
                }
                if values["beanTag_hyoukou_Blend3"] as? Int != nil {
                    self.beanMemos[0].beanTag_hyoukou_Blend3 = (values["beanTag_hyoukou_Blend3"] as? Int)!.description
                }else{
                    self.beanMemos[0].beanTag_hyoukou_Blend3 = nil
                }
                if values["beanTag_ryou_Blend3"] as? Double != nil {
                    self.beanMemos[0].beanTag_ryou_Blend3 = (values["beanTag_ryou_Blend3"] as? Double)!.description
                }else{
                    self.beanMemos[0].beanTag_ryou_Blend3 = nil
                }
                if values["beanTag_hyoukou_Blend4"] as? Int != nil {
                    self.beanMemos[0].beanTag_ryou_Blend3 = (values["beanTag_hyoukou_Blend4"] as? Int)!.description
                }else{
                    self.beanMemos[0].beanTag_ryou_Blend3 = nil
                }
                if values["beanTag_ryou_Blend4"] as? Double != nil {
                    self.beanMemos[0].beanTag_ryou_Blend4 = (values["beanTag_ryou_Blend4"] as? Double)!.description
                }else{
                    self.beanMemos[0].beanTag_ryou_Blend4 = nil
                }
                
                
                
                //基本情報
                self.beanMemos[0].beanTag_namae = values["beanTag_namae"] as? String
                self.beanMemos[0].beanTag_hanbaiten = values["beanTag_hanbaiten"] as? String
                self.beanMemos[0].beanTag_keisiki = values["beanTag_keisiki"] as? String
                self.beanMemos[0].beanTag_kaori = values["beanTag_kaori"] as? String
                
                self.beanMemos[0].beanTag_seisannkoku_Single = values["beanTag_seisannkoku_Single"] as? String
                self.beanMemos[0].beanTag_tiiki_Single = values["beanTag_tiiki_Single"] as? String
                self.beanMemos[0].beanTag_nouennmei_Single = values["beanTag_nouennmei_Single"] as? String
                self.beanMemos[0].beanTag_seisannsya_Single = values["beanTag_seisannsya_Single"] as? String
                self.beanMemos[0].beanTag_hinnsyu_Single = values["beanTag_hinnsyu_Single"] as? String
                self.beanMemos[0].beanTag_seiseihouhou_Single = values["beanTag_seiseihouhou_Single"] as? String
                self.beanMemos[0].beanTag_baisenndo_Single = values["beanTag_baisenndo_Single"] as? String
                
                self.beanMemos[0].beanTag_seisannkoku_Blend1 = values["beanTag_seisannkoku_Blend1"] as? String
                self.beanMemos[0].beanTag_tiiki_Blend1 = values["beanTag_tiiki_Blend1"] as? String
                self.beanMemos[0].beanTag_nouennmei_Blend1 = values["beanTag_nouennmei_Blend1"] as? String
                self.beanMemos[0].beanTag_seisannsya_Blend1 = values["beanTag_seisannsya_Blend1"] as? String
                self.beanMemos[0].beanTag_hinnsyu_Blend1 = values["beanTag_hinnsyu_Blend1"] as? String
                self.beanMemos[0].beanTag_seiseihouhou_Blend1 = values["beanTag_seiseihouhou_Blend1"] as? String
                self.beanMemos[0].beanTag_baisenndo_Blend1 = values["beanTag_baisenndo_Blend1"] as? String

                self.beanMemos[0].beanTag_seisannkoku_Blend2 = values["beanTag_seisannkoku_Blend2"] as? String
                self.beanMemos[0].beanTag_tiiki_Blend2 = values["beanTag_tiiki_Blend2"] as? String
                self.beanMemos[0].beanTag_nouennmei_Blend2 = values["beanTag_nouennmei_Blend2"] as? String
                self.beanMemos[0].beanTag_seisannsya_Blend2 = values["beanTag_seisannsya_Blend2"] as? String
                self.beanMemos[0].beanTag_hinnsyu_Blend2 = values["beanTag_hinnsyu_Blend2"] as? String
                self.beanMemos[0].beanTag_seiseihouhou_Blend2 = values["beanTag_seiseihouhou_Blend2"] as? String
                self.beanMemos[0].beanTag_baisenndo_Blend2 = values["beanTag_baisenndo_Blend2"] as? String
                
                self.beanMemos[0].beanTag_seisannkoku_Blend3 = values["beanTag_seisannkoku_Blend3"] as? String
                self.beanMemos[0].beanTag_tiiki_Blend3 = values["beanTag_tiiki_Blend3"] as? String
                self.beanMemos[0].beanTag_nouennmei_Blend3 = values["beanTag_nouennmei_Blend3"] as? String
                self.beanMemos[0].beanTag_seisannsya_Blend3 = values["beanTag_seisannsya_Blend3"] as? String
                self.beanMemos[0].beanTag_hinnsyu_Blend3 = values["beanTag_hinnsyu_Blend3"] as? String
                self.beanMemos[0].beanTag_seiseihouhou_Blend3 = values["beanTag_seiseihouhou_Blend3"] as? String
                self.beanMemos[0].beanTag_baisenndo_Blend3 = values["beanTag_baisenndo_Blend3"] as? String
                
                self.beanMemos[0].beanTag_seisannkoku_Blend4 = values["beanTag_seisannkoku_Blend4"] as? String
                self.beanMemos[0].beanTag_tiiki_Blend4 = values["beanTag_tiiki_Blend4"] as? String
                self.beanMemos[0].beanTag_nouennmei_Blend4 = values["beanTag_nouennmei_Blend4"] as? String
                self.beanMemos[0].beanTag_seisannsya_Blend4 = values["beanTag_seisannsya_Blend4"] as? String
                self.beanMemos[0].beanTag_hinnsyu_Blend4 = values["beanTag_hinnsyu_Blend4"] as? String
                self.beanMemos[0].beanTag_seiseihouhou_Blend4 = values["beanTag_seiseihouhou_Blend4"] as? String
                self.beanMemos[0].beanTag_baisenndo_Blend4 = values["beanTag_baisenndo_Blend4"] as? String

                //DateRowの情報
                self.beanMemos[0].beanTag_kounyuubi = values["beanTag_kounyuubi"] as? Date
                self.beanMemos[0].beanTag_baisenbi_Single = values["beanTag_baisenbi_Single"] as? Date
                self.beanMemos[0].beanTag_baisenbi_Blend1 = values["beanTag_baisenbi_Blend1"] as? Date
                self.beanMemos[0].beanTag_baisenbi_Blend2 = values["beanTag_baisenbi_Blend2"] as? Date
                self.beanMemos[0].beanTag_baisenbi_Blend3 = values["beanTag_baisenbi_Blend3"] as? Date
                self.beanMemos[0].beanTag_baisenbi_Blend4 = values["beanTag_baisenbi_Blend4"] as? Date
                //メモの情報
                self.beanMemos[0].beanTag_memo = values["beanTag_memo"] as? String
                self.beanMemos[0].beanEditedDate = self.getNow()
                self.beanImages[0].beanEditedDate = self.getNow()
                
                //並べ替え用　カタカナ変換
                let beanTag_namae = values["beanTag_namae"] as? String
                if beanTag_namae != nil {
                    self.beanMemos[0].beanTag_ForSortNamae = beanTag_namae!.convertKana()
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
