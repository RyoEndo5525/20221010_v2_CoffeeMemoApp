//
//  ExtensionFormViewController.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/07/21.
//

import Foundation
import UIKit
import Eureka
import ImageRow
import ViewRow


extension FormViewController {

    func setSegmentedSection(){
        form
        +++ SegmentedRow<String> { row in
            row.tag = "segments"
            row.options = ["シングル", "ブレンド"]
            row.value = "シングル"
            row.cell.backgroundColor = contentBackgroundColor
        }
        .onChange { row in
            let singleSection = [
                self.form.sectionBy(tag: "single")
            ]
            let blendSection = [
                self.form.sectionBy(tag: "blend1"),
                self.form.sectionBy(tag: "blend2"),
                self.form.sectionBy(tag: "blend3"),
                self.form.sectionBy(tag: "blend4")
            ]
            if row.value == "シングル" {
                singleSection.forEach {
                    $0?.hidden = false
                    $0?.evaluateHidden()
                }
                blendSection.forEach {
                    $0?.hidden = true
                    $0?.evaluateHidden()
                }
            }else{
                singleSection.forEach {
                    $0?.hidden = true
                    $0?.evaluateHidden()
                }
                blendSection.forEach {
                    $0?.hidden = false
                    $0?.evaluateHidden()
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func setSegmentedRow(){
        form.last! <<< SegmentedRow<String> { row in
            row.tag = "segments"
            row.options = ["シングル", "ブレンド"]
            row.value = "シングル"
            row.cell.backgroundColor = contentBackgroundColor
            row.hidden = Condition.function(["beanSwitchRow"], { form in
                return !((form.rowBy(tag: "beanSwitchRow") as? SwitchRow)?.value ?? false)
            })
        }
        .onChange { row in
            let singleSection = [
                self.form.sectionBy(tag: "single")
            ]
            let blendSection = [
                self.form.sectionBy(tag: "blend1"),
                self.form.sectionBy(tag: "blend2"),
                self.form.sectionBy(tag: "blend3"),
                self.form.sectionBy(tag: "blend4")
            ]
            if row.value == "シングル" {
                singleSection.forEach {
                    $0?.hidden = false
                    $0?.evaluateHidden()
                }
                blendSection.forEach {
                    $0?.hidden = true
                    $0?.evaluateHidden()
                }
            }else{
                singleSection.forEach {
                    $0?.hidden = true
                    $0?.evaluateHidden()
                }
                blendSection.forEach {
                    $0?.hidden = false
                    $0?.evaluateHidden()
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    func setTextRow(tag: String, title: String, ph: String, value: String?){
        form.last! <<< TextRow { row in
            row.tag = tag
            row.title = title
            row.placeholder = ph
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }
    }
    
    func setTextRow_switch(tag: String, title: String, ph: String, value: String?, switchTag: String){
        form.last! <<< TextRow { row in
            row.tag = tag
            row.title = title
            row.placeholder = ph
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
        }
    }
    
    func setDateRow(tag: String, title: String, value: Date?){
        form.last! <<< DateRow { row in
            row.tag = tag
            row.title = title
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }.cellUpdate { cell, _ in
            cell.detailTextLabel?.textColor = textColor
        }
    }

    func setDateRow_switch(tag: String, title: String, value: Date?, switchTag: String){
        form.last! <<< DateRow { row in
            row.tag = tag
            row.title = title
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
        }.cellUpdate { cell, _ in
            cell.detailTextLabel?.textColor = textColor
        }
    }
    
    
    
    func setIntRow(tag: String, title: String, ph: String, value: Int?){
        form.last! <<< IntRow { row in
            row.tag = tag
            row.title = title
            row.placeholder = ph
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }
    }

    func setIntRow_switch(tag: String, title: String, ph: String, value: Int?, switchTag: String){
        form.last! <<< IntRow { row in
            row.tag = tag
            row.title = title
            row.placeholder = ph
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
        }
    }
    
    
    
    
    
    func setDecimalRow(tag: String, title: String, ph: String, value: Double?){
        form.last! <<< DecimalRow { row in
            row.tag = tag
            row.title = title
            row.placeholder = ph
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }
    }
    
    func setDecimalRow_switch(tag: String, title: String, ph: String, value: Double?, switchTag: String){
        form.last! <<< DecimalRow { row in
            row.tag = tag
            row.title = title
            row.placeholder = ph
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
        }
    }
    
    
    
    
    func setLabelRow_String(tag: String, title: String, ph: String, value: String?){
        form.last! <<< TextAreaRow { row in
            row.tag = tag
            row.title = title
            row.placeholder = ph
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }
    }
    
    func setLabelRow_String_switch(tag: String, title: String, ph: String, value: String?, switchTag: String){
        form.last! <<< TextAreaRow { row in
            row.tag = tag
            row.title = title
            row.placeholder = ph
            row.value = value
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
        }
    }

    
    
    
    func setDoublePickerInputRow(tag: String, title: String, value: Tuple<String, String>?){
        form.last! <<< DoublePickerInputRow<String, String>() {
            $0.tag = tag
            $0.title = title
            $0.value = value
            $0.cell.tintColor = textColor
            $0.cell.backgroundColor = contentBackgroundColor
            $0.cellStyle = UITableViewCell.CellStyle.value1
            $0.firstOptions = { return (0...59).map { String($0) + "分" } }
            $0.secondOptions = { minutes in
                var seconds = [String]()
                seconds = (0...59).map { String($0) + "秒" }
                return seconds
            }
            $0.displayValueFor = {
                guard let value = $0 else { return nil }
                return value.a + value.b
            }
        }
    }
    
    func setDoublePickerInputRow_switch(tag: String, title: String, value: Tuple<String, String>?, switchTag: String){
        form.last! <<< DoublePickerInputRow<String, String>() {
            $0.tag = tag
            $0.title = title
            $0.value = value
            $0.cell.tintColor = textColor
            $0.cell.backgroundColor = contentBackgroundColor
            $0.cellStyle = UITableViewCell.CellStyle.value1
            $0.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
            $0.firstOptions = { return (0...59).map { String($0) + "分" } }
            $0.secondOptions = { minutes in
                var seconds = [String]()
                seconds = (0...59).map { String($0) + "秒" }
                return seconds
            }
            $0.displayValueFor = {
                guard let value = $0 else { return nil }
                return value.a + value.b
            }
        }
    }
    
    func setLabelRow(tag: String, title: String, value: String?){
        form.last! <<< LabelRow { row in
            row.tag = tag
            row.title = title
            row.value = value
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
        }.cellUpdate { cell, _ in
            cell.detailTextLabel?.textColor = textColor
        }
    }

    func setLabelRow_switch(tag: String, title: String, value: String?, switchTag: String){
        form.last! <<< LabelRow { row in
            row.tag = tag
            row.title = title
            row.value = value
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
        }.cellUpdate { cell, _ in
            cell.detailTextLabel?.textColor = textColor
        }
    }
    
    
    func setTextAreaRow(tag: String, title: String, ph: String, value: String?){
        form.last! <<< TextAreaRow { row in
            row.tag = tag
            row.title = title
            row.value = value
            row.placeholder = ph
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.cellStyle = UITableViewCell.CellStyle.value1
        }.cellUpdate { cell, _ in
            cell.detailTextLabel?.textColor = textColor
        }
    }
    
    func setTextAreaRow_switch(tag: String, title: String, ph: String, value: String?, switchTag: String){
        form.last! <<< TextAreaRow { row in
            row.tag = tag
            row.title = title
            row.value = value
            row.placeholder = ph
            row.cell.tintColor = textColor
            row.cell.backgroundColor = contentBackgroundColor
            row.cellStyle = UITableViewCell.CellStyle.value1
            row.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
        }.cellUpdate { cell, _ in
            cell.detailTextLabel?.textColor = textColor
        }
    }
    
    func setImageRow(tag: String, savedImage: Data?){
        form.last! <<< ImageRow() {
            $0.tag = tag
            $0.title = "画像"
            $0.sourceTypes = [.PhotoLibrary, .Camera]
            $0.value = UIImage(named: "heli")
            $0.cell.tintColor = textColor
            $0.cell.backgroundColor = contentBackgroundColor
            $0.clearAction = .yes(style: .destructive)
            if savedImage != nil {
                $0.value = UIImage(data: savedImage!)
            }
        }
    }

    func setImageRow_switch(tag: String, savedImage: Data?, switchTag: String){
        form.last! <<< ImageRow() {
            $0.tag = tag
            $0.title = "画像"
            $0.sourceTypes = [.PhotoLibrary, .Camera]
            $0.value = UIImage(named: "heli")
            $0.cell.tintColor = textColor
            $0.cell.backgroundColor = contentBackgroundColor
            $0.clearAction = .yes(style: .destructive)
            $0.hidden = Condition.function([switchTag], { form in
                return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
            })
            if savedImage != nil {
                $0.value = UIImage(data: savedImage!)
            }
        }
    }
    
    
    
    func setViewRow(savedImage: Data?){
        if savedImage != nil {
            form.last! <<< ViewRow<UIImageView>()
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    cell.view = UIImageView()
                    cell.view!.isUserInteractionEnabled = true
                    cell.view!.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.saveImage(_:))))
                    cell.contentView.addSubview(cell.view!)

                    //  Get something to display
                    let image = UIImage(data: savedImage!)
                    cell.view!.image = image
                    
                    //  Make the image view occupy the entire row:
                    cell.viewRightMargin = 0.0
                    cell.viewLeftMargin = 0.0
                    cell.viewTopMargin = 0.0
                    cell.viewBottomMargin = 0.0
                    // オリジナル画像のサイズからアスペクト比を計算
                    let aspectScale = image!.size.height / image!.size.width
                    // widthからアスペクト比を元にリサイズ後のサイズを取得
                    let screenW:CGFloat = self.view.frame.size.width
                    let resizedSizeHeight = screenW * Double(aspectScale)
                    cell.height = { return CGFloat(resizedSizeHeight) }
                }
        }
    }
    
    func setViewRow_switch(savedImage: Data?, switchTag: String){
        if savedImage != nil {
            form.last! <<< ViewRow<UIImageView>(){
                $0.hidden = Condition.function([switchTag], { form in
                    return !((form.rowBy(tag: switchTag) as? SwitchRow)?.value ?? false)
                })
            }
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    cell.view = UIImageView()
                    cell.view!.isUserInteractionEnabled = true
                    cell.view!.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.saveImage(_:))))
                    cell.contentView.addSubview(cell.view!)

                    //  Get something to display
                    let image = UIImage(data: savedImage!)
                    cell.view!.image = image
                    
                    //  Make the image view occupy the entire row:
                    cell.viewRightMargin = 0.0
                    cell.viewLeftMargin = 0.0
                    cell.viewTopMargin = 0.0
                    cell.viewBottomMargin = 0.0
                    // オリジナル画像のサイズからアスペクト比を計算
                    let aspectScale = image!.size.height / image!.size.width
                    // widthからアスペクト比を元にリサイズ後のサイズを取得
                    let screenW:CGFloat = self.view.frame.size.width
                    let resizedSizeHeight = screenW * Double(aspectScale)
                    cell.height = { return CGFloat(resizedSizeHeight) }
                }
        }
    }

    @objc func saveImage(_ sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: "保存", message: "カメラロールへ保存しますか？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
            print("キャンセルが押されました")
        })
        let save = UIAlertAction(title: "保存", style: .default, handler: { (action) -> Void in
            print("保存ボタンが押されました")
            // クリックした UIImageView を取得
            let targetImageView = sender.view! as! UIImageView
            // その中の UIImage を取得
            let targetImage = targetImageView.image!
            // UIImage の画像をカメラロールに画像を保存
            UIImageWriteToSavedPhotosAlbum(targetImage,nil,nil,nil)
        })
        
        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated: true, completion: nil)
    }
  
}
