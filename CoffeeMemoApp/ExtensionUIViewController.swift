//
//  ExtensionUIView.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/07/21.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    
    func getNow() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        guard let formatString = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        else { fatalError() }
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: now)
    }
    
    func errorMessageName() {
        let errorAlert = UIAlertController(title: "エラー", message: "名前は必須事項です", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func doneMessageToRoot() {
        let alert = UIAlertController(title: "保存できました", message: "正常に保存が完了しました", preferredStyle: .alert)
        let okTimeAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:{(action: UIAlertAction!) in DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        alert.addAction(okTimeAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    func doneMessageDismiss() {
        let alert = UIAlertController(title: "保存できました", message: "正常に保存が完了しました", preferredStyle: .alert)
        let okTimeAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:{(action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okTimeAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    //UIMenu機能搭載BarBttonItemの作成
    func setRightBarButton_2items(viewController: UIViewController) {
        //Menu 1
        let select = UIAction(title: "選択", image: UIImage(systemName: "checkmark.circle")) { (action) in
            print("編集モード開始")
            self.navigationItem.rightBarButtonItem = self.editButtonItem
            //編集モードへの突入(editng、.isEditingをtrueにしている)
            self.setEditing(_: true, animated: true)
        }
        //Menu 2
        let sort = UIAction(title: "並び替え", image: UIImage(systemName: "list.dash")) { (action) in
            print("並び替えへ遷移")
            self.halfModal(viewController: viewController)
        }
        let menu = UIMenu(title: "", children: [select, sort])
        let menuBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.rightBarButtonItem = menuBarItem
    }

    //並び替え画面への遷移
    func halfModal(viewController: UIViewController) {
        /* ここが実装のキモ */
        if let sheet = viewController.sheetPresentationController {
            // ここで指定したサイズで表示される
            sheet.detents = [.medium()]
        }
        present(viewController, animated: true, completion: nil)
    }
    
    //閉じるボタン
    func setLeftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "閉じる", style: .done, target: self, action: #selector(leftButtonPressed(_:)))
        navigationItem.leftBarButtonItem?.tintColor = textColor
    }
    @objc func leftButtonPressed(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    //UIMenu機能搭載BarBttonItemの作成
    func setPlusButton(button: UIButton) {
        //Menu 1
        let review = UIAction(title: "レビュー", image: UIImage(systemName: "book")) { (action) in
            self.plusButtonAction(viewControllerName: "NewReviewVC")
        }
        //Menu 2
        let bean = UIAction(title: "コーヒー豆", image: UIImage(systemName: "oval.portrait")) { (action) in
            self.plusButtonAction(viewControllerName: "NewBeanVC")
        }
        //Menu 3
        let drip = UIAction(title: "抽出方法", image: UIImage(systemName: "drop")) { (action) in
            self.plusButtonAction(viewControllerName: "NewDripVC")
        }
        //Menu 4
        let grind = UIAction(title: "挽き方", image: UIImage(systemName: "aqi.low")) { (action) in
            self.plusButtonAction(viewControllerName: "NewGrindVC")
        }
        //Menuの反映
        button.menu = UIMenu(title: "", children: [grind, drip, bean, review])
        // こちらを書かないと表示できない場合があるので注意
        button.showsMenuAsPrimaryAction = true
        
        //これ以下、ボタンの見た目・位置・アクション
        // 必ずfalseにする（理由は後述）
        button.translatesAutoresizingMaskIntoConstraints = false
        // 文字の色
        button.tintColor = UIColor.black
        // 背景の色
        button.backgroundColor = yellowButtonColor
        // 正円にする
        button.layer.cornerRadius = 25
        // plustButtonのImageをplus（+）に設定する
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        // ViewにplusButtonを設置する（必ず制約を設定する前に記述する）
        self.view.addSubview(button)
        // 以下のコードから制約を設定している
        // plustButtonの下端をViewの下端から-50pt（=上に50pt）
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        // plustButtonの右端をViewの右端から-30pt（=左に30pt）
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        // plustButtonの幅を50にする
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // plusButtonの高さを50にする
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //画面遷移の関数（nameはstoryboardファイル名、withIdentifierはstoryboardID）
    func plusButtonAction(viewControllerName: String){
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName)
        let nav = UINavigationController(rootViewController: viewController)
        nav.navigationBar.backgroundColor = barColor
        self.present(nav,animated: true)
    }
    

    func getBeanMemo(moc: NSManagedObjectContext, keyName: String, boolName: Bool) -> [BeanMemo]{
        var beanMemos:[BeanMemo] = []
        let fetchRequest = NSFetchRequest<BeanMemo>(entityName: "BeanMemo")
        //取得データの順序変更（アトリビュート・昇降を指定）
        //ascending: true 昇順、false 降順
        let sortDescripter = NSSortDescriptor(key: "\(keyName)", ascending: boolName)
        fetchRequest.sortDescriptors = [sortDescripter]
        do{
            beanMemos = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return beanMemos
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getBeanMemoId(moc: NSManagedObjectContext, beanId: String) -> [BeanMemo]{
        var beanMemos:[BeanMemo] = []
        let fetchRequest = NSFetchRequest<BeanMemo>(entityName: "BeanMemo")
        fetchRequest.predicate = NSPredicate(format: "beanId == %@", beanId)
        do{
            //予め作っておいた、beanMemosへ格納する
            beanMemos = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return beanMemos
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getBeanImageId(moc: NSManagedObjectContext, beanId: String) -> [BeanImage]{
        var beanImages:[BeanImage] = []
        let fetchRequest = NSFetchRequest<BeanImage>(entityName: "BeanImage")
        fetchRequest.predicate = NSPredicate(format: "beanId == %@", beanId)
        do{
            beanImages = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return beanImages
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getBeanMemoFiltered(moc: NSManagedObjectContext, text: String) -> [BeanMemo]{
        var beanMemosFiltered:[BeanMemo] = []
        let kanaText = text.convertKana()!
        let fetchRequest = NSFetchRequest<BeanMemo>(entityName: "BeanMemo")
        let titlePredicate: NSPredicate = NSPredicate(format: "beanTag_namae CONTAINS[c] %@", text)
        let sortedPredicate: NSPredicate = NSPredicate(format: "beanTag_ForSortNamae CONTAINS[c] %@", kanaText)
        let statusPredicate: NSPredicate = NSPredicate(format: "beanStatus CONTAINS[c] %@", kanaText)
        let memoPredicate: NSPredicate = NSPredicate(format: "beanTag_memo CONTAINS[c] %@", text)
        let datePredicate: NSPredicate = NSPredicate(format: "beanEditedDate CONTAINS[c] %@", text)
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates:
            [titlePredicate,sortedPredicate,statusPredicate,memoPredicate,datePredicate])
        do{
            beanMemosFiltered = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return beanMemosFiltered
    }
    
    
    func getDripMemo(moc: NSManagedObjectContext, keyName: String, boolName: Bool) -> [DripMemo]{
        var dripMemos:[DripMemo] = []
        let fetchRequest = NSFetchRequest<DripMemo>(entityName: "DripMemo")
        //取得データの順序変更（アトリビュート・昇降を指定）
        //ascending: true 昇順、false 降順
        let sortDescripter = NSSortDescriptor(key: "\(keyName)", ascending: boolName)
        fetchRequest.sortDescriptors = [sortDescripter]
        do{
            dripMemos = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return dripMemos
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getDripMemoId(moc: NSManagedObjectContext, dripId: String) -> [DripMemo] {
        var dripMemos:[DripMemo] = []
        let fetchRequest = NSFetchRequest<DripMemo>(entityName: "DripMemo")
        fetchRequest.predicate = NSPredicate(format: "dripId == %@", dripId)
        do{
            //予め作っておいた、dripMemosへ格納する
            dripMemos = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return dripMemos
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getDripMemoFiltered(moc: NSManagedObjectContext, text: String) -> [DripMemo] {
        var dripMemosFiltered :[DripMemo] = []
        let kanaText = text.convertKana()!
        let fetchRequest = NSFetchRequest<DripMemo>(entityName: "DripMemo")
        let titlePredicate: NSPredicate = NSPredicate(format: "dripTag_namae CONTAINS[c] %@", text)
        let sortedPredicate: NSPredicate = NSPredicate(format: "dripTag_ForSortNamae CONTAINS[c] %@", kanaText)
        let memoPredicate: NSPredicate = NSPredicate(format: "dripTag_memo CONTAINS[c] %@", text)
        let datePredicate: NSPredicate = NSPredicate(format: "dripEditedDate CONTAINS[c] %@", text)
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates:
            [titlePredicate, sortedPredicate, memoPredicate, datePredicate]
        )
        do{
            dripMemosFiltered = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return dripMemosFiltered
    }
    
    
    
    
    func getGrindMemo(moc: NSManagedObjectContext, keyName: String, boolName: Bool) -> [GrindMemo] {
        var grindMemos:[GrindMemo] = []
        let fetchRequest = NSFetchRequest<GrindMemo>(entityName: "GrindMemo")
        //取得データの順序変更（アトリビュート・昇降を指定）
        //ascending: true 昇順、false 降順
        let sortDescripter = NSSortDescriptor(key: "\(keyName)", ascending: boolName)
        fetchRequest.sortDescriptors = [sortDescripter]
        do{
            grindMemos = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return grindMemos
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getGrindMemoId(moc: NSManagedObjectContext, grindId: String) -> [GrindMemo]{
        var grindMemos:[GrindMemo] = []
        let fetchRequest = NSFetchRequest<GrindMemo>(entityName: "GrindMemo")
        fetchRequest.predicate = NSPredicate(format: "grindId == %@", grindId)
        do{
            //予め作っておいた、grindMemosへ格納する
            grindMemos = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return grindMemos
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getGrindImageId(moc: NSManagedObjectContext, grindId: String) -> [GrindImage]{
        var grindImages:[GrindImage] = []
        let fetchRequest = NSFetchRequest<GrindImage>(entityName: "GrindImage")
        fetchRequest.predicate = NSPredicate(format: "grindId == %@", grindId)
        do{
            grindImages = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return grindImages
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getGrindMemoFiltered(moc: NSManagedObjectContext, text: String) -> [GrindMemo]{
        var grindMemosFiltered :[GrindMemo] = []
        let kanaText = text.convertKana()!
        let fetchRequest = NSFetchRequest<GrindMemo>(entityName: "GrindMemo")
        let titlePredicate: NSPredicate = NSPredicate(format: "grindTag_namae CONTAINS[c] %@", text)
        let sortedPredicate: NSPredicate = NSPredicate(format: "grindTag_ForSortNamae CONTAINS[c] %@", kanaText)
        let memoPredicate: NSPredicate = NSPredicate(format: "grindTag_memo CONTAINS[c] %@", text)
        let datePredicate: NSPredicate = NSPredicate(format: "grindEditedDate CONTAINS[c] %@", text)
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates:
            [titlePredicate, sortedPredicate, memoPredicate, datePredicate])
        do{
            grindMemosFiltered = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return grindMemosFiltered
    }
    
    func getReviewMemo(moc: NSManagedObjectContext, keyName: String, boolName: Bool) -> [ReviewMemo] {
        var reviewMemos:[ReviewMemo] = []
        let fetchRequest = NSFetchRequest<ReviewMemo>(entityName: "ReviewMemo")
        //取得データの順序変更（アトリビュート・昇降を指定）
        //ascending: true 昇順、false 降順
        let sortDescripter = NSSortDescriptor(key: "\(keyName)", ascending: boolName)
        fetchRequest.sortDescriptors = [sortDescripter]
        do{
            reviewMemos = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return reviewMemos
    }
    
    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getReviewMemoId(moc: NSManagedObjectContext, reviewId: String) -> [ReviewMemo]{
        var reviewMemos:[ReviewMemo] = []
        let fetchRequest = NSFetchRequest<ReviewMemo>(entityName: "ReviewMemo")
        fetchRequest.predicate = NSPredicate(format: "reviewId == %@", reviewId)
        do{
            //予め作っておいた、beanMemosへ格納する
            reviewMemos = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return reviewMemos
    }

    //CoreDataの取得を行う関数（IDで検索をかけて、１データのみを取得するバージョン）
    func getReviewImageId(moc: NSManagedObjectContext, reviewId: String) -> [ReviewImage] {
        var reviewImages:[ReviewImage] = []
        let fetchRequest = NSFetchRequest<ReviewImage>(entityName: "ReviewImage")
        fetchRequest.predicate = NSPredicate(format: "reviewId == %@", reviewId)
        do{
            reviewImages = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return reviewImages
    }
    
    //CoreDataの取得を行う関数（検索機能使用時のフェッチリクエスト）
    func getReviewMemoFiltered(moc: NSManagedObjectContext, text: String) -> [ReviewMemo] {
        var reviewMemosFiltered :[ReviewMemo] = []
        let kanaText = text.convertKana()!
        let fetchRequest = NSFetchRequest<ReviewMemo>(entityName: "ReviewMemo")
        let reviewTitlePredicate: NSPredicate = NSPredicate(format: "reviewTag_namae CONTAINS[c] %@", text)
        let beanTitlePredicate: NSPredicate = NSPredicate(format: "beanTag_namae CONTAINS[c] %@", text)
        let dripTitlePredicate: NSPredicate = NSPredicate(format: "dripTag_namae CONTAINS[c] %@", text)
        let grindTitlePredicate: NSPredicate = NSPredicate(format: "grindTag_namae CONTAINS[c] %@", text)
        let reviewSortedPredicate: NSPredicate = NSPredicate(format: "reviewTag_ForSortNamae CONTAINS[c] %@", kanaText)
        let beanSortedPredicate: NSPredicate = NSPredicate(format: "beanTag_ForSortNamae CONTAINS[c] %@", kanaText)
        let dripSortedPredicate: NSPredicate = NSPredicate(format: "dripTag_ForSortNamae CONTAINS[c] %@", kanaText)
        let grindSortedPredicate: NSPredicate = NSPredicate(format: "grindTag_ForSortNamae CONTAINS[c] %@", kanaText)
        let datePredicate: NSPredicate = NSPredicate(format: "reviewEditedDate CONTAINS[c] %@", text)
        let reviewMemoPredicate: NSPredicate = NSPredicate(format: "reviewTag_memo CONTAINS[c] %@", text)
        let beanMemoPredicate: NSPredicate = NSPredicate(format: "beanTag_memo CONTAINS[c] %@", text)
        let dripMemoPredicate: NSPredicate = NSPredicate(format: "dripTag_memo CONTAINS[c] %@", text)
        let grindMemoPredicate: NSPredicate = NSPredicate(format: "grindTag_memo CONTAINS[c] %@", text)
        
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates:[
            reviewTitlePredicate, beanTitlePredicate, dripTitlePredicate, grindTitlePredicate,
            reviewSortedPredicate, beanSortedPredicate, dripSortedPredicate, grindSortedPredicate,
            datePredicate,
            reviewMemoPredicate, beanMemoPredicate, dripMemoPredicate, grindMemoPredicate
        ])
        do{
            reviewMemosFiltered = try moc.fetch(fetchRequest)
        }catch{
            print("エラーだよ")
        }
        return reviewMemosFiltered
    }
    
    
}
