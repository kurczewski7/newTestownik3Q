//
//  UIView+Ext.swift
//  testownik
//
//  Created by Slawek Kurczewski on 18/10/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import UIKit

extension UIView {
    enum TypeAnim {
        case fade
        case moveIn
        case push
        case reveal
    }
    enum SubTypeAnim {
        case fromRight
        case fromLeft
        case fromTop
        case fromBottom
    }
    enum TimingAnim {
        case linear
        case easeIn
        case easeOut
        case easeInEaseOut
        case defaultTiming
    }
    
    func userAnimation(_ duration: CFTimeInterval, type: TypeAnim, subType: SubTypeAnim, timing: TimingAnim = TimingAnim.defaultTiming)  {
        var aType    = CATransitionType.push
        var aSubType = CATransitionSubtype.fromLeft
        var aTiming  = CAMediaTimingFunctionName.easeInEaseOut
        switch type {
            case .fade:     aType = CATransitionType.fade
            case .moveIn:   aType = CATransitionType.moveIn
            case .push:     aType = CATransitionType.push
            case .reveal:   aType = CATransitionType.reveal
        }
        switch subType {
            case .fromRight:    aSubType = CATransitionSubtype.fromRight
            case .fromLeft:     aSubType = CATransitionSubtype.fromLeft
            case .fromTop:      aSubType = CATransitionSubtype.fromTop
            case .fromBottom:   aSubType = CATransitionSubtype.fromBottom
        }
        switch timing {
            case .linear:        aTiming = CAMediaTimingFunctionName.linear
            case .easeIn:        aTiming = CAMediaTimingFunctionName.easeIn
            case .easeOut:       aTiming = CAMediaTimingFunctionName.easeOut
            case .easeInEaseOut: aTiming = CAMediaTimingFunctionName.easeInEaseOut
            case .defaultTiming: aTiming = CAMediaTimingFunctionName.default
        }

        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: aTiming)
        animation.type = aType
        animation.subtype = aSubType
        animation.duration = duration
        //layer.add(animation, forKey: CATransitionType.push)
        layer.add(animation, forKey: "CATransitionType.push")
    }
    //                UIView.animate(withDuration: 0.5, animations: {
    //                    self.fadedView.alpha = 0.0
    //                }) { (finished) in
    //                    self.fadedView.isHidden = true
    //                    self.recordingView.isHidden = true
    //                    self.tableView.reloadData()
    //                }

}
extension Array  {
    typealias IndexValue = (index: Int, value: Element)
    
    func isNotEmpty() -> Bool {
        return !self.isEmpty
    }
    func last() -> Element? {
        guard self.count > 0 else { return nil }
        return self[self.count - 1]
    }
    func isInRange(_ index: Int) -> Bool {
        return index >= 0 && index < self.count
    }
    func isLast(_ index: Int) -> Bool {
        return index == self.count - 1
    }
    func isExistNext(_ index: Int) -> Bool {
        return index >= 0 && index < self.count - 1
    }
    // MARKT : Method randomOrder: for toMax = 10 get from 0 to 9
    func randomOrder(toMax: Int) -> Int {
        return Int(arc4random_uniform(UInt32(toMax)))
    }
    func randomRange(_ range: Range<Int>) -> Int {
        return Int.random(in: range)
    }
    func changeSubArryyOrder(forSubArray array: [Element], fromPosition start: Int, count: Int) -> [Element] {
        //let array = self
        var position = 0
        var sortedArray = [Element]()
        let len = array.count
        let newLen = Swift.min(array.endIndex, count)
        let end = array.index(array.startIndex, offsetBy: newLen)
        //let end = array.index(start, offsetBy: count, limitedBy: len) ?? len
        //array.index(start, offsetBy: count)
        guard start < len, end <= len else {   return sortedArray      }
        var tmpArray = Array(array[start..<end])
        guard tmpArray.count > 0 else {   return sortedArray      }
        for _ in 1...tmpArray.count {
            position = self.randomOrder(toMax: tmpArray.count)
            sortedArray.append(tmpArray[position])
            tmpArray.remove(at: position)
        }
        return sortedArray
    } 
    mutating func getFirsElement(deleteItAfter delete: Bool) -> Element? {
        var retVal: Element
        guard self.isNotEmpty() else { return nil }
        retVal = self.first!
        if delete {
            self.remove(at: 0)
        }
        return retVal
    }
    mutating func getElement(forIndex index : Int, deleteItAfter delete: Bool) -> Element? {
        var retVal: Element
        guard self.isInRange(index) else { return nil }
        retVal = self[index]
        if delete {
            self.remove(at: index)
        }
        return retVal
    }
    mutating func getRandomElement(deleteItAfter delete: Bool) -> Element? {
        var retVal: Element
        guard self.count > 0 else { return nil }
        guard self.count > 1 else {
            retVal = self[0]
            if delete {
                self.remove(at: 0)
            }
            return retVal
        }
        //let idx = randomOrder(toMax: self.count)
        let idx = randomRange(0..<self.count)
        print("IDX:   \(idx)")
        guard self.isInRange(idx) else { return nil }
        retVal = self[idx]
        if delete {
            self.remove(at: idx)
        }
        return retVal
    }
    mutating func getRandomElemIndexValue(deleteItAfter delete: Bool) -> IndexValue? {
        var retVal: IndexValue
        guard self.count > 0 else { return nil }
        guard self.count > 1 else {
            retVal.value = self[0]
            retVal.index = 0
            if delete {
                self.remove(at: 0)
            }
            return retVal
        }
        //let idx = randomOrder(toMax: self.count)
        let idx = randomRange(0..<self.count)
        print("IDX:   \(idx)")
        guard self.isInRange(idx) else { return nil }
        retVal.value = self[idx]
        retVal.index = idx
        if delete {
            self.remove(at: idx)
        }
        return retVal
    }

    func createSortKey() -> [Int] {
        let len = self.count
        guard len > 0 else { return [Int]() }
        var position = 0
        var sortedArray = [Int]()
        var tmpArray: [Int] = [Int](repeating: 0, count: len)
        for i in 0..<len {
            tmpArray[i] = i
        }
        sortedArray.removeAll()
        for _ in 1...tmpArray.count {
            position = self.randomOrder(toMax: tmpArray.count)
            sortedArray.append(tmpArray[position])
            tmpArray.remove(at: position)
        }
        return sortedArray
    }
    func sortArray(forUserKey aKey: [Int]?) -> [Element] {
        // [aa, bb, cc] ->  [bb, cc, aa]
        var retVal: [Element] = [Element]()
//        if key == nil {
//            return self
//        } else if key!.isEmpty  {
//            return self
//        }
        guard let key = aKey else { return self }
        guard key.isEmpty else { return self }        
        let len = Swift.min(self.count, key.count)
         // [1, 2, 0]
        for i in 0..<len {
            retVal.append(self[key[i]])
        }
        return retVal
    }
    func reversSortArray(forUserKey key: [Int]) -> [Element] {
        let len = Swift.min(self.count, key.count)
        var retVal: [Element] = [Element]()          // [1, 2, 0]
        for _ in 0..<len {
            retVal.append(self[0])
        }
        for i in 0..<len {                          // [1, 2, 0]        [bb, cc, aa] -> [aa  , bb , cc ]
            retVal[key[i]] = self[i]
        }
        return retVal
    }
    //historycalTest.removeElem({$0.fileNumber == 2 ? true : false})
    mutating func removeElem(_ conditionForDelete: (Self.Element) -> Bool)  -> [Element] {
        var index = -1
        guard self.isNotEmpty() else { return [] }
        let tmpArr = self.map(conditionForDelete)
        print("tmpArr: \(tmpArr)")
        for i  in (0..<tmpArr.count).reversed() {
            if tmpArr[i] == true {
                index = i
                break
            }
        }
        if index >= 0 {
            self.remove(at: index)
        }
        return self
    }
}

