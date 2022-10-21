//
//  ReviewTableViewCell.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/07/16.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //フォント・サイズ
        label1.font = UIFont.boldSystemFont(ofSize: 20)
        label2.font = label2.font.withSize(12)
        label3.font = label3.font.withSize(9)
        label4.font = label4.font.withSize(12)
        
        //テキストの色
        label2.textColor = UIColor(named: "SubTextColor")!
        label3.textColor = UIColor(named: "SubTextColor")!
        label4.textColor = UIColor(named: "SubTextColor")!
        
        //テキストの寄せ
        label3.textAlignment = NSTextAlignment.right
        label4.textAlignment = NSTextAlignment.right
        
        label2.numberOfLines = 2
        label2.lineBreakMode = .byTruncatingTail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
