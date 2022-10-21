//
//  OriginalTabBarControllerViewController.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/04/06.
//

import UIKit

class OriginalTabBarControllerViewController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
   
        // 画像と文字の選択時の色を指定（未選択字の色はデフォルトのまま）
        UITabBar.appearance().tintColor = textColor

        //背景色の変更
        UITabBar.appearance().backgroundColor = barColor


    }
    



}
