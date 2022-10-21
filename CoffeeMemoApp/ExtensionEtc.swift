//
//  Extension.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/07/13.
//

import Foundation
import UIKit

extension String {
    enum JPCharacter {
        case hiragana
        case katakana
        fileprivate var transform: CFString {
            switch self {
            case .hiragana:
                return kCFStringTransformLatinHiragana
            case .katakana:
                return kCFStringTransformLatinKatakana
            }
        }
    }

    static func convert(_ text: String, to jpCharacter: JPCharacter) -> String {
        let input = text.trimmingCharacters(in: .whitespacesAndNewlines)
        var output = ""
        let locale = CFLocaleCreate(kCFAllocatorDefault, CFLocaleCreateCanonicalLanguageIdentifierFromString(kCFAllocatorDefault, "ja" as CFString))
        let range = CFRangeMake(0, input.utf16.count)
        let tokenizer = CFStringTokenizerCreate(
            kCFAllocatorDefault,
            input as CFString,
            range,
            kCFStringTokenizerUnitWordBoundary,
            locale
        )

        var tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)
        while (tokenType.rawValue != 0) {
            if let text = (CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription) as? NSString).map({ $0.mutableCopy() }) {
                CFStringTransform((text as! CFMutableString), nil, jpCharacter.transform, false)
                output.append(text as! String)
            }
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        return output
    }
    
    func isAlphanumeric() -> Bool {
      return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var toKatakana: String? {
            return self.applyingTransform(.hiraganaToKatakana, reverse: false)
    }
    
    func convertKana() -> String? {
        let nsTag_namae = self as NSString
        let initialBool = nsTag_namae.substring(to: 1).isAlphanumeric()
        //真偽に応じて、小文字への変換、小文字変換・ひらがなを変換・漢字を変換（カタカナへ）
        let tag_ForSortNamae: String?
        if initialBool {
            tag_ForSortNamae = self.lowercased()
        }else{
            let text = self.lowercased().toKatakana!
            tag_ForSortNamae = String.convert(text, to: .katakana)
        }
        return tag_ForSortNamae
    }
    
}



extension UIImage {
    //縦横比を維持したまま、画像のサイズ変更
    func reSizeImage() -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()

        let originalWidth = image.size.width
        let originalHeight = image.size.height

        let resizeSize = CGSize(width: originalWidth, height: originalHeight)
        UIGraphicsBeginImageContext(resizeSize)

        image.draw(in: CGRect(x: 0, y: 0, width: originalWidth, height: originalHeight))

        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
}



extension UIViewController {
    private final class StatusBarView: UIView { }
    //ステータスバー　背景色の変更
    func setStatusBarBackgroundColor(_ color: UIColor?) {
        for subView in self.view.subviews where subView is StatusBarView {
            subView.removeFromSuperview()
        }
        guard let color = color else {
            return
        }
        let statusBarView = StatusBarView()
        statusBarView.backgroundColor = color
        self.view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        statusBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        statusBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}


extension Date {
    //Date型ー＞String型への変換関数（返り値：String）
    func dateToString() -> String? {
        let date = self
        let dateFormatter = DateFormatter()
        guard let formatString = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        else { fatalError() }
        
        dateFormatter.dateFormat = formatString
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}






