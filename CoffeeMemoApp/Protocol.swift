//
//  Protocol.swift
//  CoffeeMemoApp
//
//  Created by Ryo Endo on 2022/07/05.
//

import Foundation

protocol SendBeanDelegate: AnyObject {
    func sendBeanValue(id: String?)
}


protocol SendDripDelegate: AnyObject {
    func sendDripValue(id: String?)
}


protocol SendGrindDelegate: AnyObject {
    func sendGrindValue(id: String?)
}

