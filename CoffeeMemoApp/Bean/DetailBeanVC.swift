//
//  DetailBeanVC.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/03/20.
//

import UIKit
import CoreData
import Eureka
import ImageRow
import ViewRow

class DetailBeanVC: FormViewController {
    //prepare TableBeanVCからbeanIdの引き継ぎ
    var toDetailBeanVC: String!
    
    //CoreDataの入れ物を先に作っておく
    var beanImages:[BeanImage] = []
    var beanMemos:[BeanMemo] = []
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreDataを取得して、配列へ格納
        beanMemos = getBeanMemoId(moc: managedObjectContext, beanId: toDetailBeanVC)
        beanImages = getBeanImageId(moc: managedObjectContext, beanId: toDetailBeanVC)
        
        navigationItem.title = beanMemos[0].beanTag_namae
        tableView.backgroundColor = backgroundColor

        var beanTag_kounyuubi: String?
        if beanMemos[0].beanTag_kounyuubi != nil {
            beanTag_kounyuubi = beanMemos[0].beanTag_kounyuubi!.dateToString()
        }
        var beanTag_baisenbi_Single: String?
        if beanMemos[0].beanTag_baisenbi_Single != nil {
            beanTag_baisenbi_Single = beanMemos[0].beanTag_baisenbi_Single!.dateToString()
        }
        var beanTag_baisenbi_Blend1: String?
        if beanMemos[0].beanTag_baisenbi_Blend1 != nil {
            beanTag_baisenbi_Blend1 = beanMemos[0].beanTag_baisenbi_Blend1!.dateToString()
        }
        var beanTag_baisenbi_Blend2: String?
        if beanMemos[0].beanTag_baisenbi_Blend2 != nil {
            beanTag_baisenbi_Blend2 = beanMemos[0].beanTag_baisenbi_Blend2!.dateToString()
        }
        var beanTag_baisenbi_Blend3: String?
        if beanMemos[0].beanTag_baisenbi_Blend3 != nil {
            beanTag_baisenbi_Blend3 = beanMemos[0].beanTag_baisenbi_Blend3!.dateToString()
        }
        var beanTag_baisenbi_Blend4: String?
        if beanMemos[0].beanTag_baisenbi_Blend4 != nil {
            beanTag_baisenbi_Blend4 = beanMemos[0].beanTag_baisenbi_Blend4!.dateToString()
        }
        
    
        form
        +++ Section("コーヒー豆")
        setLabelRow(tag: "beanCreatedDate", title: "作成日", value: beanMemos[0].beanCreatedDate)
        setLabelRow(tag: "beanEditedDate", title: "変更日", value: beanMemos[0].beanEditedDate)
        setLabelRow(tag: "beanStatus", title: "ステータス", value: beanMemos[0].beanStatus)
        setLabelRow(tag: "beanTag_namae", title: "名前", value: beanMemos[0].beanTag_namae)
        setLabelRow(tag: "beanTag_hanbaiten", title: "販売店", value: beanMemos[0].beanTag_hanbaiten)
        setLabelRow(tag: "beanTag_keisiki", title: "購入形式", value: beanMemos[0].beanTag_keisiki)
        setLabelRow(tag: "beanTag_kakaku", title: "価格", value: beanMemos[0].beanTag_kakaku)
        setLabelRow(tag: "beanTag_kounyuuryou", title: "購入量", value: beanMemos[0].beanTag_kounyuuryou)
        setLabelRow(tag: "beanTag_kaori", title: "香り", value: beanMemos[0].beanTag_kaori)
        setLabelRow(tag: "beanTag_kounyuubi", title: "購入日", value: beanTag_kounyuubi)
        
        if beanMemos[0].beanStatus == "シングル" {
            form
            +++ Section("シングル")
            setLabelRow(tag: "beanTag_seisannkoku_Single", title: "生産国", value: beanMemos[0].beanTag_seisannkoku_Single)
            setLabelRow(tag: "beanTag_tiiki_Single", title: "地域", value: beanMemos[0].beanTag_tiiki_Single)
            setLabelRow(tag: "beanTag_nouennmei_Single", title: "農園名", value: beanMemos[0].beanTag_nouennmei_Single)
            setLabelRow(tag: "beanTag_seisannsya_Single", title: "生産者", value: beanMemos[0].beanTag_seisannsya_Single)
            setLabelRow(tag: "beanTag_hinnsyu_Single", title: "品種", value: beanMemos[0].beanTag_hinnsyu_Single)
            setLabelRow(tag: "beanTag_hyoukou_Single", title: "標高", value: beanMemos[0].beanTag_hyoukou_Single)
            setLabelRow(tag: "beanTag_seiseihouhou_Single", title: "精製方法", value: beanMemos[0].beanTag_seiseihouhou_Single)
            setLabelRow(tag: "beanTag_baisenndo_Single", title: "焙煎度", value: beanMemos[0].beanTag_baisenndo_Single)
            setLabelRow(tag: "beanTag_baisenbi_Single", title: "焙煎日", value: beanTag_baisenbi_Single)
        }else{
            form
            +++ Section("ブレンド豆１")
            setLabelRow(tag: "beanTag_seisannkoku_Blend1", title: "生産国", value: beanMemos[0].beanTag_seisannkoku_Blend1)
            setLabelRow(tag: "beanTag_tiiki_Blend1", title: "地域", value: beanMemos[0].beanTag_tiiki_Blend1)
            setLabelRow(tag: "beanTag_nouennmei_Blend1", title: "農園名", value: beanMemos[0].beanTag_nouennmei_Blend1)
            setLabelRow(tag: "beanTag_seisannsya_Blend1", title: "生産者", value: beanMemos[0].beanTag_seisannsya_Blend1)
            setLabelRow(tag: "beanTag_hinnsyu_Blend1", title: "品種", value: beanMemos[0].beanTag_hinnsyu_Blend1)
            setLabelRow(tag: "beanTag_hyoukou_Blend1", title: "標高", value: beanMemos[0].beanTag_hyoukou_Blend1)
            setLabelRow(tag: "beanTag_seiseihouhou_Blend1", title: "精製方法", value: beanMemos[0].beanTag_seiseihouhou_Blend1)
            setLabelRow(tag: "beanTag_baisenndo_Blend1", title: "焙煎度", value: beanMemos[0].beanTag_baisenndo_Blend1)
            setLabelRow(tag: "beanTag_baisenbi_Blend1", title: "焙煎日", value: beanTag_baisenbi_Blend1)
            setLabelRow(tag: "beanTag_ryou_Blend1", title: "豆の量", value: beanMemos[0].beanTag_ryou_Blend1)
            
            form
            +++ Section("ブレンド豆２")
            setLabelRow(tag: "beanTag_seisannkoku_Blend2", title: "生産国", value: beanMemos[0].beanTag_seisannkoku_Blend2)
            setLabelRow(tag: "beanTag_tiiki_Blend2", title: "地域", value: beanMemos[0].beanTag_tiiki_Blend2)
            setLabelRow(tag: "beanTag_nouennmei_Blend2", title: "農園名", value: beanMemos[0].beanTag_nouennmei_Blend2)
            setLabelRow(tag: "beanTag_seisannsya_Blend2", title: "生産者", value: beanMemos[0].beanTag_seisannsya_Blend2)
            setLabelRow(tag: "beanTag_hinnsyu_Blend2", title: "品種", value: beanMemos[0].beanTag_hinnsyu_Blend2)
            setLabelRow(tag: "beanTag_hyoukou_Blend2", title: "標高", value: beanMemos[0].beanTag_hyoukou_Blend2)
            setLabelRow(tag: "beanTag_seiseihouhou_Blend2", title: "精製方法", value: beanMemos[0].beanTag_seiseihouhou_Blend2)
            setLabelRow(tag: "beanTag_baisenndo_Blend2", title: "焙煎度", value: beanMemos[0].beanTag_baisenndo_Blend2)
            setLabelRow(tag: "beanTag_baisenbi_Blend2", title: "焙煎日", value: beanTag_baisenbi_Blend2)
            setLabelRow(tag: "beanTag_ryou_Blend2", title: "豆の量", value: beanMemos[0].beanTag_ryou_Blend2)

            form
            +++ Section("ブレンド豆３")
            setLabelRow(tag: "beanTag_seisannkoku_Blend3", title: "生産国", value: beanMemos[0].beanTag_seisannkoku_Blend3)
            setLabelRow(tag: "beanTag_tiiki_Blend3", title: "地域", value: beanMemos[0].beanTag_tiiki_Blend3)
            setLabelRow(tag: "beanTag_nouennmei_Blend3", title: "農園名", value: beanMemos[0].beanTag_nouennmei_Blend3)
            setLabelRow(tag: "beanTag_seisannsya_Blend", title: "生産者", value: beanMemos[0].beanTag_seisannsya_Blend3)
            setLabelRow(tag: "beanTag_hinnsyu_Blend3", title: "品種", value: beanMemos[0].beanTag_hinnsyu_Blend3)
            setLabelRow(tag: "beanTag_hyoukou_Blend3", title: "標高", value: beanMemos[0].beanTag_hyoukou_Blend3)
            setLabelRow(tag: "beanTag_seiseihouhou_Blend3", title: "精製方法", value: beanMemos[0].beanTag_seiseihouhou_Blend3)
            setLabelRow(tag: "beanTag_baisenndo_Blend3", title: "焙煎度", value: beanMemos[0].beanTag_baisenndo_Blend3)
            setLabelRow(tag: "beanTag_baisenbi_Blend3", title: "焙煎日", value: beanTag_baisenbi_Blend3)
            setLabelRow(tag: "beanTag_ryou_Blend3", title: "豆の量", value: beanMemos[0].beanTag_ryou_Blend3)

            form
            +++ Section("ブレンド豆４")
            setLabelRow(tag: "beanTag_seisannkoku_Blend4", title: "生産国", value: beanMemos[0].beanTag_seisannkoku_Blend4)
            setLabelRow(tag: "beanTag_tiiki_Blend", title: "地域", value: beanMemos[0].beanTag_tiiki_Blend4)
            setLabelRow(tag: "beanTag_nouennmei_Blend4", title: "農園名", value: beanMemos[0].beanTag_nouennmei_Blend4)
            setLabelRow(tag: "beanTag_seisannsya_Blend4", title: "生産者", value: beanMemos[0].beanTag_seisannsya_Blend4)
            setLabelRow(tag: "beanTag_hinnsyu_Blend4", title: "品種", value: beanMemos[0].beanTag_hinnsyu_Blend4)
            setLabelRow(tag: "beanTag_hyoukou_Blend4", title: "標高", value: beanMemos[0].beanTag_hyoukou_Blend4)
            setLabelRow(tag: "beanTag_seiseihouhou_Blend4", title: "精製方法", value: beanMemos[0].beanTag_seiseihouhou_Blend4)
            setLabelRow(tag: "beanTag_baisenndo_Blend4", title: "焙煎度", value: beanMemos[0].beanTag_baisenndo_Blend4)
            setLabelRow(tag: "beanTag_baisenbi_Blend4", title: "焙煎日", value: beanTag_baisenbi_Blend4)
            setLabelRow(tag: "beanTag_ryou_Blend4", title: "豆の量", value: beanMemos[0].beanTag_ryou_Blend4)
        }
        
        form
        +++ Section("メモ")
        setTextAreaRow(tag: "beanTag_memo", title: "メモ", ph: "", value: beanMemos[0].beanTag_memo)
        (form.rowBy(tag: "beanTag_memo") as! TextAreaRow).textAreaMode = TextAreaMode.readOnly
        
        if beanImages[0].beanTag_image1 != nil {
            form
            +++ Section("画像")
            setViewRow(savedImage: beanImages[0].beanTag_image1)
        }
    }
    
    //editVCへIDを送る
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "editSegue" {
            let destination = segue.destination as? EditBeanVC
           destination?.toEditBeanVC = toDetailBeanVC
       }
    }
  

}



