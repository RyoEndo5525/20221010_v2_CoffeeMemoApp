//
//  NavigationVC.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/04/06.
//

import UIKit

class NavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //大きなタイトルを挿入
        navigationBar.prefersLargeTitles = true
        
        // always / never / automatic から選ぶ
        navigationItem.largeTitleDisplayMode = .always
        
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = textColor
    }
}
