//
//  EditReviewVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import SVProgressHUD


class EditReviewVC: FormViewController {
    //prepare TableBeanVCからbeanIdの引き継ぎ
    var toEditReviewVC: String!
    //ImageRowで選択された画像を格納する変数
    var selectedBeanImage = UIImage()
    var selectedGrindImage = UIImage()
    var selectedReviewImage = UIImage()
    //CoreDataの入れ物を先に作っておく
    var reviewImages:[ReviewImage] = []
    var reviewMemos:[ReviewMemo] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreDataを取得して、配列へ格納
        reviewMemos = getReviewMemoId(moc: managedObjectContext, reviewId: toEditReviewVC)
        reviewImages = getReviewImageId(moc: managedObjectContext, reviewId: toEditReviewVC)
        
        navigationItem.title = "編集"
        tableView.backgroundColor = backgroundColor
        
        var reviewTag_konaryou: Double?
        if reviewMemos[0].reviewTag_konaryou != nil {
            reviewTag_konaryou = Double(reviewMemos[0].reviewTag_konaryou!)
        }

        
        
        form
        +++ Section("レビュー")
        setTextRow(tag: "reviewTag_namae", title: "名前", ph: "", value: reviewMemos[0].reviewTag_namae)
        setDecimalRow(tag: "reviewTag_konaryou", title: "粉の量", ph: "g", value: reviewTag_konaryou)
        setIntRow(tag: "reviewTag_hyouka", title: "評価", ph: "", value: Int(reviewMemos[0].reviewTag_hyouka))
        setImageRow(tag: "reviewTag_image1", savedImage: reviewImages[0].reviewTag_image1)
        (form.rowBy(tag: "reviewTag_image1") as! ImageRow).onChange { [unowned self] row in
            //選択した画像を消してもエラーが出ないように
            if row.value != nil {
                selectedReviewImage = row.value!
            }
        }
        setTextAreaRow(tag: "reviewTag_memo", title: "メモ", ph: "メモ", value: reviewMemos[0].reviewTag_memo)
        
        form
        +++ Section("コーヒー豆")
        form.last! <<< SwitchRow { row in
            row.tag = "beanSwitchRow"
            row.title = "コーヒー豆　プリセット ▼ "
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }
            .onChange { row in
                let commonSection = [
                    self.form.sectionBy(tag: "common_bean"),
                    self.form.sectionBy(tag: "memo_bean")
                ]
                let singleSection = [
                    self.form.sectionBy(tag: "single")
                ]
                let blendSection = [
                    self.form.sectionBy(tag: "blend1"),
                    self.form.sectionBy(tag: "blend2"),
                    self.form.sectionBy(tag: "blend3"),
                    self.form.sectionBy(tag: "blend4")
                ]
                //スイッチ　オンの場合の処理
                if row.value! {
                    //シングル・ブレンドの条件分岐
                    if self.reviewMemos[0].beanStatus == "シングル" {
                        commonSection.forEach {
                            $0?.hidden = false
                            $0?.evaluateHidden()
                        }
                        singleSection.forEach {
                            $0?.hidden = false
                            $0?.evaluateHidden()
                        }
                        blendSection.forEach {
                            $0?.hidden = true
                            $0?.evaluateHidden()
                        }

                    }else{
                        commonSection.forEach {
                            $0?.hidden = false
                            $0?.evaluateHidden()
                        }
                        singleSection.forEach {
                            $0?.hidden = true
                            $0?.evaluateHidden()
                        }
                        blendSection.forEach {
                            $0?.hidden = false
                            $0?.evaluateHidden()
                        }

                    }
                //スイッチ　オフの場合の処理
                }else{
                    commonSection.forEach {
                        $0?.hidden = true
                        $0?.evaluateHidden()
                    }
                    singleSection.forEach {
                        $0?.hidden = true
                        $0?.evaluateHidden()
                    }
                    blendSection.forEach {
                        $0?.hidden = true
                        $0?.evaluateHidden()
                    }
                    
                }
        }
        
        var beanTag_kakaku: Int?
        if reviewMemos[0].beanTag_kakaku != nil {
            beanTag_kakaku = Int(reviewMemos[0].beanTag_kakaku!)
        }
        var beanTag_kounyuuryou: Int?
        if reviewMemos[0].beanTag_kounyuuryou != nil {
            beanTag_kounyuuryou = Int(reviewMemos[0].beanTag_kounyuuryou!)
        }
        var beanTag_hyoukou_Single: Int?
        if reviewMemos[0].beanTag_hyoukou_Single != nil {
            beanTag_hyoukou_Single = Int(reviewMemos[0].beanTag_hyoukou_Single!)
        }
        var beanTag_hyoukou_Blend1: Int?
        if reviewMemos[0].beanTag_hyoukou_Blend1 != nil {
            beanTag_hyoukou_Blend1 = Int(reviewMemos[0].beanTag_hyoukou_Blend1!)
        }
        var beanTag_hyoukou_Blend2: Int?
        if reviewMemos[0].beanTag_hyoukou_Blend2 != nil {
            beanTag_hyoukou_Blend2 = Int(reviewMemos[0].beanTag_hyoukou_Blend2!)
        }
        var beanTag_hyoukou_Blend3: Int?
        if reviewMemos[0].beanTag_hyoukou_Blend3 != nil {
            beanTag_hyoukou_Blend3 = Int(reviewMemos[0].beanTag_hyoukou_Blend3!)
        }
        var beanTag_hyoukou_Blend4: Int?
        if reviewMemos[0].beanTag_hyoukou_Blend4 != nil {
            beanTag_hyoukou_Blend4 = Int(reviewMemos[0].beanTag_hyoukou_Blend4!)
        }
        var beanTag_ryou_Blend1: Double?
        if reviewMemos[0].beanTag_ryou_Blend1 != nil {
            beanTag_ryou_Blend1 = Double(reviewMemos[0].beanTag_ryou_Blend1!)
        }
        var beanTag_ryou_Blend2: Double?
        if reviewMemos[0].beanTag_ryou_Blend2 != nil {
            beanTag_ryou_Blend2 = Double(reviewMemos[0].beanTag_ryou_Blend2!)
        }
        var beanTag_ryou_Blend3: Double?
        if reviewMemos[0].beanTag_ryou_Blend3 != nil {
            beanTag_ryou_Blend3 = Double(reviewMemos[0].beanTag_ryou_Blend3!)
        }
        var beanTag_ryou_Blend4: Double?
        if reviewMemos[0].beanTag_ryou_Blend4 != nil {
            beanTag_ryou_Blend4 = Double(reviewMemos[0].beanTag_ryou_Blend4!)
        }
        
        form
        +++ Section("コーヒー豆"){
            $0.tag = "common_bean"
        }
        setTextRow(tag: "beanStatus", title: "ステータス", ph: "", value: reviewMemos[0].beanStatus)
        setTextRow(tag: "beanTag_namae", title: "名前", ph: "プリセットの名前になります", value: reviewMemos[0].beanTag_namae)
        setTextRow(tag: "beanTag_hanbaiten", title: "販売店", ph: "", value: reviewMemos[0].beanTag_hanbaiten)
        setTextRow(tag: "beanTag_keisiki", title: "購入形式", ph: "豆 / 粉", value: reviewMemos[0].beanTag_keisiki)
        setIntRow(tag: "beanTag_kakaku", title: "価格", ph: "/ 100g", value: beanTag_kakaku)
        setIntRow(tag: "beanTag_kounyuuryou", title: "購入量", ph: "g", value: beanTag_kounyuuryou)
        setTextRow(tag: "beanTag_kaori", title: "香り", ph: "", value: reviewMemos[0].beanTag_kaori)
        setDateRow(tag: "beanTag_kounyuubi", title: "購入日", value: reviewMemos[0].beanTag_kounyuubi)
        setImageRow(tag: "beanTag_image1", savedImage: reviewImages[0].beanTag_image1)
        (form.rowBy(tag: "beanTag_image1") as! ImageRow).onChange { [unowned self] row in
            //選択した画像を消してもエラーが出ないように
            if row.value != nil {
                selectedBeanImage = row.value!
            }
        }
         
        if reviewMemos[0].beanStatus == "シングル" {
            
            form
            +++ Section("シングル"){
                $0.tag = "single"
            }
            setTextRow(tag: "beanTag_seisannkoku_Single", title: "生産国", ph: "", value: reviewMemos[0].beanTag_seisannkoku_Single)
            setTextRow(tag: "beanTag_tiiki_Single", title: "地域", ph: "", value: reviewMemos[0].beanTag_tiiki_Single)
            setTextRow(tag: "beanTag_nouennmei_Single", title: "農園名", ph: "", value: reviewMemos[0].beanTag_nouennmei_Single)
            setTextRow(tag: "beanTag_seisannsya_Single", title: "生産者", ph: "", value: reviewMemos[0].beanTag_seisannsya_Single)
            setTextRow(tag: "beanTag_hinnsyu_Single", title: "品種", ph: "", value: reviewMemos[0].beanTag_hinnsyu_Single)
            setIntRow(tag: "beanTag_hyoukou_Single", title: "標高", ph: "m", value: beanTag_hyoukou_Single)
            setTextRow(tag: "beanTag_seiseihouhou_Single", title: "精製方法", ph: "", value: reviewMemos[0].beanTag_seiseihouhou_Single)
            setTextRow(tag: "beanTag_baisenndo_Single", title: "焙煎度", ph: "", value: reviewMemos[0].beanTag_baisenndo_Single)
            setDateRow(tag: "beanTag_baisenbi_Single", title: "焙煎日", value: reviewMemos[0].beanTag_baisenbi_Single)
        
        }else{
                
            form
            +++ Section("ブレンド豆１"){
                $0.tag = "blend1"
            }
            setTextRow(tag: "beanTag_seisannkoku_Blend1", title: "生産国", ph: "", value: reviewMemos[0].beanTag_seisannkoku_Blend1)
            setTextRow(tag: "beanTag_tiiki_Blend1", title: "地域", ph: "", value: reviewMemos[0].beanTag_tiiki_Blend1)
            setTextRow(tag: "beanTag_nouennmei_Blend1", title: "農園名", ph: "", value: reviewMemos[0].beanTag_nouennmei_Blend1)
            setTextRow(tag: "beanTag_seisannsya_Blend1", title: "生産者", ph: "", value: reviewMemos[0].beanTag_seisannsya_Blend1)
            setTextRow(tag: "beanTag_hinnsyu_Blend1", title: "品種", ph: "", value: reviewMemos[0].beanTag_hinnsyu_Blend1)
            setIntRow(tag: "beanTag_hyoukou_Blend1", title: "標高", ph: "m", value: beanTag_hyoukou_Blend1)
            setTextRow(tag: "beanTag_seiseihouhou_Blend1", title: "精製方法", ph: "", value: reviewMemos[0].beanTag_seiseihouhou_Blend1)
            setTextRow(tag: "beanTag_baisenndo_Blend1", title: "焙煎度", ph: "", value: reviewMemos[0].beanTag_baisenndo_Blend1)
            setDateRow(tag: "beanTag_baisenbi_Blend1", title: "焙煎日", value: reviewMemos[0].beanTag_baisenbi_Blend1)
            setDecimalRow(tag: "beanTag_ryou_Blend1", title: "豆の量", ph: "/ 100g", value: beanTag_ryou_Blend1)
            
            
            form
            +++ Section("ブレンド豆２"){
                $0.tag = "blend2"
            }
            setTextRow(tag: "beanTag_seisannkoku_Blend2", title: "生産国", ph: "", value: reviewMemos[0].beanTag_seisannkoku_Blend2)
            setTextRow(tag: "beanTag_tiiki_Blend2", title: "地域", ph: "", value: reviewMemos[0].beanTag_tiiki_Blend2)
            setTextRow(tag: "beanTag_nouennmei_Blend2", title: "農園名", ph: "", value: reviewMemos[0].beanTag_nouennmei_Blend2)
            setTextRow(tag: "beanTag_seisannsya_Blend2", title: "生産者", ph: "", value: reviewMemos[0].beanTag_seisannsya_Blend2)
            setTextRow(tag: "beanTag_hinnsyu_Blend2", title: "品種", ph: "", value: reviewMemos[0].beanTag_hinnsyu_Blend2)
            setIntRow(tag: "beanTag_hyoukou_Blend2", title: "標高", ph: "m", value: beanTag_hyoukou_Blend2)
            setTextRow(tag: "beanTag_seiseihouhou_Blend2", title: "精製方法", ph: "", value: reviewMemos[0].beanTag_seiseihouhou_Blend2)
            setTextRow(tag: "beanTag_baisenndo_Blend2", title: "焙煎度", ph: "", value: reviewMemos[0].beanTag_baisenndo_Blend2)
            setDateRow(tag: "beanTag_baisenbi_Blend2", title: "焙煎日", value: reviewMemos[0].beanTag_baisenbi_Blend2)
            setDecimalRow(tag: "beanTag_ryou_Blend2", title: "豆の量", ph: "/ 100g", value: beanTag_ryou_Blend2)
            
            form
            +++ Section("ブレンド豆３"){
                $0.tag = "blend3"
            }
            setTextRow(tag: "beanTag_seisannkoku_Blend3", title: "生産国", ph: "", value: reviewMemos[0].beanTag_seisannkoku_Blend3)
            setTextRow(tag: "beanTag_tiiki_Blend3", title: "地域", ph: "", value: reviewMemos[0].beanTag_tiiki_Blend3)
            setTextRow(tag: "beanTag_nouennmei_Blend3", title: "農園名", ph: "", value: reviewMemos[0].beanTag_nouennmei_Blend3)
            setTextRow(tag: "beanTag_seisannsya_Blend3", title: "生産者", ph: "", value: reviewMemos[0].beanTag_seisannsya_Blend3)
            setTextRow(tag: "beanTag_hinnsyu_Blend3", title: "品種", ph: "", value: reviewMemos[0].beanTag_hinnsyu_Blend3)
            setIntRow(tag: "beanTag_hyoukou_Blend3", title: "標高", ph: "m", value: beanTag_hyoukou_Blend3)
            setTextRow(tag: "beanTag_seiseihouhou_Blend3", title: "精製方法", ph: "", value: reviewMemos[0].beanTag_seiseihouhou_Blend3)
            setTextRow(tag: "beanTag_baisenndo_Blend3", title: "焙煎度", ph: "", value: reviewMemos[0].beanTag_baisenndo_Blend3)
            setDateRow(tag: "beanTag_baisenbi_Blend3", title: "焙煎日", value: reviewMemos[0].beanTag_baisenbi_Blend3)
            setDecimalRow(tag: "beanTag_ryou_Blend3", title: "豆の量", ph: "/ 100g", value: beanTag_ryou_Blend3)
            
            form
            +++ Section("ブレンド豆４"){
                $0.tag = "blend4"
            }
            setTextRow(tag: "beanTag_seisannkoku_Blend4", title: "生産国", ph: "", value: reviewMemos[0].beanTag_seisannkoku_Blend4)
            setTextRow(tag: "beanTag_tiiki_Blend4", title: "地域", ph: "", value: reviewMemos[0].beanTag_tiiki_Blend4)
            setTextRow(tag: "beanTag_nouennmei_Blend4", title: "農園名", ph: "", value: reviewMemos[0].beanTag_nouennmei_Blend4)
            setTextRow(tag: "beanTag_seisannsya_Blend4", title: "生産者", ph: "", value: reviewMemos[0].beanTag_seisannsya_Blend4)
            setTextRow(tag: "beanTag_hinnsyu_Blend4", title: "品種", ph: "", value: reviewMemos[0].beanTag_hinnsyu_Blend4)
            setIntRow(tag: "beanTag_hyoukou_Blend4", title: "標高", ph: "m", value: beanTag_hyoukou_Blend4)
            setTextRow(tag: "beanTag_seiseihouhou_Blend4", title: "精製方法", ph: "", value: reviewMemos[0].beanTag_seiseihouhou_Blend4)
            setTextRow(tag: "beanTag_baisenndo_Blend4", title: "焙煎度", ph: "", value: reviewMemos[0].beanTag_baisenndo_Blend4)
            setDateRow(tag: "beanTag_baisenbi_Blend4", title: "焙煎日", value: reviewMemos[0].beanTag_baisenbi_Blend4)
            setDecimalRow(tag: "beanTag_ryou_Blend4", title: "豆の量", ph: "/ 100g", value: beanTag_ryou_Blend4)
        }
        
        form
        +++ Section("メモ"){
            $0.tag = "memo_bean"
        }
        setTextAreaRow(tag: "beanTag_memo", title: "メモ", ph: "", value: reviewMemos[0].beanTag_memo)

        form
        +++ Section("抽出方法"){
            $0.tag = "dripSection"
        }
        form.last! <<< SwitchRow { row in
            row.tag = "dripSwitchRow"
            row.title = "抽出方法　プリセット ▼ "
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }
        .onChange { row in
            if row.value! {
                //スイッチ　オンの場合の処理
                self.form.sectionBy(tag: "common_drip")?.hidden = false
                self.form.sectionBy(tag: "common_drip")?.evaluateHidden()
            }else{
                //スイッチ　オフの場合の処理
                self.form.sectionBy(tag: "common_drip")?.hidden = true
                self.form.sectionBy(tag: "common_drip")?.evaluateHidden()
            }
        }
        
        var tyuusyutuValue:Tuple<String, String>?
        if reviewMemos[0].dripTag_tyuusyutujikann_minutes != nil && reviewMemos[0].dripTag_tyuusyutujikann_seconds != nil {
            tyuusyutuValue = Tuple(a: reviewMemos[0].dripTag_tyuusyutujikann_minutes!, b: reviewMemos[0].dripTag_tyuusyutujikann_seconds!)
        }
        var murasiValue:Tuple<String, String>?
        if reviewMemos[0].dripTag_murasijikann_minutes != nil && reviewMemos[0].dripTag_murasijikann_seconds != nil {
            murasiValue = Tuple(a: reviewMemos[0].dripTag_murasijikann_minutes!, b: reviewMemos[0].dripTag_murasijikann_seconds!)
        }
        
        var dripTag_ondo: Double?
        if reviewMemos[0].dripTag_ondo != nil {
            dripTag_ondo = Double(reviewMemos[0].dripTag_ondo!)
        }
        var dripTag_ryou: Double?
        if reviewMemos[0].dripTag_ryou != nil {
            dripTag_ryou = Double(reviewMemos[0].dripTag_ryou!)
        }
        var dripTag_sasiyu: Double?
        if reviewMemos[0].dripTag_sasiyu != nil {
            dripTag_sasiyu = Double(reviewMemos[0].dripTag_sasiyu!)
        }
        
        setTextRow_switch(tag: "dripTag_namae", title: "名前", ph: "", value: reviewMemos[0].dripTag_namae, switchTag: "dripSwitchRow")
        setDecimalRow_switch(tag: "dripTag_ondo", title: "お湯の温度", ph: "℃", value: dripTag_ondo, switchTag: "dripSwitchRow")
        setDecimalRow_switch(tag: "dripTag_ryou", title: "お湯の量", ph: "g", value: dripTag_ryou, switchTag: "dripSwitchRow")
        setDoublePickerInputRow_switch(tag: "dripTag_tyuusyutujikann", title: "抽出時間", value: tyuusyutuValue, switchTag: "dripSwitchRow")
        setDoublePickerInputRow_switch(tag: "dripTag_murasijikann", title: "蒸らし時間", value: murasiValue, switchTag: "dripSwitchRow")
        setDecimalRow_switch(tag: "dripTag_sasiyu", title: "差し湯の量", ph: "g", value: dripTag_sasiyu, switchTag: "dripSwitchRow")
        setTextRow_switch(tag: "dripTag_rinsu", title: "リンス有無", ph: "", value: reviewMemos[0].dripTag_rinsu, switchTag: "dripSwitchRow")
        setTextRow_switch(tag: "dripTag_paper", title: "フィルターの種類", ph: "", value: reviewMemos[0].dripTag_paper, switchTag: "dripSwitchRow")
        setTextRow_switch(tag: "dripTag_dorippa", title: "ドリッパーの種類", ph: "", value: reviewMemos[0].dripTag_dorippa, switchTag: "dripSwitchRow")
        setTextAreaRow_switch(tag: "dripTag_memo", title: "メモ", ph: "メモ", value: reviewMemos[0].dripTag_memo, switchTag: "dripSwitchRow")
        
        
        form
        +++ Section("挽き方")
        form.last! <<< SwitchRow { row in
            row.tag = "grindSwitchRow"
            row.title = "挽き方　プリセット ▼ "
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }
        .onChange { row in
            if row.value! {
                //スイッチ　オンの場合の処理
                self.form.sectionBy(tag: "common_grind")?.hidden = false
                self.form.sectionBy(tag: "common_grind")?.evaluateHidden()
            }else{
                //スイッチ　オフの場合の処理
                self.form.sectionBy(tag: "common_grind")?.hidden = true
                self.form.sectionBy(tag: "common_grind")?.evaluateHidden()
            }
        }
        
        setTextRow_switch(tag: "grindTag_namae", title: "名前", ph: "", value: reviewMemos[0].grindTag_namae, switchTag: "grindSwitchRow")
        setTextRow_switch(tag: "grindTag_hikime", title: "挽き目", ph: "", value: reviewMemos[0].grindTag_hikime, switchTag: "grindSwitchRow")
        setTextRow_switch(tag: "grindTag_miru", title: "ミルの種類", ph: "", value: reviewMemos[0].grindTag_miru, switchTag: "grindSwitchRow")
        setImageRow_switch(tag: "grindTag_image1", savedImage: reviewImages[0].grindTag_image1, switchTag: "grindSwitchRow")
        (form.rowBy(tag: "grindTag_image1") as! ImageRow).onChange { [unowned self] row in
            //選択した画像を消してもエラーが出ないように
            if row.value != nil {
                selectedGrindImage = row.value!
            }
        }
        setTextAreaRow_switch(tag: "grindTag_memo", title: "メモ", ph: "メモ", value: reviewMemos[0].grindTag_memo, switchTag: "grindSwitchRow")
        
        
        //初期画面でスイッチをオフで設定。以降はonChangeで管理
        form.rowBy(tag: "beanSwitchRow")?.value = false
        form.rowBy(tag: "dripSwitchRow")?.value = false
        form.rowBy(tag: "grindSwitchRow")?.value = false
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //キーボードを閉じる
        view.endEditing(true)
        
        let nameRow = self.form.rowBy(tag: "reviewTag_namae") as! TextRow
        //名前を必須項目として、未入力の場合はエラー表示
        if nameRow.value == nil {
            self.errorMessageName()
            return;
        }
    
        //インジケータの表示
        SVProgressHUD.show(withStatus: "保存中です")
        
        let now = self.getNow()
        var countDown : Double = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
            self.form.rowBy(tag: "beanSwitchRow")?.value = true
            self.form.rowBy(tag: "dripSwitchRow")?.value = true
            self.form.rowBy(tag: "grindSwitchRow")?.value = true
        }
        
        let image1 = self.form.rowBy(tag: "reviewTag_image1")?.baseValue as? UIImage
        if image1 != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
                self.reviewImages[0].reviewTag_image1 = image1!.reSizeImage()!.pngData()
                self.form.rowBy(tag: "reviewTag_image1")?.baseValue = nil
                do{
                    try self.managedObjectContext.save()
                }catch{
                    print("エラーだよ")
                }
            }
            countDown = countDown + 5.0
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
                self.reviewImages[0].reviewTag_image1 = nil
            }
        }
        
        let image2 = self.form.rowBy(tag: "beanTag_image1")?.baseValue as? UIImage
        if image2 != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
                self.reviewImages[0].beanTag_image1 = image2!.reSizeImage()!.pngData()
                self.form.rowBy(tag: "beanTag_image1")?.baseValue = nil
                do{
                    try self.managedObjectContext.save()
                }catch{
                    print("エラーだよ")
                }
            }
            countDown = countDown + 5.0
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
                self.reviewImages[0].beanTag_image1 = nil
            }
        }
        
        let image3 = self.form.rowBy(tag: "grindTag_image1")?.baseValue as? UIImage
        if image3 != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
                self.reviewImages[0].grindTag_image1 = image3!.reSizeImage()!.pngData()
                self.form.rowBy(tag: "grindTag_image1")?.baseValue = nil
                do{
                    try self.managedObjectContext.save()
                }catch{
                    print("エラーだよ")
                }
            }
            countDown = countDown + 5.0
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
                self.reviewImages[0].grindTag_image1 = nil
            }
        }

        //イベントメソッドが終わらないと画面表示が更新されないので
        //メインスレッドでの処理だが、時差で仕込み　ひとまず画面更新をかける
        DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
            //フォームへの入力値をvalues（配列）へ格納
            let values = self.form.values()

            self.reviewImages[0].reviewEditedDate = now
            self.reviewMemos[0].reviewEditedDate = now
            
            //並べ替え用　カタカナ変換
            let reviewTag_namae = values["reviewTag_namae"] as? String
            if reviewTag_namae != nil {
                self.reviewMemos[0].reviewTag_ForSortNamae = reviewTag_namae!.convertKana()
            }
            let beanTag_namae = values["beanTag_namae"] as? String
            if beanTag_namae != nil {
                self.reviewMemos[0].beanTag_ForSortNamae = beanTag_namae!.convertKana()
            }
            let dripTag_namae = values["dripTag_namae"] as? String
            if dripTag_namae != nil {
                self.reviewMemos[0].dripTag_ForSortNamae = dripTag_namae!.convertKana()
            }
            let grindTag_namae = values["grindTag_namae"] as? String
            if grindTag_namae != nil {
                self.reviewMemos[0].grindTag_ForSortNamae = grindTag_namae!.convertKana()
            }
            
            
            let reviewTag_hyouka = values["reviewTag_hyouka"] as? Int
            if reviewTag_hyouka != nil {
                self.reviewMemos[0].reviewTag_hyouka = Int16(reviewTag_hyouka!)
            }else{
                self.reviewMemos[0].reviewTag_hyouka = 0
            }
            
            let reviewTag_konaryou = values["reviewTag_konaryou"] as? Double
            if reviewTag_konaryou != nil {
                self.reviewMemos[0].reviewTag_konaryou = String(reviewTag_konaryou!)
            }else{
                self.reviewMemos[0].reviewTag_konaryou = nil
            }
            let beanTag_kakaku = values["beanTag_kakaku"] as? Int
            if beanTag_kakaku != nil {
                self.reviewMemos[0].beanTag_kakaku = String(beanTag_kakaku!)
            }else{
                self.reviewMemos[0].beanTag_kakaku = nil
            }
            let beanTag_kounyuuryou = values["beanTag_kounyuuryou"] as? Int
            if beanTag_kounyuuryou != nil {
                self.reviewMemos[0].beanTag_kounyuuryou = String(beanTag_kounyuuryou!)
            }else{
                self.reviewMemos[0].beanTag_kounyuuryou = nil
            }
            let beanTag_hyoukou_Single = values["beanTag_hyoukou_Single"] as? Int
            if beanTag_hyoukou_Single != nil {
                self.reviewMemos[0].beanTag_hyoukou_Single = String(beanTag_hyoukou_Single!)
            }else{
                self.reviewMemos[0].beanTag_hyoukou_Single = nil
            }
            let beanTag_hyoukou_Blend1 = values["beanTag_hyoukou_Blend1"] as? Int
            if beanTag_hyoukou_Blend1 != nil {
                self.reviewMemos[0].beanTag_hyoukou_Blend1 = String(beanTag_hyoukou_Blend1!)
            }else{
                self.reviewMemos[0].beanTag_hyoukou_Blend1 = nil
            }
            let beanTag_hyoukou_Blend2 = values["beanTag_hyoukou_Blend2"] as? Int
            if beanTag_hyoukou_Blend2 != nil {
                self.reviewMemos[0].beanTag_hyoukou_Blend2 = String(beanTag_hyoukou_Blend2!)
            }else{
                self.reviewMemos[0].beanTag_hyoukou_Blend2 = nil
            }
            let beanTag_hyoukou_Blend3 = values["beanTag_hyoukou_Blend3"] as? Int
            if beanTag_hyoukou_Blend3 != nil {
                self.reviewMemos[0].beanTag_hyoukou_Blend3 = String(beanTag_hyoukou_Blend3!)
            }else{
                self.reviewMemos[0].beanTag_hyoukou_Blend3 = nil
            }
            let beanTag_hyoukou_Blend4 = values["beanTag_hyoukou_Blend4"] as? Int
            if beanTag_hyoukou_Blend4 != nil {
                self.reviewMemos[0].beanTag_hyoukou_Blend4 = String(beanTag_hyoukou_Blend4!)
            }else{
                self.reviewMemos[0].beanTag_hyoukou_Blend4 = nil
            }
            let beanTag_ryou_Blend1 = values["beanTag_ryou_Blend1"] as? Double
            if beanTag_ryou_Blend1 != nil {
                self.reviewMemos[0].beanTag_ryou_Blend1 = String(beanTag_ryou_Blend1!)
            }else{
                self.reviewMemos[0].beanTag_ryou_Blend1 = nil
            }
            let beanTag_ryou_Blend2 = values["beanTag_ryou_Blend2"] as? Double
            if beanTag_ryou_Blend2 != nil {
                self.reviewMemos[0].beanTag_ryou_Blend2 = String(beanTag_ryou_Blend2!)
            }else{
                self.reviewMemos[0].beanTag_ryou_Blend2 = nil
            }
            let beanTag_ryou_Blend3 = values["beanTag_ryou_Blend3"] as? Double
            if beanTag_ryou_Blend3 != nil {
                self.reviewMemos[0].beanTag_ryou_Blend3 = String(beanTag_ryou_Blend3!)
            }else{
                self.reviewMemos[0].beanTag_ryou_Blend3 = nil
            }
            let beanTag_ryou_Blend4 = values["beanTag_ryou_Blend4"] as? Double
            if beanTag_ryou_Blend4 != nil {
                self.reviewMemos[0].beanTag_ryou_Blend4 = String(beanTag_ryou_Blend4!)
            }else{
                self.reviewMemos[0].beanTag_ryou_Blend4 = nil
            }
            
            //以下、入力値の反映
            self.reviewMemos[0].reviewTag_namae = values["reviewTag_namae"] as? String
            
            self.reviewMemos[0].beanTag_namae = values["beanTag_namae"] as? String
            self.reviewMemos[0].beanTag_hanbaiten = values["beanTag_hanbaiten"] as? String
            self.reviewMemos[0].beanTag_keisiki = values["beanTag_keisiki"] as? String
            self.reviewMemos[0].beanTag_kaori = values["beanTag_kaori"] as? String
            
            self.reviewMemos[0].beanTag_seisannkoku_Single = values["beanTag_seisannkoku_Single"] as? String
            self.reviewMemos[0].beanTag_tiiki_Single = values["beanTag_tiiki_Single"] as? String
            self.reviewMemos[0].beanTag_seisannsya_Single = values["beanTag_seisannsya_Single"] as? String
            self.reviewMemos[0].beanTag_hinnsyu_Single = values["beanTag_hinnsyu_Single"] as? String
            self.reviewMemos[0].beanTag_seiseihouhou_Single = values["beanTag_seiseihouhou_Single"] as? String
            self.reviewMemos[0].beanTag_baisenndo_Single = values["beanTag_baisenndo_Single"] as? String
            
            self.reviewMemos[0].beanTag_seisannkoku_Blend1 = values["beanTag_seisannkoku_Blend1"] as? String
            self.reviewMemos[0].beanTag_tiiki_Blend1 = values["beanTag_tiiki_Blend1"] as? String
            self.reviewMemos[0].beanTag_nouennmei_Blend1 = values["beanTag_nouennmei_Blend1"] as? String
            self.reviewMemos[0].beanTag_seisannsya_Blend1 = values["beanTag_seisannsya_Blend1"] as? String
            self.reviewMemos[0].beanTag_hinnsyu_Blend1 = values["beanTag_hinnsyu_Blend1"] as? String
            self.reviewMemos[0].beanTag_seiseihouhou_Blend1 = values["beanTag_seiseihouhou_Blend1"] as? String
            self.reviewMemos[0].beanTag_baisenndo_Blend1 = values["beanTag_baisenndo_Blend1"] as? String

            self.reviewMemos[0].beanTag_seisannkoku_Blend2 = values["beanTag_seisannkoku_Blend2"] as? String
            self.reviewMemos[0].beanTag_tiiki_Blend2 = values["beanTag_tiiki_Blend2"] as? String
            self.reviewMemos[0].beanTag_nouennmei_Blend2 = values["beanTag_nouennmei_Blend2"] as? String
            self.reviewMemos[0].beanTag_seisannsya_Blend2 = values["beanTag_seisannsya_Blend2"] as? String
            self.reviewMemos[0].beanTag_hinnsyu_Blend2 = values["beanTag_hinnsyu_Blend2"] as? String
            self.reviewMemos[0].beanTag_seiseihouhou_Blend2 = values["beanTag_seiseihouhou_Blend2"] as? String
            self.reviewMemos[0].beanTag_baisenndo_Blend2 = values["beanTag_baisenndo_Blend2"] as? String
            
            self.reviewMemos[0].beanTag_seisannkoku_Blend3 = values["beanTag_seisannkoku_Blend3"] as? String
            self.reviewMemos[0].beanTag_tiiki_Blend3 = values["beanTag_tiiki_Blend3"] as? String
            self.reviewMemos[0].beanTag_nouennmei_Blend3 = values["beanTag_nouennmei_Blend3"] as? String
            self.reviewMemos[0].beanTag_seisannsya_Blend3 = values["beanTag_seisannsya_Blend3"] as? String
            self.reviewMemos[0].beanTag_hinnsyu_Blend3 = values["beanTag_hinnsyu_Blend3"] as? String
            self.reviewMemos[0].beanTag_seiseihouhou_Blend3 = values["beanTag_seiseihouhou_Blend3"] as? String
            self.reviewMemos[0].beanTag_baisenndo_Blend3 = values["beanTag_baisenndo_Blend3"] as? String
            
            self.reviewMemos[0].beanTag_seisannkoku_Blend4 = values["beanTag_seisannkoku_Blend4"] as? String
            self.reviewMemos[0].beanTag_tiiki_Blend4 = values["beanTag_tiiki_Blend4"] as? String
            self.reviewMemos[0].beanTag_nouennmei_Blend4 = values["beanTag_nouennmei_Blend4"] as? String
            self.reviewMemos[0].beanTag_seisannsya_Blend4 = values["beanTag_seisannsya_Blend4"] as? String
            self.reviewMemos[0].beanTag_hinnsyu_Blend4 = values["beanTag_hinnsyu_Blend4"] as? String
            self.reviewMemos[0].beanTag_seiseihouhou_Blend4 = values["beanTag_seiseihouhou_Blend4"] as? String
            self.reviewMemos[0].beanTag_baisenndo_Blend4 = values["beanTag_baisenndo_Blend4"] as? String
            
            //DateRowの情報
            self.reviewMemos[0].beanTag_kounyuubi = values["beanTag_kounyuubi"] as? Date
            self.reviewMemos[0].beanTag_baisenbi_Single = values["beanTag_baisenbi_Single"] as? Date
            self.reviewMemos[0].beanTag_baisenbi_Blend1 = values["beanTag_baisenbi_Blend1"] as? Date
            self.reviewMemos[0].beanTag_baisenbi_Blend2 = values["beanTag_baisenbi_Blend2"] as? Date
            self.reviewMemos[0].beanTag_baisenbi_Blend3 = values["beanTag_baisenbi_Blend3"] as? Date
            self.reviewMemos[0].beanTag_baisenbi_Blend4 = values["beanTag_baisenbi_Blend4"] as? Date
            
            
            self.reviewMemos[0].dripTag_namae = values["dripTag_namae"] as? String
            self.reviewMemos[0].dripTag_rinsu = values["dripTag_rinsu"] as? String
            self.reviewMemos[0].dripTag_paper = values["dripTag_paper"] as? String
            self.reviewMemos[0].dripTag_dorippa = values["dripTag_dorippa"] as? String
            
            self.reviewMemos[0].grindTag_namae = values["grindTag_namae"] as? String
            self.reviewMemos[0].grindTag_hikime = values["grindTag_hikime"] as? String
            self.reviewMemos[0].grindTag_miru = values["grindTag_miru"] as? String

            //メモの情報
            self.reviewMemos[0].beanTag_memo = values["beanTag_memo"] as? String
            self.reviewMemos[0].dripTag_memo = values["dripTag_memo"] as? String
            self.reviewMemos[0].grindTag_memo = values["grindTag_memo"] as? String
            self.reviewMemos[0].reviewTag_memo = values["reviewTag_memo"] as? String
            
            //DoublePickerInputRowがタプル構造体での形式のため、form.values()ではなく直接取得
            let murasiRow = self.form.rowBy(tag: "dripTag_murasijikann") as! DoublePickerInputRow<String, String>
            if murasiRow.value != nil {
                let murasiValue = murasiRow.value!
                self.reviewMemos[0].dripTag_murasijikann_minutes = murasiValue.a
                self.reviewMemos[0].dripTag_murasijikann_seconds = murasiValue.b
            }else{
                self.reviewMemos[0].dripTag_murasijikann_minutes = nil
                self.reviewMemos[0].dripTag_murasijikann_seconds = nil
            }
            let tyuusyutuRow = self.form.rowBy(tag: "dripTag_tyuusyutujikann") as! DoublePickerInputRow<String, String>
            if tyuusyutuRow.value != nil {
                let tyuusyutuValue = tyuusyutuRow.value!
                self.reviewMemos[0].dripTag_tyuusyutujikann_minutes = tyuusyutuValue.a
                self.reviewMemos[0].dripTag_tyuusyutujikann_seconds = tyuusyutuValue.b
            }else{
                self.reviewMemos[0].dripTag_tyuusyutujikann_minutes = nil
                self.reviewMemos[0].dripTag_tyuusyutujikann_seconds = nil
            }
            
            let dripTag_ondo = values["dripTag_ondo"] as? Double
            if dripTag_ondo != nil {
                self.reviewMemos[0].dripTag_ondo = String(dripTag_ondo!)
            }else{
                self.reviewMemos[0].dripTag_ondo = nil
            }
            let dripTag_ryou = values["dripTag_ryou"] as? Double
            if dripTag_ryou != nil {
                self.reviewMemos[0].dripTag_ryou = String(dripTag_ryou!)
            }else{
                self.reviewMemos[0].dripTag_ryou = nil
            }
            let dripTag_sasiyu = values["dripTag_sasiyu"] as? Double
            if dripTag_sasiyu != nil {
                self.reviewMemos[0].dripTag_sasiyu = String(dripTag_sasiyu!)
            }else{
                self.reviewMemos[0].dripTag_sasiyu = nil
            }
            

            //変更した内容にてデータを保存する（上書き保存）
            do{
                try self.managedObjectContext.save()
            }catch{
                print("エラーだよ")
            }

            //初期画面でスイッチをオフで設定。以降はonChangeで管理
            self.form.rowBy(tag: "beanSwitchRow")?.value = false
            self.form.rowBy(tag: "dripSwitchRow")?.value = false
            self.form.rowBy(tag: "grindSwitchRow")?.value = false
            
            //インジケータの非表示
            SVProgressHUD.dismiss()
            //完了メッセージ
            self.doneMessageToRoot()

        }
    }

}
