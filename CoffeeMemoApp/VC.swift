//
//  ViewController.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/03/06.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var toReviewButton: UIButton!
    @IBOutlet weak var toBeanButton: UIButton!
    @IBOutlet weak var toDripButton: UIButton!
    @IBOutlet weak var toGraindButton: UIButton!
    
    // UIButtonを生成する
    let plusButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "コーヒーメモ"

        //UIButtonのタイプを選択
        toReviewButton.configuration = .filled()
        toBeanButton.configuration = .filled()
        toDripButton.configuration = .filled()
        toGraindButton.configuration = .filled()
        
        //UIButton.Configurationを用いて、ボタンの詳細を変更
        var config = UIButton.Configuration.filled()
        //共通項目分
        config.titleAlignment = .center
        config.titlePadding = 20.0
        config.baseBackgroundColor = contentBackgroundColor//背景色
        config.baseForegroundColor = textColor//文字の色
        config.imagePadding = 8.0
        config.imagePlacement = .leading
        //レビュー部分
        config.title = "レビュー　"
        config.image = UIImage(systemName: "book",
                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        toReviewButton.configuration = config
        //コーヒー豆分
        config.title = "コーヒー豆"
        config.image = UIImage(systemName: "oval.portrait",
                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        toBeanButton.configuration = config
        //抽出方法分
        config.title = "抽出方法"
        config.image = UIImage(systemName: "drop",
                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        toDripButton.configuration = config
        //挽き方分
        config.title = "挽き方　"
        config.image = UIImage(systemName: "aqi.low",
                               withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        toGraindButton.configuration = config
        //フォントサイズの変更
        toReviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        toBeanButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        toDripButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        toGraindButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        //ボタンの作成と配置
        setPlusButton(button: plusButton)
        
        
    }
    
}

