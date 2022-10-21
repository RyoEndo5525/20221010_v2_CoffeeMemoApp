//
//  DetailReviewVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import ViewRow

class DetailReviewVC: FormViewController {
    //prepare TableBeanVCからbeanIdの引き継ぎ
    var toDetailReviewVC: String!
    
    var reviewImages:[ReviewImage] = []
    var reviewMemos:[ReviewMemo] = []
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreDataを取得して、配列へ格納
        reviewMemos = getReviewMemoId(moc: managedObjectContext, reviewId: toDetailReviewVC)
        reviewImages = getReviewImageId(moc: managedObjectContext, reviewId: toDetailReviewVC)
        navigationItem.title = reviewMemos[0].reviewTag_namae
        tableView.backgroundColor = backgroundColor
        
        form
        +++ Section("レビュー")
        setLabelRow(tag: "reviewCreatedDate", title: "作成日", value: reviewMemos[0].reviewCreatedDate)
        setLabelRow(tag: "reviewEditedDate", title: "変更日", value: reviewMemos[0].reviewEditedDate)
        setLabelRow(tag: "reviewTag_namae", title: "名前", value: reviewMemos[0].reviewTag_namae)
        setLabelRow(tag: "reviewTag_konaryou", title: "粉の量", value: reviewMemos[0].reviewTag_konaryou)
        setLabelRow(tag: "reviewTag_hyouka", title: "評価", value: reviewMemos[0].reviewTag_hyouka.description)
        setTextAreaRow(tag: "reviewTag_memo", title: "メモ", ph: "メモ", value: reviewMemos[0].reviewTag_memo)
        (form.rowBy(tag: "reviewTag_memo") as! TextAreaRow).textAreaMode = TextAreaMode.readOnly
        
        if reviewImages[0].reviewTag_image1 != nil {
            form
            +++ Section("画像")
            setViewRow(savedImage: reviewImages[0].reviewTag_image1)
        }
        
        form
        +++ Section("コーヒー豆")
        form.last! <<< SwitchRow { row in
            row.tag = "beanSwitchRow"
            if reviewMemos[0].beanTag_namae != nil {
                row.title = reviewMemos[0].beanTag_namae
            }else{
                row.title = "コーヒー豆"
            }
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }
            .onChange { row in
                let commonSection = [
                    self.form.sectionBy(tag: "common_bean"),
                    self.form.sectionBy(tag: "memo_bean"),
                    self.form.sectionBy(tag: "image_bean")
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
        

        var beanTag_kounyuubi: String?
        if reviewMemos[0].beanTag_kounyuubi != nil {
            beanTag_kounyuubi = reviewMemos[0].beanTag_kounyuubi!.dateToString()
        }
        var beanTag_baisenbi_Single: String?
        if reviewMemos[0].beanTag_baisenbi_Single != nil {
            beanTag_baisenbi_Single = reviewMemos[0].beanTag_baisenbi_Single!.dateToString()
        }
        var beanTag_baisenbi_Blend1: String?
        if reviewMemos[0].beanTag_baisenbi_Blend1 != nil {
            beanTag_baisenbi_Blend1 = reviewMemos[0].beanTag_baisenbi_Blend1!.dateToString()
        }
        var beanTag_baisenbi_Blend2: String?
        if reviewMemos[0].beanTag_baisenbi_Blend2 != nil {
            beanTag_baisenbi_Blend2 = reviewMemos[0].beanTag_baisenbi_Blend2!.dateToString()
        }
        var beanTag_baisenbi_Blend3: String?
        if reviewMemos[0].beanTag_baisenbi_Blend3 != nil {
            beanTag_baisenbi_Blend3 = reviewMemos[0].beanTag_baisenbi_Blend3!.dateToString()
        }
        var beanTag_baisenbi_Blend4: String?
        if reviewMemos[0].beanTag_baisenbi_Blend4 != nil {
            beanTag_baisenbi_Blend4 = reviewMemos[0].beanTag_baisenbi_Blend4!.dateToString()
        }
        
        
        form
        +++ Section("コーヒー豆"){
            $0.tag = "common_bean"
        }
        setLabelRow(tag: "beanStatus", title: "ステータス", value: reviewMemos[0].beanStatus)
        setLabelRow(tag: "beanTag_namae", title: "名前", value: reviewMemos[0].beanTag_namae)
        setLabelRow(tag: "beanTag_hanbaiten", title: "販売店", value: reviewMemos[0].beanTag_hanbaiten)
        setLabelRow(tag: "beanTag_keisiki", title: "購入形式", value: reviewMemos[0].beanTag_keisiki)
        setLabelRow(tag: "beanTag_kakaku", title: "価格", value: reviewMemos[0].beanTag_kakaku)
        setLabelRow(tag: "beanTag_kounyuuryou", title: "購入量", value: reviewMemos[0].beanTag_kounyuuryou)
        setLabelRow(tag: "beanTag_kaori", title: "香り", value: reviewMemos[0].beanTag_kaori)
        setLabelRow(tag: "beanTag_kounyuubi", title: "購入日", value: beanTag_kounyuubi)

        if reviewMemos[0].beanStatus == "シングル" {
            form
            +++ Section("シングル"){
                $0.tag = "single"
            }
            setLabelRow(tag: "beanTag_seisannkoku_Single", title: "生産国", value: reviewMemos[0].beanTag_seisannkoku_Single)
            setLabelRow(tag: "beanTag_tiiki_Single", title: "地域", value: reviewMemos[0].beanTag_tiiki_Single)
            setLabelRow(tag: "beanTag_nouennmei_Single", title: "農園名", value: reviewMemos[0].beanTag_nouennmei_Single)
            setLabelRow(tag: "beanTag_seisannsya_Single", title: "生産者", value: reviewMemos[0].beanTag_seisannsya_Single)
            setLabelRow(tag: "beanTag_hinnsyu_Single", title: "品種", value: reviewMemos[0].beanTag_hinnsyu_Single)
            setLabelRow(tag: "beanTag_hyoukou_Single", title: "標高", value: reviewMemos[0].beanTag_hyoukou_Single)
            setLabelRow(tag: "beanTag_seiseihouhou_Single", title: "精製方法", value: reviewMemos[0].beanTag_seiseihouhou_Single)
            setLabelRow(tag: "beanTag_baisenndo_Single", title: "焙煎度", value: reviewMemos[0].beanTag_baisenndo_Single)
            setLabelRow(tag: "beanTag_baisenbi_Single", title: "焙煎日", value: beanTag_baisenbi_Single)

        }else{
            form
            +++ Section("ブレンド豆１"){
                $0.tag = "blend1"
            }
            setLabelRow(tag: "beanTag_seisannkoku_Blend1", title: "生産国", value: reviewMemos[0].beanTag_seisannkoku_Blend1)
            setLabelRow(tag: "beanTag_tiiki_Blend1", title: "地域", value: reviewMemos[0].beanTag_tiiki_Blend1)
            setLabelRow(tag: "beanTag_nouennmei_Blend1", title: "農園名", value: reviewMemos[0].beanTag_nouennmei_Blend1)
            setLabelRow(tag: "beanTag_seisannsya_Blend1", title: "生産者", value: reviewMemos[0].beanTag_seisannsya_Blend1)
            setLabelRow(tag: "beanTag_hinnsyu_Blend1", title: "品種", value: reviewMemos[0].beanTag_hinnsyu_Blend1)
            setLabelRow(tag: "beanTag_hyoukou_Blend1", title: "標高", value: reviewMemos[0].beanTag_hyoukou_Blend1)
            setLabelRow(tag: "beanTag_seiseihouhou_Blend1", title: "精製方法", value: reviewMemos[0].beanTag_seiseihouhou_Blend1)
            setLabelRow(tag: "beanTag_baisenndo_Blend1", title: "焙煎度", value: reviewMemos[0].beanTag_baisenndo_Blend1)
            setLabelRow(tag: "beanTag_baisenbi_Blend1", title: "焙煎日", value: beanTag_baisenbi_Blend1)
            setLabelRow(tag: "beanTag_ryou_Blend1", title: "豆の量", value: reviewMemos[0].beanTag_ryou_Blend1)
            
            form
            +++ Section("ブレンド豆２"){
                $0.tag = "blend2"
            }
            setLabelRow(tag: "beanTag_seisannkoku_Blend2", title: "生産国", value: reviewMemos[0].beanTag_seisannkoku_Blend2)
            setLabelRow(tag: "beanTag_tiiki_Blend2", title: "地域", value: reviewMemos[0].beanTag_tiiki_Blend2)
            setLabelRow(tag: "beanTag_nouennmei_Blend2", title: "農園名", value: reviewMemos[0].beanTag_nouennmei_Blend2)
            setLabelRow(tag: "beanTag_seisannsya_Blend2", title: "生産者", value: reviewMemos[0].beanTag_seisannsya_Blend2)
            setLabelRow(tag: "beanTag_hinnsyu_Blend2", title: "品種", value: reviewMemos[0].beanTag_hinnsyu_Blend2)
            setLabelRow(tag: "beanTag_hyoukou_Blend2", title: "標高", value: reviewMemos[0].beanTag_hyoukou_Blend2)
            setLabelRow(tag: "beanTag_seiseihouhou_Blend2", title: "精製方法", value: reviewMemos[0].beanTag_seiseihouhou_Blend2)
            setLabelRow(tag: "beanTag_baisenndo_Blend2", title: "焙煎度", value: reviewMemos[0].beanTag_baisenndo_Blend2)
            setLabelRow(tag: "beanTag_baisenbi_Blend2", title: "焙煎日", value: beanTag_baisenbi_Blend2)
            setLabelRow(tag: "beanTag_ryou_Blend2", title: "豆の量", value: reviewMemos[0].beanTag_ryou_Blend2)

            form
            +++ Section("ブレンド豆３"){
                $0.tag = "blend3"
            }
            setLabelRow(tag: "beanTag_seisannkoku_Blend3", title: "生産国", value: reviewMemos[0].beanTag_seisannkoku_Blend3)
            setLabelRow(tag: "beanTag_tiiki_Blend3", title: "地域", value: reviewMemos[0].beanTag_tiiki_Blend3)
            setLabelRow(tag: "beanTag_nouennmei_Blend3", title: "農園名", value: reviewMemos[0].beanTag_nouennmei_Blend3)
            setLabelRow(tag: "beanTag_seisannsya_Blend", title: "生産者", value: reviewMemos[0].beanTag_seisannsya_Blend3)
            setLabelRow(tag: "beanTag_hinnsyu_Blend3", title: "品種", value: reviewMemos[0].beanTag_hinnsyu_Blend3)
            setLabelRow(tag: "beanTag_hyoukou_Blend3", title: "標高", value: reviewMemos[0].beanTag_hyoukou_Blend3)
            setLabelRow(tag: "beanTag_seiseihouhou_Blend3", title: "精製方法", value: reviewMemos[0].beanTag_seiseihouhou_Blend3)
            setLabelRow(tag: "beanTag_baisenndo_Blend3", title: "焙煎度", value: reviewMemos[0].beanTag_baisenndo_Blend3)
            setLabelRow(tag: "beanTag_baisenbi_Blend3", title: "焙煎日", value: beanTag_baisenbi_Blend3)
            setLabelRow(tag: "beanTag_ryou_Blend3", title: "豆の量", value: reviewMemos[0].beanTag_ryou_Blend3)

            form
            +++ Section("ブレンド豆４"){
                $0.tag = "blend4"
            }
            setLabelRow(tag: "beanTag_seisannkoku_Blend4", title: "生産国", value: reviewMemos[0].beanTag_seisannkoku_Blend4)
            setLabelRow(tag: "beanTag_tiiki_Blend", title: "地域", value: reviewMemos[0].beanTag_tiiki_Blend4)
            setLabelRow(tag: "beanTag_nouennmei_Blend4", title: "農園名", value: reviewMemos[0].beanTag_nouennmei_Blend4)
            setLabelRow(tag: "beanTag_seisannsya_Blend4", title: "生産者", value: reviewMemos[0].beanTag_seisannsya_Blend4)
            setLabelRow(tag: "beanTag_hinnsyu_Blend4", title: "品種", value: reviewMemos[0].beanTag_hinnsyu_Blend4)
            setLabelRow(tag: "beanTag_hyoukou_Blend4", title: "標高", value: reviewMemos[0].beanTag_hyoukou_Blend4)
            setLabelRow(tag: "beanTag_seiseihouhou_Blend4", title: "精製方法", value: reviewMemos[0].beanTag_seiseihouhou_Blend4)
            setLabelRow(tag: "beanTag_baisenndo_Blend4", title: "焙煎度", value: reviewMemos[0].beanTag_baisenndo_Blend4)
            setLabelRow(tag: "beanTag_baisenbi_Blend4", title: "焙煎日", value: beanTag_baisenbi_Blend4)
            setLabelRow(tag: "beanTag_ryou_Blend4", title: "豆の量", value: reviewMemos[0].beanTag_ryou_Blend4)
        }
        
        form
        +++ Section("メモ"){
            $0.tag = "memo_bean"
        }
        setTextAreaRow(tag: "beanTag_memo", title: "メモ", ph: "", value: reviewMemos[0].beanTag_memo)
        (form.rowBy(tag: "beanTag_memo") as! TextAreaRow).textAreaMode = TextAreaMode.readOnly
        
        if reviewImages[0].beanTag_image1 != nil {
            form
            +++ Section("画像"){
                $0.tag = "image_bean"
            }
            setViewRow(savedImage: reviewImages[0].beanTag_image1)
        }
        
        
        
        form
        +++ Section("抽出方法"){
            $0.tag = "dripSection"
        }
        form.last! <<< SwitchRow { row in
            row.tag = "dripSwitchRow"
            if reviewMemos[0].dripTag_namae != nil {
                row.title = reviewMemos[0].dripTag_namae
            }else{
                row.title = "抽出方法"
            }
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
        
        var tyuusyutuValue:String?
        if reviewMemos[0].dripTag_tyuusyutujikann_minutes != nil &&
            reviewMemos[0].dripTag_tyuusyutujikann_seconds != nil {
                tyuusyutuValue = reviewMemos[0].dripTag_tyuusyutujikann_minutes!
                        + reviewMemos[0].dripTag_tyuusyutujikann_seconds!
        }
        
        var murasiValue:String?
        if reviewMemos[0].dripTag_murasijikann_minutes != nil &&
            reviewMemos[0].dripTag_murasijikann_seconds != nil {
                murasiValue = reviewMemos[0].dripTag_murasijikann_minutes!
                        + reviewMemos[0].dripTag_murasijikann_seconds!
        }
        //descriptionが不安、nilに対して実行できるのかどうか？
        setLabelRow_switch(tag: "dripTag_namae", title: "名前", value: reviewMemos[0].dripTag_namae, switchTag: "dripSwitchRow")
        setLabelRow_switch(tag: "dripTag_ondo", title: "お湯の温度", value: reviewMemos[0].dripTag_ondo, switchTag: "dripSwitchRow")
        setLabelRow_switch(tag: "dripTag_ryou", title: "お湯の量", value: reviewMemos[0].dripTag_ryou, switchTag: "dripSwitchRow")
        setLabelRow_switch(tag: "dripTag_tyuusyutujikann", title: "抽出時間", value: tyuusyutuValue, switchTag: "dripSwitchRow")
        setLabelRow_switch(tag: "dripTag_murasijikann", title: "蒸らし時間", value: murasiValue, switchTag: "dripSwitchRow")
        setLabelRow_switch(tag: "dripTag_sasiyu", title: "差し湯の量", value: reviewMemos[0].dripTag_sasiyu, switchTag: "dripSwitchRow")
        setLabelRow_switch(tag: "dripTag_rinsu", title: "リンス有無", value: reviewMemos[0].dripTag_rinsu, switchTag: "dripSwitchRow")
        setLabelRow_switch(tag: "dripTag_paper", title: "フィルターの種類", value: reviewMemos[0].dripTag_paper, switchTag: "dripSwitchRow")
        setLabelRow_switch(tag: "dripTag_dorippa", title: "ドリッパーの種類", value: reviewMemos[0].dripTag_dorippa, switchTag: "dripSwitchRow")
        setTextAreaRow_switch(tag: "dripTag_memo", title: "メモ", ph: "", value: reviewMemos[0].dripTag_memo, switchTag: "dripSwitchRow")
        (form.rowBy(tag: "dripTag_memo") as! TextAreaRow).textAreaMode = TextAreaMode.readOnly
        
        form
        +++ Section("挽き方")
        form.last! <<< SwitchRow { row in
            row.tag = "grindSwitchRow"
            if reviewMemos[0].grindTag_namae != nil {
                row.title = reviewMemos[0].grindTag_namae
            }else{
                row.title = "挽き方"
            }
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
        setLabelRow_switch(tag: "grindTag_namae", title: "名前", value: reviewMemos[0].grindTag_namae, switchTag: "grindSwitchRow")
        setLabelRow_switch(tag: "grindTag_hikime", title: "挽き目", value: reviewMemos[0].grindTag_hikime, switchTag: "grindSwitchRow")
        setLabelRow_switch(tag: "grindTag_miru", title: "ミルの種類", value: reviewMemos[0].grindTag_miru, switchTag: "grindSwitchRow")
        setTextAreaRow_switch(tag: "grindTag_memo", title: "メモ", ph: "", value: reviewMemos[0].grindTag_memo, switchTag: "grindSwitchRow")
        (form.rowBy(tag: "grindTag_memo") as! TextAreaRow).textAreaMode = TextAreaMode.readOnly
        
        setViewRow_switch(savedImage: reviewImages[0].grindTag_image1, switchTag: "grindSwitchRow")

        //初期画面でスイッチをオフで設定。以降はonChangeで管理
        form.rowBy(tag: "beanSwitchRow")?.value = false
        form.rowBy(tag: "dripSwitchRow")?.value = false
        form.rowBy(tag: "grindSwitchRow")?.value = false

    }

    
    //editVCへIDを送る
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "editSegue" {
            let destination = segue.destination as? EditReviewVC
           destination?.toEditReviewVC = toDetailReviewVC
       }
    }




}
