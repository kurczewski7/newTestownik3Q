//
//  PictureLibrary.swift
//  testownik
//
//  Created by Sławek K on 22/03/2022.
//  Copyright © 2022 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import UIKit

    typealias PictType = [String : Data]
    class PictureLibrary {
        enum UperLowerMode {
            case lowerCase
            case upperCase
            case userCase
        }
    var pictureList: PictType = [:]
    var uperLowerMode = UperLowerMode.lowerCase
    var count: Int {
        get {      return pictureList.count         }
    }
    private func add(forName key: PictType.Key, value: PictType.Value) {
        pictureList[key] = value
    }
    func addData(forName key: String, value: Data?) {
        if let val = value {
            add(forName: normalizeKey(key: key), value: val)
        }
    }
    func addUImage(forName key: String, value: UIImage?) {
        if let val = value, let data = val.pngData() {
             add(forName: normalizeKey(key: key), value: data)
        }
    }
    func normalizeKey(key: String) -> String {
        var retVal = ""
        switch uperLowerMode {
            case .lowerCase:
                retVal = key.lowercased()
            case .upperCase:
                retVal = key.uppercased()
            case .userCase:
                retVal = key.uppercased()
        }
        print("Key befor:\(key):\(retVal)")
        return retVal
    }
    func removeAll() {
        pictureList.removeAll()
    }
    func giveAsData(_ name: String)  -> Data? {
        return pictureList[normalizeKey(key: name)]
    }
    func giveAsImage(_ name: String)  -> UIImage? {
        var image: UIImage? = nil
        if let tmpData = pictureList[normalizeKey(key: name)] {
            image = UIImage(data: tmpData)
        }
        return  image
    }
    func give(forName key: PictType.Key) -> PictType.Value? {
        return pictureList[normalizeKey(key: key)]
    }    
    func giveDemoImage(_ name: String = "001.png") -> UIImage? {
        return  UIImage(named: name)
    }
}
