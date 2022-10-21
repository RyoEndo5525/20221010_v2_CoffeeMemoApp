//
//  NewReviewVC.swift
//  
//
//  Created by Ryo Endo on 2022/06/29.
//

import UIKit
import CoreData
import SVProgressHUD
import Eureka
import ImageRow

class NewReviewVC: FormViewController {
    
    var keyName = "beanTag_ForSortNamae"
    var boolName = true
    var beanImages:[BeanImage] = []
    var beanMemos:[BeanMemo] = []
    var dripMemos:[DripMemo] = []
    var grindImages:[GrindImage] = []
    var grindMemos:[GrindMemo] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBeanImage = UIImage()
    var selectedGrindImage = UIImage()
    var selectedReviewImage = UIImage()
    
    var beanStatus = "シングル"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "レビュー"
        tableView.backgroundColor = backgroundColor
        setLeftBarButton()

        
        form
        +++ Section("レビュー")
        setTextRow(tag: "reviewTag_namae", title: "名前", ph: "", value: nil)
        setDecimalRow(tag: "reviewTag_konaryou", title: "粉の量", ph: "g", value: nil)
        setIntRow(tag: "reviewTag_hyouka", title: "評価", ph: "", value: nil)
        setImageRow(tag: "reviewTag_image1", savedImage: nil)
        (form.rowBy(tag: "reviewTag_image1") as! ImageRow).onChange { [unowned self] row in
            //選択した画像を消してもエラーが出ないように
            if row.value != nil {
                selectedReviewImage = row.value!
            }
        }
        setTextAreaRow(tag: "reviewTag_memo", title: "メモ", ph: "メモ", value: nil)
        
        form
        +++ Section("コーヒー豆")
        form.last! <<< SwitchRow { row in
            row.tag = "beanSwitchRow"
            row.title = "コーヒー豆　プリセット ▼ "
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.onCellSelection{[unowned self] ButtonCellOf, row in
                self.modalPresentationToBean(viewControllerName: "SelectBeanPresetVC")
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
                    if self.beanStatus == "シングル" {
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
        }
        
        setSegmentedRow()
        

        
        form
        +++ Section("コーヒー豆"){
            $0.tag = "common_bean"
        }
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
        +++ Section("メモ"){
            $0.tag = "memo_bean"
        }
        setTextAreaRow(tag: "beanTag_memo", title: "メモ", ph: "", value: nil)

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
            row.onCellSelection{[unowned self] ButtonCellOf, row in
                self.modalPresentationToDrip(viewControllerName: "SelectDripPresetVC")
            }
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
        
        setTextRow_switch(tag: "dripTag_namae", title: "名前", ph: "", value: nil, switchTag: "dripSwitchRow")
        setDecimalRow_switch(tag: "dripTag_ondo", title: "お湯の温度", ph: "℃", value: nil, switchTag: "dripSwitchRow")
        setDecimalRow_switch(tag: "dripTag_ryou", title: "お湯の量", ph: "g", value: nil, switchTag: "dripSwitchRow")
        setDoublePickerInputRow_switch(tag: "dripTag_tyuusyutujikann", title: "抽出時間", value: nil, switchTag: "dripSwitchRow")
        setDoublePickerInputRow_switch(tag: "dripTag_murasijikann", title: "蒸らし時間", value: nil, switchTag: "dripSwitchRow")
        setDecimalRow_switch(tag: "dripTag_sasiyu", title: "差し湯の量", ph: "g", value: nil, switchTag: "dripSwitchRow")
        setTextRow_switch(tag: "dripTag_rinsu", title: "リンス有無", ph: "", value: nil, switchTag: "dripSwitchRow")
        setTextRow_switch(tag: "dripTag_paper", title: "フィルターの種類", ph: "", value: nil, switchTag: "dripSwitchRow")
        setTextRow_switch(tag: "dripTag_dorippa", title: "ドリッパーの種類", ph: "", value: nil, switchTag: "dripSwitchRow")
        setTextAreaRow_switch(tag: "dripTag_memo", title: "メモ", ph: "メモ", value: nil, switchTag: "dripSwitchRow")

        
        form
        +++ Section("挽き方")
        form.last! <<< SwitchRow { row in
            row.tag = "grindSwitchRow"
            row.title = "挽き方　プリセット ▼ "
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.onCellSelection{[unowned self] ButtonCellOf, row in
                self.modalPresentationToGrind(viewControllerName: "SelectGrindPresetVC")
            }
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
        
        setTextRow_switch(tag: "grindTag_namae", title: "名前", ph: "", value: nil, switchTag: "grindSwitchRow")
        setTextRow_switch(tag: "grindTag_hikime", title: "挽き目", ph: "", value: nil, switchTag: "grindSwitchRow")
        setTextRow_switch(tag: "grindTag_miru", title: "ミルの種類", ph: "", value: nil, switchTag: "grindSwitchRow")
        setImageRow_switch(tag: "grindTag_image1", savedImage: nil, switchTag: "grindSwitchRow")
        (form.rowBy(tag: "grindTag_image1") as! ImageRow).onChange { [unowned self] row in
            //選択した画像を消してもエラーが出ないように
            if row.value != nil {
                selectedGrindImage = row.value!
            }
        }
        setTextAreaRow_switch(tag: "grindTag_memo", title: "メモ", ph: "メモ", value: nil, switchTag: "grindSwitchRow")
    
        //初期画面でスイッチをオフで設定。以降はonChangeで管理
        form.rowBy(tag: "beanSwitchRow")?.value = false
        form.rowBy(tag: "dripSwitchRow")?.value = false
        form.rowBy(tag: "grindSwitchRow")?.value = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ソート画面で変更したキー・オーダーをユーザーデフォルトから取得
        if UserDefaults.standard.string(forKey: "reviewSortKeyName") != nil {
            keyName = UserDefaults.standard.string(forKey: "reviewSortKeyName")!
        }
        boolName = UserDefaults.standard.bool(forKey: "beanSortOrderBool")
        

    }
    
    //dismiss後、遷移元VCで、viewWillAppearが動くようにする
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
    

    //画面遷移の関数（nameはstoryboardファイル名、withIdentifierはstoryboardID）
    func modalPresentationToBean(viewControllerName: String){
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? SelectBeanPresetVC
        viewController?.delegate = self
        let nav = UINavigationController(rootViewController: viewController!)
        nav.navigationBar.backgroundColor = barColor
        self.present(nav,animated: true)
    }
    

    func modalPresentationToDrip(viewControllerName: String){
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? SelectDripPresetVC
        viewController?.delegate = self
        let nav = UINavigationController(rootViewController: viewController!)
        nav.navigationBar.backgroundColor = barColor
        self.present(nav,animated: true)
    }
    

    func modalPresentationToGrind(viewControllerName: String){
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? SelectGrindPresetVC
        viewController?.delegate = self
        let nav = UINavigationController(rootViewController: viewController!)
        nav.navigationBar.backgroundColor = barColor
        self.present(nav,animated: true)
    }

    
    @IBAction func savaButton(_ sender: Any) {
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
        
        let reviewMemos = ReviewMemo(context: self.managedObjectContext)
        let reviewImages = ReviewImage(context: self.managedObjectContext)
        
        let id = UUID().uuidString + self.getNow()
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
                reviewImages.reviewTag_image1 = image1!.reSizeImage()!.pngData()
                self.form.rowBy(tag: "reviewTag_image1")?.baseValue = nil
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            countDown = countDown + 5.0
        }
        
        let image2 = self.form.rowBy(tag: "beanTag_image1")?.baseValue as? UIImage
        if image2 != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
                reviewImages.beanTag_image1 = image2!.reSizeImage()!.pngData()
                self.form.rowBy(tag: "beanTag_image1")?.baseValue = nil
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            countDown = countDown + 5.0
        }
        
        let image3 = self.form.rowBy(tag: "grindTag_image1")?.baseValue as? UIImage
        if image3 != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
                reviewImages.grindTag_image1 = image3!.reSizeImage()!.pngData()
                self.form.rowBy(tag: "grindTag_image1")?.baseValue = nil
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            countDown = countDown + 5.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + countDown) {
            //フォームへの入力値をvalues（配列）へ格納
            let values = self.form.values()
            
            //作成日
            reviewMemos.reviewCreatedDate = now
            reviewMemos.reviewEditedDate = now
            reviewImages.reviewCreatedDate = now
            reviewImages.reviewEditedDate = now
            
            //ID関係の作成と登録
            reviewMemos.reviewId = id
            reviewImages.reviewId = id
            
            //並べ替え用　カタカナ変換
            let reviewTag_namae = values["reviewTag_namae"] as? String
            if reviewTag_namae != nil {
                reviewMemos.reviewTag_ForSortNamae = reviewTag_namae!.convertKana()
            }
            let beanTag_namae = values["beanTag_namae"] as? String
            if beanTag_namae != nil {
                reviewMemos.beanTag_ForSortNamae = beanTag_namae!.convertKana()
            }
            let dripTag_namae = values["dripTag_namae"] as? String
            if dripTag_namae != nil {
                reviewMemos.dripTag_ForSortNamae = dripTag_namae!.convertKana()
            }
            let grindTag_namae = values["grindTag_namae"] as? String
            if grindTag_namae != nil {
                reviewMemos.grindTag_ForSortNamae = grindTag_namae!.convertKana()
            }
            
            let reviewTag_hyouka = values["reviewTag_hyouka"] as? Int
            if reviewTag_hyouka != nil {
                reviewMemos.reviewTag_hyouka = Int16(reviewTag_hyouka!)
            }
            
            let reviewTag_konaryou = values["reviewTag_konaryou"] as? Double
            if reviewTag_konaryou != nil {
                reviewMemos.reviewTag_konaryou = String(reviewTag_konaryou!)
            }
            let beanTag_kakaku = values["beanTag_kakaku"] as? Int
            if beanTag_kakaku != nil {
                reviewMemos.beanTag_kakaku = String(beanTag_kakaku!)
            }
            let beanTag_kounyuuryou = values["beanTag_kounyuuryou"] as? Int
            if beanTag_kounyuuryou != nil {
                reviewMemos.beanTag_kounyuuryou = String(beanTag_kounyuuryou!)
            }
            let beanTag_hyoukou_Single = values["beanTag_hyoukou_Single"] as? Int
            if beanTag_hyoukou_Single != nil {
                reviewMemos.beanTag_hyoukou_Single = String(beanTag_hyoukou_Single!)
            }
            let beanTag_hyoukou_Blend1 = values["beanTag_hyoukou_Blend1"] as? Int
            if beanTag_hyoukou_Blend1 != nil {
                reviewMemos.beanTag_hyoukou_Blend1 = String(beanTag_hyoukou_Blend1!)
            }
            let beanTag_hyoukou_Blend2 = values["beanTag_hyoukou_Blend2"] as? Int
            if beanTag_hyoukou_Blend2 != nil {
                reviewMemos.beanTag_hyoukou_Blend2 = String(beanTag_hyoukou_Blend2!)
            }
            let beanTag_hyoukou_Blend3 = values["beanTag_hyoukou_Blend3"] as? Int
            if beanTag_hyoukou_Blend3 != nil {
                reviewMemos.beanTag_hyoukou_Blend3 = String(beanTag_hyoukou_Blend3!)
            }
            let beanTag_hyoukou_Blend4 = values["beanTag_hyoukou_Blend4"] as? Int
            if beanTag_hyoukou_Blend4 != nil {
                reviewMemos.beanTag_hyoukou_Blend4 = String(beanTag_hyoukou_Blend4!)
            }
            let beanTag_ryou_Blend1 = values["beanTag_ryou_Blend1"] as? Double
            if beanTag_ryou_Blend1 != nil {
                reviewMemos.beanTag_ryou_Blend1 = String(beanTag_ryou_Blend1!)
            }
            let beanTag_ryou_Blend2 = values["beanTag_ryou_Blend2"] as? Double
            if beanTag_ryou_Blend2 != nil {
                reviewMemos.beanTag_ryou_Blend2 = String(beanTag_ryou_Blend2!)
            }
            let beanTag_ryou_Blend3 = values["beanTag_ryou_Blend3"] as? Double
            if beanTag_ryou_Blend3 != nil {
                reviewMemos.beanTag_ryou_Blend3 = String(beanTag_ryou_Blend3!)
            }
            let beanTag_ryou_Blend4 = values["beanTag_ryou_Blend4"] as? Double
            if beanTag_ryou_Blend4 != nil {
                reviewMemos.beanTag_ryou_Blend4 = String(beanTag_ryou_Blend4!)
            }

                
            //以下、入力値の反映
            reviewMemos.reviewTag_namae = values["reviewTag_namae"] as? String
            
            reviewMemos.beanTag_namae = values["beanTag_namae"] as? String
            reviewMemos.beanTag_hanbaiten = values["beanTag_hanbaiten"] as? String
            reviewMemos.beanTag_keisiki = values["beanTag_keisiki"] as? String
            reviewMemos.beanTag_kaori = values["beanTag_kaori"] as? String
            
            reviewMemos.beanTag_seisannkoku_Single = values["beanTag_seisannkoku_Single"] as? String
            reviewMemos.beanTag_tiiki_Single = values["beanTag_tiiki_Single"] as? String
            reviewMemos.beanTag_nouennmei_Single = values["beanTag_nouennmei_Single"] as? String
            reviewMemos.beanTag_seisannsya_Single = values["beanTag_seisannsya_Single"] as? String
            reviewMemos.beanTag_hinnsyu_Single = values["beanTag_hinnsyu_Single"] as? String
            reviewMemos.beanTag_seiseihouhou_Single = values["beanTag_seiseihouhou_Single"] as? String
            reviewMemos.beanTag_baisenndo_Single = values["beanTag_baisenndo_Single"] as? String
            
            reviewMemos.beanTag_seisannkoku_Blend1 = values["beanTag_seisannkoku_Blend1"] as? String
            reviewMemos.beanTag_tiiki_Blend1 = values["beanTag_tiiki_Blend1"] as? String
            reviewMemos.beanTag_nouennmei_Blend1 = values["beanTag_nouennmei_Blend1"] as? String
            reviewMemos.beanTag_seisannsya_Blend1 = values["beanTag_seisannsya_Blend1"] as? String
            reviewMemos.beanTag_hinnsyu_Blend1 = values["beanTag_hinnsyu_Blend1"] as? String
            reviewMemos.beanTag_seiseihouhou_Blend1 = values["beanTag_seiseihouhou_Blend1"] as? String
            reviewMemos.beanTag_baisenndo_Blend1 = values["beanTag_baisenndo_Blend1"] as? String

            reviewMemos.beanTag_seisannkoku_Blend2 = values["beanTag_seisannkoku_Blend2"] as? String
            reviewMemos.beanTag_tiiki_Blend2 = values["beanTag_tiiki_Blend2"] as? String
            reviewMemos.beanTag_nouennmei_Blend2 = values["beanTag_nouennmei_Blend2"] as? String
            reviewMemos.beanTag_seisannsya_Blend2 = values["beanTag_seisannsya_Blend2"] as? String
            reviewMemos.beanTag_hinnsyu_Blend2 = values["beanTag_hinnsyu_Blend2"] as? String
            reviewMemos.beanTag_seiseihouhou_Blend2 = values["beanTag_seiseihouhou_Blend2"] as? String
            reviewMemos.beanTag_baisenndo_Blend2 = values["beanTag_baisenndo_Blend2"] as? String
            
            reviewMemos.beanTag_seisannkoku_Blend3 = values["beanTag_seisannkoku_Blend3"] as? String
            reviewMemos.beanTag_tiiki_Blend3 = values["beanTag_tiiki_Blend3"] as? String
            reviewMemos.beanTag_nouennmei_Blend3 = values["beanTag_nouennmei_Blend3"] as? String
            reviewMemos.beanTag_seisannsya_Blend3 = values["beanTag_seisannsya_Blend3"] as? String
            reviewMemos.beanTag_hinnsyu_Blend3 = values["beanTag_hinnsyu_Blend3"] as? String
            reviewMemos.beanTag_seiseihouhou_Blend3 = values["beanTag_seiseihouhou_Blend3"] as? String
            reviewMemos.beanTag_baisenndo_Blend3 = values["beanTag_baisenndo_Blend3"] as? String
            
            reviewMemos.beanTag_seisannkoku_Blend4 = values["beanTag_seisannkoku_Blend4"] as? String
            reviewMemos.beanTag_tiiki_Blend4 = values["beanTag_tiiki_Blend4"] as? String
            reviewMemos.beanTag_nouennmei_Blend4 = values["beanTag_nouennmei_Blend4"] as? String
            reviewMemos.beanTag_seisannsya_Blend4 = values["beanTag_seisannsya_Blend4"] as? String
            reviewMemos.beanTag_hinnsyu_Blend4 = values["beanTag_hinnsyu_Blend4"] as? String
            reviewMemos.beanTag_seiseihouhou_Blend4 = values["beanTag_seiseihouhou_Blend4"] as? String
            reviewMemos.beanTag_baisenndo_Blend4 = values["beanTag_baisenndo_Blend4"] as? String
            
            //DateRowの情報
            reviewMemos.beanTag_kounyuubi = values["beanTag_kounyuubi"] as? Date
            reviewMemos.beanTag_baisenbi_Single = values["beanTag_baisenbi_Single"] as? Date
            reviewMemos.beanTag_baisenbi_Blend1 = values["beanTag_baisenbi_Blend1"] as? Date
            reviewMemos.beanTag_baisenbi_Blend2 = values["beanTag_baisenbi_Blend2"] as? Date
            reviewMemos.beanTag_baisenbi_Blend3 = values["beanTag_baisenbi_Blend3"] as? Date
            reviewMemos.beanTag_baisenbi_Blend4 = values["beanTag_baisenbi_Blend4"] as? Date
            
            
            
            let dripTag_ondo = values["dripTag_ondo"] as? Double
            if dripTag_ondo != nil {
                reviewMemos.dripTag_ondo = String(dripTag_ondo!)
            }
            let dripTag_ryou = values["dripTag_ryou"] as? Double
            if dripTag_ryou != nil {
                reviewMemos.dripTag_ryou = String(dripTag_ryou!)
            }
            let dripTag_sasiyu = values["dripTag_sasiyu"] as? Double
            if dripTag_sasiyu != nil {
                reviewMemos.dripTag_sasiyu = String(dripTag_sasiyu!)
            }
            //DoublePickerInputRowがタプル構造体での形式のため、form.values()ではなく直接取得
            let murasiRow = self.form.rowBy(tag: "dripTag_murasijikann") as! DoublePickerInputRow<String, String>
            if murasiRow.value != nil {
                let murasiValue = murasiRow.value!
                reviewMemos.dripTag_murasijikann_minutes = murasiValue.a
                reviewMemos.dripTag_murasijikann_seconds = murasiValue.b
            }
            let tyuusyutuRow = self.form.rowBy(tag: "dripTag_tyuusyutujikann") as! DoublePickerInputRow<String, String>
            if tyuusyutuRow.value != nil {
                let tyuusyutuValue = tyuusyutuRow.value!
                reviewMemos.dripTag_tyuusyutujikann_minutes = tyuusyutuValue.a
                reviewMemos.dripTag_tyuusyutujikann_seconds = tyuusyutuValue.b
            }
            reviewMemos.dripTag_namae = values["dripTag_namae"] as? String
            reviewMemos.dripTag_rinsu = values["dripTag_rinsu"] as? String
            reviewMemos.dripTag_paper = values["dripTag_paper"] as? String
            reviewMemos.dripTag_dorippa = values["dripTag_dorippa"] as? String
            
            reviewMemos.grindTag_namae = values["grindTag_namae"] as? String
            reviewMemos.grindTag_hikime = values["grindTag_hikime"] as? String
            reviewMemos.grindTag_miru = values["grindTag_miru"] as? String
            
            //メモの情報
            reviewMemos.beanTag_memo = values["beanTag_memo"] as? String
            reviewMemos.dripTag_memo = values["dripTag_memo"] as? String
            reviewMemos.grindTag_memo = values["grindTag_memo"] as? String
            reviewMemos.reviewTag_memo = values["reviewTag_memo"] as? String
            
            //保存後の最表示のために、シングル・ブレンドのステータスを格納しておく
            reviewMemos.beanStatus = values["segments"] as? String
            
            //saveContextは現在のマネージドオブジェクトの変更内容をDBに反映する
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            //初期画面でスイッチをオフで設定。以降はonChangeで管理
            self.form.rowBy(tag: "beanSwitchRow")?.value = false
            self.form.rowBy(tag: "dripSwitchRow")?.value = false
            self.form.rowBy(tag: "grindSwitchRow")?.value = false
            
            //インジケータの非表示
            SVProgressHUD.dismiss()
            //完了メッセージ
            self.doneMessageDismiss()
        }
    }
    
}

extension NewReviewVC: SendBeanDelegate {
    func sendBeanValue(id: String?) {
        beanMemos = getBeanMemoId(moc: managedObjectContext, beanId: id!)
        beanImages = getBeanImageId(moc: managedObjectContext, beanId: id!)
        
        if beanMemos[0].beanStatus != nil {
            beanStatus = beanMemos[0].beanStatus!
            self.form.rowBy(tag: "segments")?.value = beanStatus
        }
        
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
        
        form.rowBy(tag: "beanSwitchRow")?.title = beanMemos[0].beanTag_namae
        form.rowBy(tag: "beanTag_namae")?.value = beanMemos[0].beanTag_namae
        form.rowBy(tag: "beanTag_hanbaiten")?.value = beanMemos[0].beanTag_hanbaiten
        form.rowBy(tag: "beanTag_keisiki")?.value = beanMemos[0].beanTag_keisiki
        form.rowBy(tag: "beanTag_kakaku")?.value = beanTag_kakaku
        form.rowBy(tag: "beanTag_kounyuuryou")?.value = beanTag_kounyuuryou
        form.rowBy(tag: "beanTag_kaori")?.value = beanMemos[0].beanTag_kaori
        form.rowBy(tag: "beanTag_kounyuubi")?.value = beanMemos[0].beanTag_kounyuubi

        form.rowBy(tag: "beanTag_seisannkoku_Single")?.value = beanMemos[0].beanTag_seisannkoku_Single
        form.rowBy(tag: "beanTag_tiiki_Single")?.value = beanMemos[0].beanTag_tiiki_Single
        form.rowBy(tag: "beanTag_nouennmei_Single")?.value = beanMemos[0].beanTag_nouennmei_Single
        form.rowBy(tag: "beanTag_seisannsya_Single")?.value = beanMemos[0].beanTag_seisannsya_Single
        form.rowBy(tag: "beanTag_hinnsyu_Single")?.value = beanMemos[0].beanTag_hinnsyu_Single
        form.rowBy(tag: "beanTag_hyoukou_Single")?.value = beanTag_hyoukou_Single
        form.rowBy(tag: "beanTag_seiseihouhou_Single")?.value = beanMemos[0].beanTag_seiseihouhou_Single
        form.rowBy(tag: "beanTag_baisenndo_Single")?.value = beanMemos[0].beanTag_baisenndo_Single
        form.rowBy(tag: "beanTag_baisenbi_Single")?.value = beanMemos[0].beanTag_baisenbi_Single

        form.rowBy(tag: "beanTag_seisannkoku_Blend1")?.value = beanMemos[0].beanTag_seisannkoku_Blend1
        form.rowBy(tag: "beanTag_tiiki_Blend1")?.value = beanMemos[0].beanTag_tiiki_Blend1
        form.rowBy(tag: "beanTag_nouennmei_Blend1")?.value = beanMemos[0].beanTag_nouennmei_Blend1
        form.rowBy(tag: "beanTag_seisannsya_Blend1")?.value = beanMemos[0].beanTag_seisannsya_Blend1
        form.rowBy(tag: "beanTag_hinnsyu_Blend1")?.value = beanMemos[0].beanTag_hinnsyu_Blend1
        form.rowBy(tag: "beanTag_hyoukou_Blend1")?.value = beanTag_hyoukou_Blend1
        form.rowBy(tag: "beanTag_seiseihouhou_Blend1")?.value = beanMemos[0].beanTag_seiseihouhou_Blend1
        form.rowBy(tag: "beanTag_baisenndo_Blend1")?.value = beanMemos[0].beanTag_baisenndo_Blend1
        form.rowBy(tag: "beanTag_ryou_Blend1")?.value = beanTag_ryou_Blend1
        form.rowBy(tag: "beanTag_baisenbi_Blend1")?.value = beanMemos[0].beanTag_baisenbi_Blend1

        form.rowBy(tag: "beanTag_seisannkoku_Blend2")?.value = beanMemos[0].beanTag_seisannkoku_Blend2
        form.rowBy(tag: "beanTag_tiiki_Blend2")?.value = beanMemos[0].beanTag_tiiki_Blend2
        form.rowBy(tag: "beanTag_nouennmei_Blend2")?.value = beanMemos[0].beanTag_nouennmei_Blend2
        form.rowBy(tag: "beanTag_seisannsya_Blend2")?.value = beanMemos[0].beanTag_seisannsya_Blend2
        form.rowBy(tag: "beanTag_hinnsyu_Blend2")?.value = beanMemos[0].beanTag_hinnsyu_Blend2
        form.rowBy(tag: "beanTag_hyoukou_Blend2")?.value = beanTag_hyoukou_Blend2
        form.rowBy(tag: "beanTag_seiseihouhou_Blend2")?.value = beanMemos[0].beanTag_seiseihouhou_Blend2
        form.rowBy(tag: "beanTag_baisenndo_Blend2")?.value = beanMemos[0].beanTag_baisenndo_Blend2
        form.rowBy(tag: "beanTag_ryou_Blend2")?.value = beanTag_ryou_Blend2
        form.rowBy(tag: "beanTag_baisenbi_Blend2")?.value = beanMemos[0].beanTag_baisenbi_Blend2

        form.rowBy(tag: "beanTag_seisannkoku_Blend3")?.value = beanMemos[0].beanTag_seisannkoku_Blend3
        form.rowBy(tag: "beanTag_tiiki_Blend3")?.value = beanMemos[0].beanTag_tiiki_Blend3
        form.rowBy(tag: "beanTag_nouennmei_Blend3")?.value = beanMemos[0].beanTag_nouennmei_Blend3
        form.rowBy(tag: "beanTag_seisannsya_Blend3")?.value = beanMemos[0].beanTag_seisannsya_Blend3
        form.rowBy(tag: "beanTag_hinnsyu_Blend3")?.value = beanMemos[0].beanTag_hinnsyu_Blend3
        form.rowBy(tag: "beanTag_hyoukou_Blend3")?.value = beanTag_hyoukou_Blend3
        form.rowBy(tag: "beanTag_seiseihouhou_Blend3")?.value = beanMemos[0].beanTag_seiseihouhou_Blend3
        form.rowBy(tag: "beanTag_baisenndo_Blend3")?.value = beanMemos[0].beanTag_baisenndo_Blend3
        form.rowBy(tag: "beanTag_ryou_Blend3")?.value = beanTag_ryou_Blend3
        form.rowBy(tag: "beanTag_baisenbi_Blend3")?.value = beanMemos[0].beanTag_baisenbi_Blend3
    
        form.rowBy(tag: "beanTag_seisannkoku_Blend4")?.value = beanMemos[0].beanTag_seisannkoku_Blend4
        form.rowBy(tag: "beanTag_tiiki_Blend4")?.value = beanMemos[0].beanTag_tiiki_Blend4
        form.rowBy(tag: "beanTag_nouennmei_Blend4")?.value = beanMemos[0].beanTag_nouennmei_Blend4
        form.rowBy(tag: "beanTag_seisannsya_Blend4")?.value = beanMemos[0].beanTag_seisannsya_Blend4
        form.rowBy(tag: "beanTag_hinnsyu_Blend4")?.value = beanMemos[0].beanTag_hinnsyu_Blend4
        form.rowBy(tag: "beanTag_hyoukou_Blend4")?.value = beanTag_hyoukou_Blend4
        form.rowBy(tag: "beanTag_seiseihouhou_Blend4")?.value = beanMemos[0].beanTag_seiseihouhou_Blend4
        form.rowBy(tag: "beanTag_baisenndo_Blend4")?.value = beanMemos[0].beanTag_baisenndo_Blend4
        form.rowBy(tag: "beanTag_ryou_Blend4")?.value = beanTag_ryou_Blend4
        form.rowBy(tag: "beanTag_baisenbi_Blend4")?.value = beanMemos[0].beanTag_baisenbi_Blend4
        
        form.rowBy(tag: "beanTag_memo")?.value = beanMemos[0].beanTag_memo

        let savedImage = beanImages[0].beanTag_image1
        if savedImage != nil {
            form.rowBy(tag: "beanTag_image1")?.value = UIImage(data: savedImage!)
        }else{
            form.rowBy(tag: "beanTag_image1")?.baseValue = nil
        }
        
        
        let commonSection_1 = [
            self.form.sectionBy(tag: "common_bean"),
            self.form.sectionBy(tag: "memo_bean")
        ]
        let singleSection_1 = [
            self.form.sectionBy(tag: "single")
        ]
        let blendSection_1 = [
            self.form.sectionBy(tag: "blend1"),
            self.form.sectionBy(tag: "blend2"),
            self.form.sectionBy(tag: "blend3"),
            self.form.sectionBy(tag: "blend4")
        ]
        //スイッチ　オンの場合の処理
        if (self.form.rowBy(tag: "beanSwitchRow")?.baseValue as? Bool)! {
            //シングル・ブレンドの条件分岐
            if self.beanStatus == "シングル" {
                commonSection_1.forEach {
                    $0?.hidden = false
                    $0?.evaluateHidden()
                }
                singleSection_1.forEach {
                    $0?.hidden = false
                    $0?.evaluateHidden()
                }
                blendSection_1.forEach {
                    $0?.hidden = true
                    $0?.evaluateHidden()
                }

            }else{
                commonSection_1.forEach {
                    $0?.hidden = false
                    $0?.evaluateHidden()
                }
                singleSection_1.forEach {
                    $0?.hidden = true
                    $0?.evaluateHidden()
                }
                blendSection_1.forEach {
                    $0?.hidden = false
                    $0?.evaluateHidden()
                }

            }
        //スイッチ　オフの場合の処理
        }else{
            commonSection_1.forEach {
                $0?.hidden = true
                $0?.evaluateHidden()
            }
            singleSection_1.forEach {
                $0?.hidden = true
                $0?.evaluateHidden()
            }
            blendSection_1.forEach {
                $0?.hidden = true
                $0?.evaluateHidden()
            }
            
        }
        
    }
}

extension NewReviewVC: SendDripDelegate {
    func sendDripValue(id: String?) {
        dripMemos = getDripMemoId(moc: managedObjectContext, dripId: id!)
        
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
        
        form.rowBy(tag: "dripSwitchRow")?.title = dripMemos[0].dripTag_namae
        form.rowBy(tag: "dripTag_namae")?.value = dripMemos[0].dripTag_namae
        form.rowBy(tag: "dripTag_ondo")?.value = dripTag_ondo
        form.rowBy(tag: "dripTag_ryou")?.value = dripTag_ryou
        form.rowBy(tag: "dripTag_tyuusyutujikann")?.value = tyuusyutuValue
        form.rowBy(tag: "dripTag_murasijikann")?.value = murasiValue
        form.rowBy(tag: "dripTag_sasiyu")?.value = dripTag_sasiyu
        form.rowBy(tag: "dripTag_rinsu")?.value = dripMemos[0].dripTag_rinsu
        form.rowBy(tag: "dripTag_paper")?.value = dripMemos[0].dripTag_paper
        form.rowBy(tag: "dripTag_dorippa")?.value = dripMemos[0].dripTag_dorippa
        form.rowBy(tag: "dripTag_memo")?.value = dripMemos[0].dripTag_memo
    }
}

extension NewReviewVC: SendGrindDelegate {
    func sendGrindValue(id: String?) {
        grindMemos = getGrindMemoId(moc: managedObjectContext, grindId: id!)
        grindImages = getGrindImageId(moc: managedObjectContext, grindId: id!)
        
        form.rowBy(tag: "grindSwitchRow")?.title = grindMemos[0].grindTag_namae
        form.rowBy(tag: "grindTag_namae")?.value = grindMemos[0].grindTag_namae
        form.rowBy(tag: "grindTag_hikime")?.value = grindMemos[0].grindTag_hikime
        form.rowBy(tag: "grindTag_miru")?.value = grindMemos[0].grindTag_miru
        form.rowBy(tag: "grindTag_memo")?.value = grindMemos[0].grindTag_memo
        
        let savedImage = grindImages[0].grindImage1
        if savedImage != nil {
            form.rowBy(tag: "grindTag_image1")?.value = UIImage(data: savedImage!)
        }else{
            form.rowBy(tag: "grindTag_image1")?.baseValue = nil
        }
        

    }
}



