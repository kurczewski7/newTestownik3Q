//
//  Messaes.swift
//  testownik
//
//  Created by Slawek Kurczewski on 19/09/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import Foundation

//var responseMessages = [200: "OK",
//                        403: "Access forbidden",
//                        404: "File not found",
//                        500: "Internal server error"]

//var emptyDict: [String: String] = [:]
//namesOfIntegers[16] = "sixteen"
//var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

class Messaes {
    enum Lang: Int {
        case en = 0
        case ge = 1
        case fr = 2
        case sp = 3
        case pl = 5
    }
    enum Mess: String {
        case attention = "attention"
        case cancel    = "cancel"
    }
    var messageArray: [String] = [String]()
    var dict : [Mess : [String]] = [:]
    func fill() {
        dict[.attention] = ["Attention","Beachtung","Attention","Atención","Uwaga"]
        dict[.cancel]    = ["Cancel","Abbrechen","Annuler","Cancelar","Anuluj"]
    }
}
